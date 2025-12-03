import {
  map,
  rule,
  withMapper,
  withCondition,
  hyperLayer,
  toApp,
  ifApp,
  to$,
  writeToProfile,
  ifVar,
  FromKeyCode,
  toSetVar,
  BasicManipulatorBuilder,
} from "karabiner.ts";

import {
  ifUkInputSource,
  ifCharibdisDevice,
  key,
  colemakToQwerty,
  init,
  ifEnInputSource,
} from "./simple-remaps.ts";
import { generateLaptopRules } from "./laptop-remaps.ts";

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
      .condition(
        ifVar("shift pressed", false),
        ifVar("layer-s", 0),
        ifVar("first", 0),
        ifVar("second", 0),
      )
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

const generateRules = (lang: "en" | "uk") => [
  ...generateLaptopRules(lang),

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
  ]),

  rule("Colemak charbdis remap on UK").manipulators([
    withCondition(
      ifCharibdisDevice(),
      ifUkInputSource(),
    )([withMapper(colemakToQwerty)((k, v) => map(k as any).to(v as any))]),
  ]),

  rule("keypad comma/period to comma/period").manipulators([
    map("keypad_comma").to("comma"),
    map("keypad_period").to("period"),
    map("f2", ["shift", "control", "option"])
      .condition(ifUkInputSource())
      .to("7", ["shift"]),
    map("f1", ["shift", "control", "option"])
      .condition(ifUkInputSource())
      .to("6", ["shift"]),

    map("f2", ["shift", "control", "option"])
      .condition(ifEnInputSource())
      .to("comma", ["shift"]),
    map("f1", ["shift", "control", "option"])
      .condition(ifEnInputSource())
      .to("period", ["shift"]),
  ]),

  rule("Slack remaps", ifApp("com.tinyspeck.slackmacgap")).manipulators([
    map(key("k", lang), ["control"]).to("k", ["command"]),
    map(key("k", lang), ["control", "shift"]).to("k", ["shift", "command"]), // dm messages
    map(key("u", lang), ["control"]).to("a", ["command", "shift"]), // unread

    map(key("a", lang), ["control"]).to("m", ["command", "shift"]), //activity
    map(key("keypad_plus", lang), ["control"]).to("o", ["command"]), //upload
    map(key("t", lang), ["control"]).to("t", ["command", "shift"]), //threads view
    map(key("semicolon", lang), ["control"]).to("f6"), //next section
    map(key("semicolon", lang), ["control", "shift"]).to("f6", ["shift"]), // prev section

    map(key("z", lang), ["control"]).to("z", ["command"]), // undo/ unsend
    map(key("slash", lang), ["control"]).to("backslash", ["command", "shift"]), //emoji

    map(key("l", lang), ["control"]).to("u", ["command", "shift"]), //link selected

    map(key("down_arrow", lang), ["control"]).to("down_arrow", [
      "option",
      "shift",
    ]), // prev unread dm
    map(key("up_arrow", lang), ["control"]).to("up_arrow", ["option", "shift"]), // next unread dm
    map(key("i", lang), ["control"]).to("open_bracket", ["command"]), // back on history
    map(key("o", lang), ["control"]).to("close_bracket", ["command"]), // forward on history

    // map(key("down_arrow", lang), ["control"]).to("down_arrow", ["option"]), // down channel dm
    // map(key("up_arrow", lang), ["control"]).to("up_arrow", ["option"]), //up channel dm
  ]),

  rule("Chrome remaps", ifApp("com.google.Chrome")).manipulators([
    map(key("b", lang), ["control", "option"]).to("d", ["command"]), // add bookmark
    map(key("h", lang), ["control"]).to("y", ["command"]), // to history
    map(key("d", lang), ["control", "shift"]).to("i", ["option", "command"]), // devtools
    map(key("i", lang), ["control"]).to("right_arrow", ["command", "option"]), // to right tab
    map(key("m", lang), ["control"]).to("left_arrow", ["command", "option"]), // to left tab
    map(key("x", lang), ["control"]).to("w", ["command"]), // close tab
    map(key("t", lang), ["control"]).to("t", ["command"]), // new tab
    map(key("r", lang), ["control"]).to("r", ["command"]), // reload
    // map(key("right_arrow", lang), ["control"]).to("close_bracket", ["command"]), // prev devtools tab
    // map(key("left_arrow", lang), ["control"]).to("open_bracket", ["command"]), // next devtools tab
    map(key("keypad_plus", lang), ["control"]).to("keypad_plus", ["command"]), // size +
    map(key("keypad_hyphen", lang), ["control"]).to("keypad_hyphen", [
      "command",
    ]), // size -
    map(key("semicolon", lang), ["control"]).to("d", ["shift", "option"]), // dark mode
    map(key("t", lang), ["command"]).toNone(),
    map(key("w", lang), ["command"]).toNone(),
    map(key("keypad_hyphen", lang), ["command"]).toNone(),
    map(key("keypad_plus", lang), ["command"]).toNone(),
  ]),

  rule("Navigation remaps").manipulators([
    withCondition(
      ifApp("^com\\.github\\.wez\\.wezterm$").unless(),
      ifApp("^net\\.kovidgoyal\\.kitty$").unless(),
    )([
      map(key("b", lang), ["control"]).to("left_arrow", ["option"]),
      map(key("b", lang), ["control", "shift"]).to("left_arrow", [
        "option",
        "shift",
      ]),
      map(key("e", lang), ["control"]).to("right_arrow", ["option"]),
      map(key("e", lang), ["control", "shift"]).to("right_arrow", [
        "option",
        "shift",
      ]),
      map(key("z", lang), ["control"]).to("z", ["command"]),
      map(key("w", lang), ["control"]).to("delete_or_backspace", ["option"]),
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
    map("c")
      .toIfAlone("c", [], { halt: true })
      .toDelayedAction({ key_code: "vk_none" }, { key_code: "c" })
      .toIfHeldDown("c", ["left_command"], { repeat: false }),
    map("v")
      .toIfAlone("v", [], { halt: true })
      .toDelayedAction({ key_code: "vk_none" }, { key_code: "v" })
      .toIfHeldDown("v", ["left_command"], { repeat: false }),
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

  hyperLayer(key("f", lang)).configKey((v) => v.toIfAlone(toApp("Finder"))),

  hyperLayer(key("u", lang)).configKey((v) => v.toIfAlone(toApp("Mail"))),

  hyperLayer(key("m", lang)).configKey((v) => v.toIfAlone(toApp("Telegram"))),

  hyperLayer(key("g", lang)).configKey((v) =>
    v.toIfAlone(toApp("Google Chrome")),
  ),

  hyperLayer("c").configKey((v) => v.toIfAlone(toApp("kitty"))),

  hyperLayer("v").configKey((v) => v.toIfAlone("v", ["command"])),

  hyperLayer(key("d", lang)).configKey((v) =>
    v.toIfAlone(toApp("Docker Desktop")),
  ),

  hyperLayer(key("o", lang)).configKey((v) =>
    v.toIfAlone(toApp("MongoDB Compass")),
  ),

  hyperLayer(key("a", lang)).configKey((v) =>
    v.toIfAlone(toApp("Activity Monitor")),
  ),

  hyperLayer(key("b", lang)).configKey((v) =>
    v.toIfAlone(toApp("Karabiner-Elements")),
  ),

  hyperLayer(key("k", lang)).configKey((v) =>
    v.toIfAlone(toApp("Karabiner-EventViewer")),
  ),

  hyperLayer(key("i", lang)).configKey((v) => v.toIfAlone(toApp("Discord"))),

  hyperLayer(key("z", lang)).configKey((v) => v.toIfAlone(toApp("zoom.us"))),

  // hyperLayer(key("t", lang)).configKey((v) =>
  //   v.toIfAlone(to$(tmuxSession("scout"))),
  // ),
  //
  // hyperLayer(key("x", lang)).configKey((v) =>
  //   v.toIfAlone(to$(tmuxSession("dotfiles"))),
  // ),

  hyperLayer(key("x", lang)).configKey((v) =>
    v.toIfAlone(to$(`${scriptsDir}/kitty-switch-session.sh dotfiles`)),
  ),

  hyperLayer(key("t", lang)).configKey((v) =>
    v.toIfAlone(to$(`${scriptsDir}/kitty-switch-session.sh scout`)),
  ),

  hyperLayer(key("s", lang))
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

  hyperLayer(key("y", lang))
    .configKey((v) => v.toIfAlone(toApp("System Settings")))
    .manipulators([
      map("s").to$(`${scriptsDir}/toggle-time-tracking.sh "Scout"`),
      map("t").to$(`${scriptsDir}/toggle-time-tracking.sh "Training"`),
    ]),

  hyperLayer(key("l", lang)).manipulators([
    map("p").to$("open https://gitlab.com/scout-gg/api/globpay"),
    map("s").to$("open https://gitlab.com/scout-gg/api/scott"),
    map("g").to$("open https://gitlab.com/scout-gg/api/game-server"),
    map("m").to$("open https://gitlab.com/scout-gg/api/sportyman"),
    map("f").to$("open https://gitlab.com/scout-gg/frontend/sgg-frontend"),
  ]),

  hyperLayer(key("n", lang))
    .configKey((v) => v.toIfAlone(toApp("Numbers")))
    .manipulators([
      map("v").toApp("Visual Studio Code"),
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

  hyperLayer(key("w", lang)).manipulators([
    map("t").to$(`${scriptsDir}/adjust-rectangle-padding.sh`),
    map("s").to$(`${scriptsDir}/switch-interface-scaling.sh`),
    map("f").to$(rectangle("maximize")),
    map("m").to$(rectangle("left-half")),
    map("i").to$(rectangle("right-half")),
  ]),

  hyperLayer(key("p", lang))
    .configKey((v) => v.toIfAlone(toApp("Postman")))
    .manipulators([
      map("a").to$(
        `open -a WezTerm.app && ${scriptsDir}/curl-from-clipboard.sh`,
      ),
      map("s").to$(
        `open -a WezTerm.app && ${scriptsDir}/curl-from-clipboard.sh -r -h`,
      ),
    ]),

  hyperLayer(key("e", lang))
    .configKey((v) => v.toIfAlone(toApp("DBeaver")))
    .manipulators([
      map("l").to$(`${scriptsDir}/run-scout.sh local`),
      map("s").to$(`${scriptsDir}/run-scout.sh stage`),
      map("a").to$(`${scriptsDir}/run-scout.sh qa`),
      map("x").to$(`${scriptsDir}/run-scout.sh stop`),
    ]),
];

init();

writeToProfile(
  {
    name: "Default profile",
    karabinerJsonPath:
      "/Users/ruslanvanzula/Projects/dotfiles/.config/karabiner/karabiner.json",
  },
  generateRules("en"),
  {
    "basic.to_if_alone_timeout_milliseconds": 250,
    "basic.to_if_held_down_threshold_milliseconds": 250,
  },
);

writeToProfile(
  {
    name: "Laptop profile EN",
    karabinerJsonPath:
      "/Users/ruslanvanzula/Projects/dotfiles/.config/karabiner/karabiner.json",
  },
  generateRules("en"),
  {
    "basic.to_if_alone_timeout_milliseconds": 250,
    "basic.to_if_held_down_threshold_milliseconds": 250,
  },
);

writeToProfile(
  {
    name: "Laptop profile UK",
    karabinerJsonPath:
      "/Users/ruslanvanzula/Projects/dotfiles/.config/karabiner/karabiner.json",
  },
  generateRules("uk"),
  {
    "basic.to_if_alone_timeout_milliseconds": 250,
    "basic.to_if_held_down_threshold_milliseconds": 250,
  },
);
