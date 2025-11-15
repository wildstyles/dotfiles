import { createAltLayer, app, shell, tmuxSession } from "./utils";

// ps aux | grep -i "Applications" | awk '{print $11}' | cut -d '/' -f 3 | sort | uniq
export const openAppMaps = createAltLayer({
  // that triggers next instance of app. Forwards to mac's keyboard hotkey
  slash: {
    to: [
      {
        modifiers: ["shift", "control", "command"],
        key_code: "right_arrow",
      },
    ],
  },
  3: shell(["~/Projects/dotfiles/scripts/toggle-karabiner-profile.sh"]),
  1: app("1Password"),
  f: app("Finder"),
  u: app("Mail"),
  m: app("Telegram"),
  g: app("Google Chrome"),
  p: app("Postman"),
  v: app("Visual Studio Code"),
  n: app("Numbers"),
  s: app("Slack"),
  t: tmuxSession("scout"),
  c: app("WezTerm"),
  e: app("DBeaver"),
  d: app("Docker Desktop"),
  y: app("System Settings"),
  o: app("MongoDB Compass"),
  a: app("Activity Monitor"),
  b: app("Karabiner-Elements"),
  k: app("Karabiner-EventViewer"),
  i: app("Discord"),
  z: app("zoom.us"),
  x: tmuxSession("dotfiles"),
});
