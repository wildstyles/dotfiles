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

export const chromeRemaps = [
  createChromeRemap({ key_code: "i", modifiers: { mandatory: ["control"] } }, [
    { key_code: "right_arrow", modifiers: ["command", "option"] },
  ]),
  createChromeRemap({ key_code: "m", modifiers: { mandatory: ["control"] } }, [
    { key_code: "left_arrow", modifiers: ["command", "option"] },
  ]),
  // open bookmarks
  createChromeRemap(
    { key_code: "b", modifiers: { mandatory: ["shift", "command"] } },
    [{ key_code: "b", modifiers: ["command", "option"] }],
  ),
  // add bookmark
  createChromeRemap(
    { key_code: "b", modifiers: { mandatory: ["control", "shift"] } },
    [{ key_code: "d", modifiers: ["command"] }],
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
