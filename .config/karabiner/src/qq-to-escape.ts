export const qqToEscape = {
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
};
