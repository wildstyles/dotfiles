import fs from "fs";
import { KarabinerRules } from "./types";
import {
  createHyperSubLayers,
  createColemakRemapp,
  createAltLayer,
  createColemakRemap,
  app,
  open,
} from "./utils";

const complexColemakRemaps = [
  createColemakRemapp("s", "r"),
  createColemakRemapp("d", "s"),
  createColemakRemapp("f", "t"),
  createColemakRemapp("e", "f"),
  createColemakRemapp("r", "p"),
  createColemakRemapp("t", "b"),
  createColemakRemapp("v", "d"),
  createColemakRemapp("b", "v"),

  createColemakRemapp("y", "j"),
  createColemakRemapp("u", "l"),
  createColemakRemapp("i", "u"),
  createColemakRemapp("o", "y"),
  createColemakRemapp("p", "semicolon"),
  createColemakRemapp("h", "m"),
  createColemakRemapp("j", "n"),
  createColemakRemapp("k", "e"),
  createColemakRemapp("l", "i"),
  createColemakRemapp("semicolon", "o"),
  createColemakRemapp("n", "k"),
  createColemakRemapp("m", "h"),
];
const colemakRemaps = [
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

const rules: KarabinerRules[] = [
  // ...complexColemakRemaps,
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
          key_code: "left_option",
          modifiers: { optional: ["any"] },
        },
        to: [
          {
            key_code: "left_option",
            modifiers: ["left_option", "left_command"],
          },
        ],
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
    description: "Language switch by double shift",
    manipulators: [
      {
        type: "basic",
        from: {
          simultaneous: [
            { key_code: "left_shift" },
            { key_code: "right_shift" },
          ],
          modifiers: { optional: ["any"] },
        },
        to: [
          { set_variable: { name: "double shift pressed", value: false } },
          {
            select_input_source: {
              language: "uk",
            },
          },
        ],
        conditions: [
          { type: "variable_if", name: "double shift pressed", value: true },
        ],
      },
      {
        type: "basic",
        from: {
          simultaneous: [
            { key_code: "left_shift" },
            { key_code: "right_shift" },
          ],
          modifiers: { optional: ["any"] },
        },
        to: [{ set_variable: { name: "double shift pressed", value: true } }],
        to_delayed_action: {
          to_if_invoked: [
            {
              select_input_source: {
                language: "en",
              },
              conditions: [
                {
                  type: "variable_if",
                  name: "double shift pressed",
                  value: true,
                },
              ],
            },
            { set_variable: { name: "double shift pressed", value: false } },
          ],
          to_if_canceled: [
            {
              select_input_source: {
                language: "en",
              },
              conditions: [
                {
                  type: "variable_if",
                  name: "double shift pressed",
                  value: true,
                },
              ],
            },
            { set_variable: { name: "double shift pressed", value: false } },
          ],
        },
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
      s: open("https://github.com/scoutgg"),
      j: open(
        "https://scoutgaming.atlassian.net/jira/software/c/projects/GAP/boards/17?assignee=712020%3A8f6ea6b1-da5d-4291-a82e-dc862db5a1f0"
      ),
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
                product_id: 24926,
                vendor_id: 7504,
              },
              manipulate_caps_lock_led: false,
            },
          ],
          name: "Charibdis profile",
          selected: true,
          simple_modifications: [
            ...colemakRemaps,
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
            rules: [...complexColemakRemaps, ...rules],
          },
        },
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
          selected: false,
          simple_modifications: [
            // ...colemakRemaps,
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
