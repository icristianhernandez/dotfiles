export const NotificationPlugin = async ({ $ }) => {
  const notify = (msg) => $`notify-send --app-name="OpenCode" "OpenCode" ${msg}`;
  const bell = () => $`canberra-gtk-play --id=complete`;
  const subagentSessions = new Set();
  const lastNotified = new Map();
  const DEDUP_MS = 3000;

  const shouldNotify = (type) => {
    const now = Date.now();
    if (now - (lastNotified.get(type) ?? 0) < DEDUP_MS) return false;
    lastNotified.set(type, now);
    return true;
  };

  return {
    event: async ({ event }) => {
      switch (event.type) {
        case "session.created":
          if (event.properties.info.parentID)
            subagentSessions.add(event.properties.info.id);
          break;

        case "session.idle":
          if (subagentSessions.has(event.properties.sessionID)) {
            subagentSessions.delete(event.properties.sessionID);
            break;
          }
          subagentSessions.delete(event.properties.sessionID);
          if (!shouldNotify("idle")) break;
          await notify("Session completed");
          await bell();
          break;

        case "session.error": {
          const isSubagent = subagentSessions.has(event.properties.sessionID);
          subagentSessions.delete(event.properties.sessionID);
          if (isSubagent || !shouldNotify("error")) break;
          const err = event.properties.error;
          const errMsg = err?.data?.message
            ? `${err.name}: ${err.data.message}`
            : (err?.name ?? "unknown error");
          await notify(`Session error — ${errMsg}`);
          await bell();
          break;
        }

        case "permission.asked":
          if (!shouldNotify("permission")) break;
          await notify("Permission requested");
          await bell();
          break;

        case "question.asked":
          if (!shouldNotify("question")) break;
          await notify("Question asked");
          await bell();
          break;
      }
    },
  };
};
