export const NotificationPlugin = async ({ $ }) => {
  const notify = (msg) => $`notify-send --app-name="OpenCode" "OpenCode" ${msg}`;
  const bell = () => $`canberra-gtk-play --id=complete`;
  const subagentSessions = new Set();

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
          await notify("Session completed");
          await bell();
          break;

        case "session.error": {
          subagentSessions.delete(event.properties.sessionID);
          const err = event.properties.error;
          const errMsg = err?.data?.message
            ? `${err.name}: ${err.data.message}`
            : (err?.name ?? "unknown error");
          await notify(`Session error — ${errMsg}`);
          await bell();
          break;
        }

        case "permission.asked":
          await notify("Permission requested");
          await bell();
          break;

        case "question.asked":
          await notify("Question asked");
          await bell();
          break;
      }
    },
  };
};
