import fs from "fs";
import { KarabinerRules } from "./types";
import {
  createHyperSubLayers,
  createAltLayer,
  app,
  open,
  rectangle,
  shell,
} from "./utils";

const rules: KarabinerRules[] = [
  // Define the Hyper key itself
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

  {
    description:
      "Switch languages by right_command+e (English), right_command+f (French)",
    manipulators: [
      {
        type: "basic",
        from: {
          key_code: "left_shift",
        },
        to: [{ key_code: "left_shift" }],
        to_if_alone: [{ select_input_source: { language: "en" } }],
      },
      {
        type: "basic",
        from: {
          key_code: "right_shift",
        },
        to: [{ key_code: "right_shift" }],
        to_if_alone: [{ select_input_source: { language: "uk" } }],
      },
    ],
  },

  ...createAltLayer({
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
    b: app("Karabiner-Elements"),
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
      {
        description: "Tab -> Hyper Key",
        from: {
          key_code: "tab",
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
            key_code: "tab",
          },
        ],
        type: "basic",
      },
      //      {
      //        type: "basic",
      //        description: "Disable CMD + Tab to force Hyper Key usage",
      //        from: {
      //          key_code: "tab",
      //          modifiers: {
      //            mandatory: ["left_command"],
      //          },
      //        },
      //        to: [
      //          {
      //            key_code: "tab",
      //          },
      //        ],
      //      },
    ],
  },
  ...createHyperSubLayers({
    spacebar: open(
      "raycast://extensions/stellate/mxstbr-commands/create-notion-todo"
    ),
    n: {
      t: open(
        "https://docs.google.com/spreadsheets/d/1ZSN7hTOy23kp8T6wDZdrbtC0ay0ET_kouRmeXdqGz1c/edit?gid=0#gid=0"
      ),
      c: open("https://calendar.google.com/calendar/u/1/r"),
      g: open("https://github.com/"),
    },
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

    // s = "System"
    s: {
      u: {
        to: [
          {
            key_code: "volume_increment",
          },
        ],
      },
      j: {
        to: [
          {
            key_code: "volume_decrement",
          },
        ],
      },
      i: {
        to: [
          {
            key_code: "display_brightness_increment",
          },
        ],
      },
      k: {
        to: [
          {
            key_code: "display_brightness_decrement",
          },
        ],
      },
      l: {
        to: [
          {
            key_code: "q",
            modifiers: ["right_control", "right_command"],
          },
        ],
      },
      p: {
        to: [
          {
            key_code: "play_or_pause",
          },
        ],
      },
      semicolon: {
        to: [
          {
            key_code: "fastforward",
          },
        ],
      },
      e: open(
        `raycast://extensions/thomas/elgato-key-light/toggle?launchType=background`
      ),
      // "D"o not disturb toggle
      d: open(
        `raycast://extensions/yakitrak/do-not-disturb/toggle?launchType=background`
      ),
      // "T"heme
      t: open(`raycast://extensions/raycast/system/toggle-system-appearance`),
      c: open("raycast://extensions/raycast/system/open-camera"),
      // 'v'oice
      v: {
        to: [
          {
            key_code: "spacebar",
            modifiers: ["left_option"],
          },
        ],
      },
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
