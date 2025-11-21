import { KeyCode } from "karabiner.ts";
import fs from "node:fs";

export const createSimpleRemap = (from: KeyCode, to: KeyCode) => ({
  from: { key_code: from, modifiers: { optional: ["any"] } },
  to: [{ key_code: to }],
});

const simpleRemaps: [KeyCode, KeyCode][] = [
  ["s", "r"],
  ["d", "s"],
  ["f", "t"],
  ["e", "f"],
  ["r", "p"],
  ["t", "b"],
  ["v", "d"],
  ["b", "v"],

  ["y", "j"],
  ["u", "l"],
  ["i", "u"],
  ["o", "y"],
  ["p", "semicolon"],
  ["h", "m"],
  ["j", "n"],
  ["k", "e"],
  ["l", "i"],
  ["semicolon", "o"],
  ["n", "k"],
  ["m", "h"],
];

export const laptopSimpleRemaps = simpleRemaps.map(([from, to]) =>
  createSimpleRemap(from, to)
);

const charibdisSimpleRemaps = [
  {
    from: { key_code: "grave_accent_and_tilde" },
    to: [{ key_code: "non_us_backslash" }],
  },
  {
    from: { key_code: "non_us_backslash" },
    to: [{ key_code: "grave_accent_and_tilde" }],
  },
];

export function init() {
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
            name: "Laptop profile",
            simple_modifications: laptopSimpleRemaps,
            virtual_hid_keyboard: { keyboard_type_v2: "iso" },
          },

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
            name: "Default profile",
            selected: true,
            simple_modifications: charibdisSimpleRemaps,
            virtual_hid_keyboard: { keyboard_type_v2: "iso" },
          },
        ],
      },
      null,
      4
    )
  );
}
