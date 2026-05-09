export const NotificationPlugin = async ({ $ }) => {
  const notify = (msg) => $`notify-send --app-name="OpenCode" "OpenCode" ${msg}`;
  const bell = () => $`canberra-gtk-play --id=complete`;

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
