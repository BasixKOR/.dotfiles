import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const VIM_EXIT = /^:(?:w?q|x)a?!?$/;

function exit(ctx: ExtensionContext) {
  // Stop any in-flight agent turn so shutdown isn't deferred.
  if (!ctx.isIdle()) ctx.abort();
  ctx.shutdown();
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("exit", {
    description: "Exit Pi immediately",
    handler: async (_args, ctx) => exit(ctx),
  });

  pi.on("input", async (event, ctx) => {
    if (event.source === "extension" || !VIM_EXIT.test(event.text.trim())) {
      return { action: "continue" };
    }
    exit(ctx);
    return { action: "handled" };
  });
}
