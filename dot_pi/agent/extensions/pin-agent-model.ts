import { existsSync, readdirSync, readFileSync } from "node:fs";
import { basename, join } from "node:path";
import { getAgentDir, parseFrontmatter, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { resolveModel } from "../npm/node_modules/@tintinweb/pi-subagents/dist/model-resolver.js";

type Pin = { type: string; model: string; path: string };

function loadPins(cwd: string): Map<string, Pin> {
  const pins = new Map<string, Pin>();
  const dirs = [
    join(getAgentDir(), "agents"),
    join(cwd, ".agents", "agents"),
    join(cwd, ".pi", "agents"),
  ];
  for (const dir of dirs) {
    if (!existsSync(dir)) continue;
    let files: string[];
    try {
      files = readdirSync(dir).filter((f) => f.endsWith(".md"));
    } catch {
      continue;
    }
    for (const file of files) {
      const path = join(dir, file);
      let fm: Record<string, unknown>;
      try {
        const raw = readFileSync(path, "utf-8");
        fm = parseFrontmatter<Record<string, unknown>>(raw.startsWith("\uFEFF") ? raw.slice(1) : raw).frontmatter;
      } catch {
        continue;
      }
      const declared = typeof fm.name === "string" ? fm.name.trim() : "";
      const type = declared || basename(file, ".md");
      const key = type.toLowerCase();
      const model = typeof fm.model === "string" ? fm.model.trim() : "";
      if (fm.enabled === false || !model || model === "inherit") {
        pins.delete(key);
        continue;
      }
      pins.set(key, { type, model, path });
    }
  }
  return pins;
}

function canonical(input: string, registry: unknown): string | undefined {
  const resolved = resolveModel(input, registry as Parameters<typeof resolveModel>[1]);
  return typeof resolved === "string" ? undefined : `${resolved.provider}/${resolved.id}`;
}

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName !== "Agent") return;
    const input = (event.input ?? {}) as { subagent_type?: unknown; model?: unknown; resume?: unknown };
    if (input.resume) return;
    if (typeof input.subagent_type !== "string" || typeof input.model !== "string") return;
    const requested = input.model.trim();
    if (!requested) return;

    const pin = loadPins(ctx.cwd).get(input.subagent_type.trim().toLowerCase());
    if (!pin) return;

    const pinned = canonical(pin.model, ctx.modelRegistry);
    const asked = canonical(requested, ctx.modelRegistry);
    if (pinned && asked && pinned === asked) return;

    const pinnedLabel = pinned ? `${pin.model} (${pinned})` : `${pin.model} (unavailable)`;
    const askedLabel = asked && asked !== requested ? `${requested} (${asked})` : requested;
    return {
      block: true,
      reason:
        `Agent "${pin.type}" is pinned to model ${pinnedLabel} in ${pin.path}; ` +
        `refusing requested model ${askedLabel}. Retry without the model parameter.`,
    };
  });
}
