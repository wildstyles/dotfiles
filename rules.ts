import fs from "fs";
import { KarabinerRules } from "./types";
import {
  tmuxSession,
  tmuxWindow,
  createHyperSubLayers,
  createColemakRemap,
  rectangle,
  createAltLayer,
  app,
  shell,
  open,
  createChromeRemap,
} from "./utils";

const colemakToQwertyRemap = [
  createColemakRemap("s", "r"),
  createColemakRemap("d", "s"),
  createColemakRemap("f", "t"),
  createColemakRemap("e", "f"),
  createColemakRemap("r", "p"),
  createColemakRemap("t", "b"),
  createColemakRemap("v", "d"),
  createColemakRemap("b", "v"),

  createColemakRemap("y", "j"),
  createColemakRemap("u", "l"),
  createColemakRemap("i", "u"),
  createColemakRemap("o", "y"),
  createColemakRemap("p", "semicolon"),
  createColemakRemap("h", "m"),
  createColemakRemap("j", "n"),
  createColemakRemap("k", "e"),
  createColemakRemap("l", "i"),
  createColemakRemap("semicolon", "o"),
  createColemakRemap("n", "k"),
  createColemakRemap("m", "h"),
];
// you can try to remap vimium keybindings to native chrome ones :)

const chromeRemaps = [
  createChromeRemap(
    { key_code: "i", modifiers: { mandatory: ["control" ] } },
    [{ key_code: "right_arrow", modifiers: ["command", "option"] }]
  ),
  createChromeRemap(
    { key_code: "m", modifiers: { mandatory: ["control" ] } },
    [{ key_code: "left_arrow", modifiers: ["command", "option"] }]
  ),
  // open bookmarks
  createChromeRemap(
    { key_code: "b", modifiers: { mandatory: ["shift", "command"] } },
    [{ key_code: "b", modifiers: ["command", "option"] }]
  ),
  // add bookmark
  createChromeRemap({ key_code: "b", modifiers: { mandatory: ["control", 'shift'] } }, [
    { key_code: "d", modifiers: ["command"] },
  ]),
  // open history
  createChromeRemap({ key_code: "h", modifiers: { mandatory: ["command"] } }, [
    { key_code: "y", modifiers: ["command"] },
  ]),
  // open devtools
  createChromeRemap({ key_code: "d", modifiers: { mandatory: ["command"] } }, [
    { key_code: "i", modifiers: ["option", "command"] },
  ]),
];

