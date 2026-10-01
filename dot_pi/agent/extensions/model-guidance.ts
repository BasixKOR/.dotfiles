import { readFile, stat } from "node:fs/promises";
import { dirname, isAbsolute, join, relative, resolve, sep } from "node:path";
import {
  getAgentDir,
  type ContextWithSystemEvent,
  type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { Value } from "typebox/value";

type AgentMessage = ContextWithSystemEvent["messages"][number];
type SystemMessage = Extract<AgentMessage, { role: "system" }>;

const SECTION = "model_guidance";
const CLOSE_TAG = `</${SECTION}>`;
const MAX_MANIFEST_BYTES = 65_536;
const MAX_FILE_BYTES = 65_536;
const MAX_GUIDANCE_BYTES = 65_536;

const ManifestSchema = Type.Object(
  {
    rules: Type.Array(
      Type.Object(
        {
          models: Type.Array(Type.String({ pattern: "^[^/\\s]+/\\S+$" }), { minItems: 1 }),
          files: Type.Array(Type.String({ minLength: 1 }), { minItems: 1 }),
        },
        { additionalProperties: false },
      ),
    ),
  },
  { additionalProperties: false },
);

export class GuidanceConfigError extends Error {}

function isFsError(error: unknown): error is NodeJS.ErrnoException {
  return error instanceof Error && "code" in error && typeof error.code === "string";
}

async function readBounded(path: string, limit: number): Promise<string> {
  try {
    const info = await stat(path);
    if (!info.isFile()) throw new GuidanceConfigError(`${path} is not a regular file`);
    if (info.size > limit) throw new GuidanceConfigError(`${path} exceeds ${limit} bytes`);
    const text = await readFile(path, "utf8");
    if (Buffer.byteLength(text) > limit) {
      throw new GuidanceConfigError(`${path} exceeds ${limit} bytes`);
    }
    return text.startsWith("\uFEFF") ? text.slice(1) : text;
  } catch (error) {
    if (isFsError(error)) throw new GuidanceConfigError(`cannot read ${path} (${error.code})`);
    throw error;
  }
}

function resolveGuidancePath(root: string, file: string): string {
  if (isAbsolute(file) || !file.endsWith(".md")) {
    throw new GuidanceConfigError(`guidance file "${file}" must be a relative .md path`);
  }
  const path = resolve(root, file);
  const fromRoot = relative(root, path);
  if (fromRoot === "" || fromRoot === ".." || fromRoot.startsWith(`..${sep}`)) {
    throw new GuidanceConfigError(`guidance file "${file}" is outside ${root}`);
  }
  return path;
}

async function readGuidanceFile(path: string): Promise<string> {
  const text = (await readBounded(path, MAX_FILE_BYTES)).trim();
  if (!text) throw new GuidanceConfigError(`${path} is empty`);
  if (text.includes(CLOSE_TAG)) throw new GuidanceConfigError(`${path} contains ${CLOSE_TAG}`);
  return text;
}

async function parseManifest(manifestPath: string): Promise<unknown> {
  const source = await readBounded(manifestPath, MAX_MANIFEST_BYTES);
  try {
    return JSON.parse(source);
  } catch (error) {
    if (error instanceof SyntaxError) {
      throw new GuidanceConfigError(`${manifestPath} is not valid JSON: ${error.message}`);
    }
    throw error;
  }
}

/** Maps each exact `provider/model` ID to its rendered guidance section. */
export async function loadGuidance(manifestPath: string): Promise<ReadonlyMap<string, string>> {
  const manifest = await parseManifest(manifestPath);
  if (!Value.Check(ManifestSchema, manifest)) {
    const [issue] = Value.Errors(ManifestSchema, manifest);
    const detail = issue ? `${issue.instancePath || "/"} ${issue.message}` : "schema mismatch";
    throw new GuidanceConfigError(`${manifestPath} is invalid: ${detail}`);
  }

  const root = dirname(manifestPath);
  const filesByModel = new Map<string, string[]>();
  for (const rule of manifest.rules) {
    const files = rule.files.map((file) => resolveGuidancePath(root, file));
    for (const model of rule.models) {
      const selected = filesByModel.get(model) ?? [];
      for (const file of files) if (!selected.includes(file)) selected.push(file);
      filesByModel.set(model, selected);
    }
  }

  const uniqueFiles = [...new Set([...filesByModel.values()].flat())];
  const texts = await Promise.all(uniqueFiles.map(readGuidanceFile));
  const textByFile = new Map(uniqueFiles.map((file, index) => [file, texts[index] ?? ""]));

  const guidance = new Map<string, string>();
  for (const [model, files] of filesByModel) {
    const body = files.map((file) => textByFile.get(file) ?? "").join("\n\n");
    if (Buffer.byteLength(body) > MAX_GUIDANCE_BYTES) {
      throw new GuidanceConfigError(`guidance for ${model} exceeds ${MAX_GUIDANCE_BYTES} bytes`);
    }
    guidance.set(model, `<${SECTION}>\n${body}\n${CLOSE_TAG}`);
  }
  return guidance;
}

function isSystemMessage(message: AgentMessage | undefined): message is SystemMessage {
  return message?.role === "system";
}

/** Sets or removes the owned section on the leading system message, or returns undefined when unchanged. */
export function projectGuidance(
  messages: readonly AgentMessage[],
  section: string | undefined,
): AgentMessage[] | undefined {
  const head = messages[0];
  if (!isSystemMessage(head)) return undefined;
  const sections = head.sections ?? {};
  const present = Object.hasOwn(sections, SECTION);
  if (section === undefined ? !present : sections[SECTION] === section) return undefined;

  const next = Object.entries(sections).flatMap(([name, value]): [string, string | null][] => {
    if (name !== SECTION) return [[name, value]];
    return section === undefined ? [] : [[name, section]];
  });
  if (section !== undefined && !present) next.push([SECTION, section]);
  return [{ ...head, sections: Object.fromEntries(next) }, ...messages.slice(1)];
}

export default async function modelGuidance(pi: ExtensionAPI): Promise<void> {
  const manifestPath = join(getAgentDir(), "model-guidance", "config.json");
  let guidance: ReadonlyMap<string, string> = new Map();
  let diagnostic: string | undefined;
  try {
    guidance = await loadGuidance(manifestPath);
  } catch (error) {
    if (!(error instanceof GuidanceConfigError)) throw error;
    diagnostic = error.message;
  }

  pi.on("session_start", (_event, ctx) => {
    if (diagnostic) ctx.ui.notify(`Model guidance disabled: ${diagnostic}`, "error");
  });

  pi.on("context_with_system", (event, ctx) => {
    const model = ctx.model;
    const section = model ? guidance.get(`${model.provider}/${model.id}`) : undefined;
    const messages = projectGuidance(event.messages, section);
    return messages ? { messages } : undefined;
  });
}
