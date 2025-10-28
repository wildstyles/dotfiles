import { KeyCode } from "./types";
import { laptopCondition } from "./utils";

export const createSimpleRemap = (from: KeyCode, to: KeyCode) => ({
  from: { key_code: from, modifiers: { optional: ["any"] } },
  to: [{ key_code: to }],
});

const createLayer1Remap = (from: KeyCode, to: KeyCode) => ({
  description: `Layer 1 ${from} -> ${to}`,
  manipulators: [
    {
      type: "basic" as const,
      conditions: [
        laptopCondition,
        {
          type: "variable_if",
          name: "1layer",
          value: 1,
        },
      ],
      ...createSimpleRemap(from, to),
    },
  ],
});

const layer1Keymaps: [KeyCode, KeyCode][] = [
  ["w", "1"],
  ["f", "2"],
  ["p", "3"],
  ["r", "4"],
  ["s", "5"],
  ["t", "6"],
  ["x", "7"],
  ["c", "8"],
  ["d", "9"],
  ["v", "0"],

  ["m", "left_arrow"],
  ["n", "down_arrow"],
  ["e", "up_arrow"],
  ["i", "right_arrow"],
];

const laptopLayer1Remaps = [
  {
    description: "1 Layer",
    manipulators: [
      {
        description: "r -> 1 Layer",
        conditions: [
          laptopCondition,
          {
            type: "variable_if",
            name: "1layer",
            value: 0,
          },
        ],
        from: {
          key_code: "r",
          modifiers: {
            optional: ["any"],
          },
        },
        to: [
          {
            set_variable: {
              name: "1layer",
              value: 1,
            },
          },
        ],
        to_after_key_up: [
          {
            set_variable: {
              name: "1layer",
              value: 0,
            },
          },
        ],
        to_if_alone: [
          {
            key_code: "r",
          },
        ],
        type: "basic",
      },
    ],
  },
  {
    description: "1 Layer i character",
    manipulators: [
      {
        description: "i -> 1 Layer",
        conditions: [
          laptopCondition,
          {
            type: "variable_if",
            name: "1layer",
            value: 0,
          },
        ],
        from: {
          key_code: "i",
          modifiers: {
            optional: ["any"],
          },
        },
        to: [
          {
            set_variable: {
              name: "1layer",
              value: 1,
            },
          },
        ],
        to_after_key_up: [
          {
            set_variable: {
              name: "1layer",
              value: 0,
            },
          },
        ],
        to_if_alone: [
          {
            key_code: "i",
          },
        ],
        type: "basic",
      },
    ],
  },
  ...layer1Keymaps.map(([from, to]) => createLayer1Remap(from, to)),
];

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

export const laptopRemaps = [
  ...laptopLayer1Remaps,
  {
    description: "Change spacebar to control if held",
    manipulators: [
      {
        type: "basic",
        from: {
          key_code: "spacebar",
          modifiers: { optional: ["any"] },
        },
        to_if_alone: [
          {
            key_code: "spacebar",
            halt: true,
          },
        ],
        to_if_held_down: [{ key_code: "left_control" }],
        to_delayed_action: {
          to_if_canceled: [{ key_code: "spacebar" }],
        },
        conditions: [laptopCondition],
        parameters: {
          "basic.to_delayed_action_delay_milliseconds": 0,
          "basic.to_if_held_down_threshold_milliseconds": 0,
        },
      },
    ],
  },
  {
    description: "Remap right Command to Alt if held, Enter if tapped",
    manipulators: [
      {
        from: {
          key_code: "right_command",
          modifiers: { optional: ["any"] },
        },
        to: [
          {
            key_code: "left_option",
            lazy: true,
          },
        ],
        conditions: [laptopCondition],
        to_if_alone: [
          {
            key_code: "return_or_enter",
          },
        ],
        type: "basic",
      },
    ],
  },
];

export const laptopSimpleRemaps = simpleRemaps.map(([from, to]) =>
  createSimpleRemap(from, to),
);