const rules: KarabinerRules[] = [
  ...chromeRemaps,
  ...colemakToQwertyRemap,
  {
    description: "Change double press of q to escape",
    manipulators: [
      {
        type: "basic",
        from: {
          key_code: "q",
          modifiers: { optional: ["any"] },
        },
        to: [
          { set_variable: { name: "q pressed", value: false } },
          { key_code: "escape" },
        ],
        conditions: [{ type: "variable_if", name: "q pressed", value: true }],
      },
      {
        type: "basic",
        from: {
          key_code: "q",
          modifiers: { optional: ["any"] },
        },
        to: [{ set_variable: { name: "q pressed", value: true } }],
        conditions: [
          {
            identifiers: [
              {
                product_id: 24926,
                vendor_id: 7504,
              },
            ],
            type: "device_if",
          },
          {
            input_sources: [{ language: "en" }],
            type: "input_source_if",
          },
        ],
        to_delayed_action: {
          to_if_invoked: [
            {
              key_code: "q",
              conditions: [
                {
                  type: "variable_if",
                  name: "q pressed",
                  value: true,
                },
              ],
            },
            { set_variable: { name: "q pressed", value: false } },
          ],
          to_if_canceled: [
            {
              key_code: "q",
              conditions: [
                {
                  type: "variable_if",
                  name: "q pressed",
                  value: true,
                },
              ],
            },
            { set_variable: { name: "q pressed", value: false } },
          ],
        },
      },
    ],
  },

  {
    description: "Remap keypad comma/period to comma/period",
    manipulators: [
      {
        type: "basic",
        from: {
          key_code: "keypad_comma",
        },
        to: [{ key_code: "comma" }],
      },
      {
        type: "basic",
        from: {
          key_code: "keypad_period",
        },
        to: [{ key_code: "period" }],
      },
    ],
  },

  ...createAltLayer({
    1: app("1Password"),
    // f: app("Finder"),
    u: app("Mail"),
    m: app("Telegram"),
    g: app("Google Chrome"),
    p: app("Postman"),
    v: app("Visual Studio Code"),
    n: app("Notes"),
    s: app("Slack"),
    t: app("iTerm"),
    c: app("WezTerm"),
    e: app("DBeaver"),
    d: app("Docker Desktop"),
    y: app("System Settings"),
    b: app("Karabiner-Elements"),
    i: app("Discord"),
    z: app("zoom.us"),
  }),

  {
    description: "Hyper Key (⌃⌥⇧⌘)",
    manipulators: [
      {
        description: "Caps Lock -> Hyper Key",
        from: {
          key_code: "caps_lock",
          modifiers: {
            optional: ["any"],
          },
        },
        to: [
          {
            set_variable: {
              name: "hyper",
              value: 1,
            },
          },
          {
            key_code: "left_shift",
            modifiers: ["control", "command", "option"],
          },
        ],
        to_after_key_up: [
          {
            set_variable: {
              name: "hyper",
              value: 0,
            },
          },
        ],
        to_if_alone: [
          {
            key_code: "caps_lock",
          },
        ],
        type: "basic",
      },
    ],
  },

  {
    description: `To dot`,
    manipulators: [
      {
        type: "basic" as const,
        from: {
          key_code: "f2",
          modifiers: {
            mandatory: ["shift", "control", "option"],
          },
        },
        to: [
          {
            modifiers: ["shift"],
            key_code: "7",
          },
        ],
      },
    ],
  },
  {
    description: `To comma`,
    manipulators: [
      {
        type: "basic" as const,
        from: {
          key_code: "f1",
          modifiers: {
            mandatory: ["shift", "control", "option"],
          },
        },
        to: [
          {
            modifiers: ["shift"],
            key_code: "6",
          },
        ],
      },
    ],
  },
  {
    description: `To UK`,
    manipulators: [
      {
        type: "basic" as const,
        from: {
          key_code: "x",
          modifiers: {
            mandatory: ["shift", "control", "option"],
          },
        },
        to: [
          {
            select_input_source: {
              language: "uk",
            },
          },
        ],
      },
    ],
  },
  {
    description: `To EN`,
    manipulators: [
      {
        type: "basic" as const,
        from: {
          key_code: "z",
          modifiers: {
            mandatory: ["shift", "control", "option"],
          },
        },
        to: [
          {
            select_input_source: {
              language: "en",
            },
          },
        ],
      },
    ],
  },
  ...createHyperSubLayers({
    spacebar: open(
      "raycast://extensions/stellate/mxstbr-commands/create-notion-todo"
    ),
    s: {
      v: shell(['~/Projects/karabiner/tunnelblick-connect.sh']),
      x: shell(['~/Projects/karabiner/.config/sketchybar/plugins/mic_click.sh'])
    },
    n: {
      s: open("https://github.com/scoutgg"),
      j: open(
        "https://scoutgaming.atlassian.net/jira/software/c/projects/GAP/boards/17?assignee=712020%3A8f6ea6b1-da5d-4291-a82e-dc862db5a1f0"
      ),
      t: open(
        "https://docs.google.com/spreadsheets/d/1ZSN7hTOy23kp8T6wDZdrbtC0ay0ET_kouRmeXdqGz1c/edit?gid=0#gid=0"
      ),
      c: open("https://calendar.google.com/calendar/u/1/r"),
      m: open("https://meet.google.com/landing?hs=197&authuser=1"),
      g: open("https://github.com/"),
      l: open("https://gitlab.com/scout-gg/api"),
      y: open("https://youtube.com/"),
      o: open("https://olx.ua"),
    },
    w: {
      t: shell(['~/Projects/karabiner/adjust-rectangle-padding.sh']),
      f: rectangle("maximize"),
      m: rectangle("left-half"), // same key where I got left arrow but without layer
      i: rectangle("right-half"),
    },
    t: {
      c: tmuxSession("config"),
      s: tmuxSession("scout"),
    },
    1: tmuxWindow("1"),
    2: tmuxWindow("2"),
    3: tmuxWindow("3"),
    4: tmuxWindow("4"),
    5: tmuxWindow("5"),
    // o = "Open" applications
    o: {
      1: app("1Password"),
      f: app("Finder"),
      u: app("Mail"),
      m: app("Telegram"),
      g: app("Google Chrome"),
      p: app("Postman"),
      v: app("Visual Studio Code"),
      n: app("Notes"),
      s: app("Slack"),
      t: app("iTerm"),
      c: app("WezTerm"),
      e: app("DBeaver"),
      d: app("Docker Desktop"),
      z: app("zoom.us"),
    },
  }),
];

fs.writeFileSync(
  "karabiner.json",
  JSON.stringify(
    {
      profiles: [
        {
          devices: [
            {
              identifiers: {
                is_keyboard: true,
                product_id: 24926,
                vendor_id: 7504,
              },
              manipulate_caps_lock_led: false,
            },

            {
              identifiers: {
                is_keyboard: true,
                product_id: 835,
                vendor_id: 1452,
              },
              manipulate_caps_lock_led: false,
            },
          ],
          name: "Default profile",
          selected: true,
          simple_modifications: [
            {
              from: { key_code: "grave_accent_and_tilde" },
              to: [{ key_code: "non_us_backslash" }],
            },
            {
              from: { key_code: "non_us_backslash" },
              to: [{ key_code: "grave_accent_and_tilde" }],
            },
          ],
          virtual_hid_keyboard: { keyboard_type_v2: "iso" },
          complex_modifications: {
            rules,
          },
        },
      ],
    },
    null,
    4
  )
);
