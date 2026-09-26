import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.registerCommand("exit", {
    description: "Exit Pi immediately",
    handler: async (_args, ctx) => {
      // Stop any in-flight agent turn so shutdown isn't deferred.
      if (!ctx.isIdle()) ctx.abort();
      ctx.shutdown();
    },
  });
}
