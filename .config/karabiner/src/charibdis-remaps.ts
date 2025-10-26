import { KeyCode } from './types'
import { createColemakRemap  } from "./utils";

export const colemakToQwertyRemap: [KeyCode, KeyCode][] = [
  ["r", "s"],
  ["s", "d"],
  ["t", "f"],
  ["f", "e"],
  ["p", "r"],
  ["b", "t"],
  ["d", "v"],
  ["v", "b"],
           
  ["j", "y"],
  ["l", "u"],
  ["u", "i"],
  ["y", "o"],
  ["semicolon", "p"],
  ["m", "h"],
  ["n", "j"],
  ["e", "k"],
  ["i", "l"],
  ["o", "semicolon"],
  ["k", "n"],
  ["h", "m"],
];

export const charibdisRemaps = [
  ...colemakToQwertyRemap.map(([from, to]) => createColemakRemap(from, to)),

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
]

export const charibdisSimpleRemaps =[
            {
              from: { key_code: "grave_accent_and_tilde" },
              to: [{ key_code: "non_us_backslash" }],
            },
            {
              from: { key_code: "non_us_backslash" },
              to: [{ key_code: "grave_accent_and_tilde" }],
            },
          ]
