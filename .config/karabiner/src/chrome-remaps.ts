import { KarabinerRules, From, To } from "./types";

const createChromeRemap = (from: From, to: To[]): KarabinerRules => ({
  description: `Remap ${from} to ${to}`,
  manipulators: [
    {
      type: "basic",
      from,
      to,
      conditions: [
        {
          type: "frontmost_application_if",
          bundle_identifiers: ["com.google.Chrome"],
        },
      ],
    },
  ],
});

const createNavigationRemap = (from: From, to: To[]): KarabinerRules => ({
  description: `Remap ${from} to ${to}`,
  manipulators: [
    {
      type: "basic",
      from,
      to,
      conditions: [
        {
          type: "frontmost_application_unless", // This specifies the rule should apply unless the application matches
          bundle_identifiers: ["^com\\.github\\.wez\\.wezterm$"],
        },
      ],
    },
  ],
});

export const remaps: KarabinerRules[] = [
  createNavigationRemap(
    { key_code: "b", modifiers: { mandatory: ["control"] } },
    [
      {
        key_code: "left_arrow",
        modifiers: ["option"],
      },
    ]
  ),
  createNavigationRemap(
    { key_code: "b", modifiers: { mandatory: ["control", "shift"] } },
    [
      {
        key_code: "left_arrow",
        modifiers: ["option", "shift"],
      },
    ]
  ),
  createNavigationRemap(
    { key_code: "e", modifiers: { mandatory: ["control"] } },
    [
      {
        key_code: "right_arrow",
        modifiers: ["option"],
      },
    ]
  ),
  createNavigationRemap(
    { key_code: "e", modifiers: { mandatory: ["control", "shift"] } },
    [
      {
        key_code: "right_arrow",
        modifiers: ["option", "shift"],
      },
    ]
  ),

  createNavigationRemap(
    { key_code: "w", modifiers: { mandatory: ["control"] } },
    [
      {
        key_code: "delete_or_backspace",
        modifiers: ["option"],
      },
    ]
  ),
];

export const chromeRemaps = [
  ...remaps,
  createChromeRemap({ key_code: "i", modifiers: { mandatory: ["control"] } }, [
    { key_code: "right_arrow", modifiers: ["command", "option"] },
  ]),
  // toggle dark/light mode
  createChromeRemap({ key_code: "t", modifiers: { mandatory: ["control"] } }, [
    { key_code: "d", modifiers: ["shift", "option"] },
  ]),
  createChromeRemap({ key_code: "m", modifiers: { mandatory: ["control"] } }, [
    { key_code: "left_arrow", modifiers: ["command", "option"] },
  ]),
  // open bookmarks
  createChromeRemap(
    { key_code: "b", modifiers: { mandatory: ["shift", "command"] } },
    [{ key_code: "b", modifiers: ["command", "option"] }]
  ),
  // add bookmark
  createChromeRemap(
    { key_code: "b", modifiers: { mandatory: ["control", "shift"] } },
    [{ key_code: "d", modifiers: ["command"] }]
  ),
  // open history
  createChromeRemap({ key_code: "h", modifiers: { mandatory: ["command"] } }, [
    { key_code: "y", modifiers: ["command"] },
  ]),
  // open devtools
  createChromeRemap({ key_code: "d", modifiers: { mandatory: ["command"] } }, [
    { key_code: "i", modifiers: ["option", "command"] },
  ]),
];
