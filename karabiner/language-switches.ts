import { ukLanguageCondition } from './utils'

export const languageSwitches = [
  // TODO: do it with profile switching on language change
// {
//     description: "To EN holding",
//     conditions: [ukLanguageCondition],
//     manipulators: [
//         {
//             type: "basic",
//             from: {
//           // it's should be "e" key but due to remap back from colemak->qwerty
//           // for ukrainian it's qwetry "k"
//                 "key_code": "k",
//             },
//             to_if_alone: [{ key_code: "k", halt: true }],
//             to_if_held_down: [
//           {
//             select_input_source: {
//               language: "en",
//             },
//           },
//             ],
//                    "to_delayed_action": {
//                 "to_if_canceled": [{ "key_code": "k" }]
//             },
//             parameters: {
//                 "basic.to_if_alone_timeout_milliseconds": 250,
//                 "basic.to_if_held_down_threshold_milliseconds": 250
//             }
//         }
//     ]
// },

{
    description: "To UK holding",
    manipulators: [
        {
            type: "basic",
            from: {
                "key_code": "u",
            },
            to_if_alone: [{ key_code: "u", halt: true }],
            to_if_held_down: [
          {
            select_input_source: {
              language: "uk",
            },
          },
            ],
                   "to_delayed_action": {
                "to_if_canceled": [{ "key_code": "u" }]
            },
            parameters: {
                "basic.to_if_alone_timeout_milliseconds": 250,
                "basic.to_if_held_down_threshold_milliseconds": 250
            }
        }
    ]
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
]
