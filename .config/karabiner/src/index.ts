import {
  map,
  rule,
  withMapper,
  withCondition,
  hyperLayer,
  toApp,
  ifApp,
  ifDevice,
  ifInputSource,
  to$,
  writeToProfile,
  ifVar,
  FromKeyCode,
  toSetVar,
  BasicManipulatorBuilder,
} from "karabiner.ts";

import { init } from "./simple-remaps.ts";

const scriptsDir = "~/Projects/dotfiles/scripts";

function rectangle(name: string) {
  return `open -g rectangle://execute-action?name=${name}`;
}

function tmuxSession(name: string) {
  return `open -a WezTerm.app && ~/Projects/dotfiles/scripts/tmux-switch-session.sh ${name}`;
}

function doubleTapMapping(
  from: FromKeyCode,
  to: Parameters<BasicManipulatorBuilder["to"]>,
  description: string,
) {
  const ifVarName = `${from} pressed`;

  return [
    map(from, "optionalAny")
      .description(description)
      .condition(ifVar(ifVarName, true))
      .to(...to)
      .toVar(ifVarName, false),

    map(from, "optionalAny")
      .toVar(ifVarName, true)
      .condition(ifVar("shift pressed", false))
      .toDelayedAction(
        [
          {
            key_code: from as any,
            conditions: [{ type: "variable_if", name: ifVarName, value: true }],
          },
          { set_variable: { name: ifVarName, value: false } },
        ],
        [
          {
            key_code: from as any,
            conditions: [{ type: "variable_if", name: ifVarName, value: true }],
          },
          {
            set_variable: { name: ifVarName, value: false },
          },
        ],
      ),
  ];
}

init();

