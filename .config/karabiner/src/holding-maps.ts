import { shell } from "./utils";

export const holdingMaps = [
  {
    description: "Homerow on holding s",
    manipulators: [
      {
        type: "basic",
        from: {
          key_code: "s",
        },
        to_if_alone: [{ key_code: "s", halt: true }],
        to_if_held_down: [
          {
            key_code: "s",
            modifiers: [
              "left_control",
              "left_command",
              "left_shift",
              "left_option",
            ],
          },
        ],
        to_delayed_action: {
          to_if_canceled: [{ key_code: "s" }],
        },
        parameters: {
          "basic.to_if_alone_timeout_milliseconds": 250,
          "basic.to_if_held_down_threshold_milliseconds": 250,
        },
      },
    ],
  },

  {
    description: "Homerow on holding f",
    manipulators: [
      {
        type: "basic",
        from: {
          key_code: "f",
        },
        to_if_alone: [{ key_code: "f", halt: true }],
        to_if_held_down: [
          {
            key_code: "f",
            modifiers: [
              "left_control",
              "left_command",
              "left_shift",
              "left_option",
            ],
          },
        ],
        to_delayed_action: {
          to_if_canceled: [{ key_code: "f" }],
        },
        parameters: {
          "basic.to_if_alone_timeout_milliseconds": 250,
          "basic.to_if_held_down_threshold_milliseconds": 250,
        },
      },
    ],
  },
];
