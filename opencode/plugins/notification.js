export const NotificationPlugin = async ({ $ }) => {
  const notify = (msg) => $`notify-send "OpenCode" ${msg}`;
  const bell = () => $`printf '\a'`;

  return {
    event: async ({ event }) => {
      switch (event.type) {
        case "session.idle":
          await notify("Session completed");
          break;
        case "permission.asked":
          await notify("Permission requested");
          break;
        case "question.asked":
          await notify("Question asked");
          break;
        case "session.error":
          await notify("Session error");
          break;
      }
      bell();
    },
  };
};
