import { createAltLayer, app, tmuxSession } from './utils'


  // ps aux | grep -i "Applications" | awk '{print $11}' | cut -d '/' -f 3 | sort | uniq
export const openAppMaps = createAltLayer({
  1: app("1Password"),
  // f: app("Finder"),
  u: app("Mail"),
  m: app("Telegram"),
  g: app("Google Chrome"),
  p: app("Postman"),
  v: app("Visual Studio Code"),
  n: app("Notes"),
  s: app("Slack"),
  t: tmuxSession("scout"),
  c: app("WezTerm"),
  e: app("DBeaver"),
  d: app("Docker Desktop"),
  y: app("System Settings"),
  o: app("MongoDB Compass"),
  a: app("Activity Monitor"),
  b: app("Karabiner-Elements"),
  i: app("Discord"),
  z: app("zoom.us"),
  x: tmuxSession("config"),
})