const rules = [
  rule("Language remaps").manipulators([
    map("x", ["shift", "control", "option"]).toInputSource({
      language: "uk",
    }),
    map("z", ["shift", "control", "option"]).toInputSource({
      language: "en",
    }),
  ]),

  rule("Double tap remaps").manipulators([
    // I had tried to implement double taps with zmk tap-dance first.
    // It has some limitations with shift key: https://github.com/zmkfirmware/zmk/issues/1588
    // I want capitalized letters to be entered immediately.
    // That's why here is an additional "shift pressed variable"
    map("left_shift")
      .toVar("shift pressed", true)
      .to("left_shift")
      .toAfterKeyUp(toSetVar("shift pressed", false)),
    map("right_shift")
      .toVar("shift pressed", true)
      .to("right_shift")
      .toAfterKeyUp(toSetVar("shift pressed", false)),

    ...doubleTapMapping("q", ["escape"], "Double tap q to escape"),
    ...doubleTapMapping("c", ["c", ["command"]], "Double tap c to copy"),
    ...doubleTapMapping("v", ["v", ["command"]], "Double tap v to paste"),
  ]),

  rule("keypad comma/period to comma/period").manipulators([
    map("keypad_comma").to("comma"),
    map("keypad_period").to("period"),
    map("f2", ["shift", "control", "option"]).to("7", ["shift"]),
    map("f1", ["shift", "control", "option"]).to("6", ["shift"]),
  ]),

  rule("Colemak charbdis remap on UK").manipulators([
    withCondition(
      ifDevice({ product_id: 24926, vendor_id: 7504 }),
      ifInputSource({
        language: "uk",
      }),
    )([
      withMapper({
        r: "s",
        s: "d",
        t: "f",
        f: "e",
        p: "r",
        b: "t",
        d: "v",
        v: "b",

        j: "y",
        l: "u",
        u: "i",
        y: "o",
        semicolon: "p",
        m: "h",
        n: "j",
        e: "k",
        i: "l",
        o: "semicolon",
        k: "n",
        h: "m",
      })((k, v) => map(k).to(v as any)),
    ]),
  ]),

  rule("Chrome remaps", ifApp("com.google.Chrome")).manipulators([
    withCondition(ifApp("com.google.Chrome"))([
      map("b", ["control", "option"]).to("d", ["command"]), // add bookmark
      map("h", ["control"]).to("y", ["command"]), // to history
      map("d", ["control", "shift"]).to("i", ["option", "command"]), // devtools
      map("i", ["control"]).to("right_arrow", ["command", "option"]), // to right tab
      map("m", ["control"]).to("left_arrow", ["command", "option"]), // to left tab
      map("x", ["control"]).to("w", ["command"]), // close tab
      map("t", ["control"]).to("t", ["command"]), // new tab
      map("keypad_plus", ["control"]).to("keypad_plus", ["command"]), // size +
      map("keypad_hyphen", ["control"]).to("keypad_hyphen", ["command"]), // size -
      map("semicolon", ["control"]).to("d", ["shift", "option"]), // dark mode
      map("t", ["command"]).toNone(),
      map("w", ["command"]).toNone(),
      map("keypad_hyphen", ["command"]).toNone(),
      map("keypad_plus", ["command"]).toNone(),
    ]),
  ]),

  rule("Navigation remaps").manipulators([
    withCondition(ifApp("^com\\.github\\.wez\\.wezterm$").unless())([
      map("b", ["control"]).to("left_arrow", ["option"]),
      map("b", ["control", "shift"]).to("left_arrow", ["option", "shift"]),
      map("e", ["control"]).to("right_arrow", ["option"]),
      map("e", ["control", "shift"]).to("right_arrow", ["option", "shift"]),
      map("w", ["control"]).to("delete_or_backspace", ["option"]),
    ]),
  ]),

  rule("Hold remaps").manipulators([
    map("f")
      .toIfAlone("f", [], { halt: true })
      .toDelayedAction({ key_code: "f" }, { key_code: "f" })
      .toIfHeldDown(
        "f",
        ["left_command", "left_option", "left_shift", "left_control"],
        { repeat: false },
      ),
    map("s")
      .toIfAlone("s", [], { halt: true })
      .toDelayedAction({ key_code: "s" }, { key_code: "s" })
      .toIfHeldDown(
        "s",
        ["left_command", "left_option", "left_shift", "left_control"],
        { repeat: false },
      ),
  ]),

  rule("Caps Lock > Hyper").manipulators([
    map("caps_lock").toHyper().toIfAlone("delete_or_backspace"),
  ]),

  hyperLayer("slash").configKey((v) =>
    v.toIfAlone("right_arrow", ["shift", "control", "command"]),
  ),

  hyperLayer(3).configKey((v) =>
    v.toIfAlone(to$(`${scriptsDir}/toggle-karabiner-profile.sh`)),
  ),

  hyperLayer(1).configKey((v) => v.toIfAlone(toApp("1Password"))),

  hyperLayer("f").configKey((v) => v.toIfAlone(toApp("Finder"))),

  hyperLayer("u").configKey((v) => v.toIfAlone(toApp("Mail"))),

  hyperLayer("m").configKey((v) => v.toIfAlone(toApp("Telegram"))),

  hyperLayer("g").configKey((v) => v.toIfAlone(toApp("Google Chrome"))),

  hyperLayer("v").configKey((v) => v.toIfAlone(toApp("Visual Studio Code"))),

  hyperLayer("c").configKey((v) => v.toIfAlone(toApp("WezTerm"))),

  hyperLayer("d").configKey((v) => v.toIfAlone(toApp("Docker Desktop"))),

  hyperLayer("o").configKey((v) => v.toIfAlone(toApp("MongoDB Compass"))),

  hyperLayer("a").configKey((v) => v.toIfAlone(toApp("Activity Monitor"))),

  hyperLayer("b").configKey((v) => v.toIfAlone(toApp("Karabiner-Elements"))),

  hyperLayer("k").configKey((v) => v.toIfAlone(toApp("Karabiner-EventViewer"))),

  hyperLayer("i").configKey((v) => v.toIfAlone(toApp("Discord"))),

  hyperLayer("z").configKey((v) => v.toIfAlone(toApp("zoom.us"))),

  hyperLayer("t").configKey((v) => v.toIfAlone(to$(tmuxSession("scout")))),

  hyperLayer("x").configKey((v) => v.toIfAlone(to$(tmuxSession("dotfiles")))),

  hyperLayer("s")
    .configKey((v) => v.toIfAlone(toApp("Slack")))
    .manipulators([
      map("a").to$(`${scriptsDir}/switch-audio-source.sh`),
      map("x").to$(
        "~/Projects/dotfiles/.config/sketchybar/plugins/mic_click.sh",
      ),
      map("v").to$(`${scriptsDir}/tunnelblick-connect.sh`),
      map("y").to(2, ["command", "shift", "option", "control"]),
      map("b").to("b", ["command", "shift", "option", "control"]),
    ]),

  hyperLayer("y")
    .configKey((v) => v.toIfAlone(toApp("System Settings")))
    .manipulators([
      map("s").to$(`${scriptsDir}/toggle-time-tracking.sh "Scout"`),
      map("t").to$(`${scriptsDir}/toggle-time-tracking.sh "Training"`),
    ]),

  hyperLayer("l").manipulators([
    map("p").to$("open https://gitlab.com/scout-gg/api/globpay"),
    map("s").to$("open https://gitlab.com/scout-gg/api/scott"),
    map("g").to$("open https://gitlab.com/scout-gg/api/game-server"),
    map("m").to$("open https://gitlab.com/scout-gg/api/sportyman"),
    map("f").to$("open https://gitlab.com/scout-gg/frontend/sgg-frontend"),
  ]),

  hyperLayer("n")
    .configKey((v) => v.toIfAlone(toApp("Numbers")))
    .manipulators([
      map("s").to$("open https://google.com"),
      map("j").to$(
        "open https://scoutgaming.atlassian.net/jira/software/c/projects/SGG/boards/359?assignee=712020%3A8f6ea6b1-da5d-4291-a82e-dc862db5a1f0",
      ),
      map("t").to$(
        "open https://docs.google.com/spreadsheets/d/1ZSN7hTOy23kp8T6wDZdrbtC0ay0ET_kouRmeXdqGz1c/edit?gid=0#gid=0",
      ),
      map("c").to$("open https://calendar.google.com/calendar/u/1/r"),
      map("m").to$("open https://meet.google.com/landing?hs=197&authuser=1"),
      map("g").to$("open https://github.com/"),
      map("l").to$("open https://gitlab.com/dashboard/todos"),
      map("y").to$("open https://youtube.com/"),
      map("o").to$("open https://olx.ua"),
    ]),

  hyperLayer("w").manipulators([
    map("t").to$(`${scriptsDir}/adjust-rectangle-padding.sh`),
    map("s").to$(`${scriptsDir}/switch-interface-scaling.sh`),
    map("f").to$(rectangle("maximize")),
    map("m").to$(rectangle("left-half")),
    map("i").to$(rectangle("right-half")),
  ]),

  hyperLayer("p")
    .configKey((v) => v.toIfAlone(toApp("Postman")))
    .manipulators([
      map("a").to$(
        `open -a WezTerm.app && ${scriptsDir}/curl-from-clipboard.sh`,
      ),
      map("s").to$(
        `open -a WezTerm.app && ${scriptsDir}/curl-from-clipboard.sh -r -h`,
      ),
    ]),

  hyperLayer("e")
    .configKey((v) => v.toIfAlone(toApp("DBeaver")))
    .manipulators([
      map("l").to$(`${scriptsDir}/run-scout.sh local`),
      map("s").to$(`${scriptsDir}/run-scout.sh stage`),
      map("a").to$(`${scriptsDir}/run-scout.sh qa`),
      map("x").to$(`${scriptsDir}/run-scout.sh stop`),
    ]),
];

writeToProfile(
  {
    name: "Default profile",
    karabinerJsonPath:
      "/Users/ruslanvanzula/Projects/dotfiles/.config/karabiner/karabiner.json",
  },
  rules,
  {
    "basic.to_if_alone_timeout_milliseconds": 250,
    "basic.to_if_held_down_threshold_milliseconds": 250,
  },
);

writeToProfile(
  {
    name: "Laptop profile",
    karabinerJsonPath:
      "/Users/ruslanvanzula/Projects/dotfiles/.config/karabiner/karabiner.json",
  },
  rules,
  {
    "basic.to_if_alone_timeout_milliseconds": 250,
    "basic.to_if_held_down_threshold_milliseconds": 250,
  },
);
