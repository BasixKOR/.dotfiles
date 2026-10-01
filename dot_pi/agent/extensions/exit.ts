import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const EXIT_INPUT = /^(?::(?:w?q|x)a?!?|exit)$/;

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
    if (event.source === "extension" || !EXIT_INPUT.test(event.text.trim())) {
      return { action: "continue" };
    }
    exit(ctx);
    return { action: "handled" };
  });
}
