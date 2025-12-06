import {
  map,
  ifVar,
  rule,
  withMapper,
  withCondition,
  layer,
  simlayer,
  ToEvent,
  FromAndToKeyCode,
} from "karabiner.ts";

import { key, ifLaptopDevice } from "./simple-remaps.ts";

const layer1Remaps: Partial<Record<FromAndToKeyCode, ToEvent>> = {
  w: { key_code: "1" },
  f: { key_code: "2" },
  p: { key_code: "3" },
  r: { key_code: "4" },
  s: { key_code: "5" },
  t: { key_code: "6" },
  x: { key_code: "7" },
  c: { key_code: "8" },
  d: { key_code: "9" },
  v: { key_code: "0" },
  q: { key_code: "non_us_backslash", modifiers: ["shift"] },
  b: { key_code: "non_us_backslash" },
  a: { key_code: "tab" },
  z: { key_code: "hyphen", modifiers: ["shift"] },
  g: { key_code: "equal_sign" },

  m: { key_code: "left_arrow" },
  n: { key_code: "down_arrow" },
  e: { key_code: "up_arrow" },
  i: { key_code: "right_arrow" },
  j: { key_code: "quote" },
  l: { key_code: "9", modifiers: ["shift"] },
  u: { key_code: "0", modifiers: ["shift"] },
  y: { key_code: "open_bracket" },
  o: { key_code: "quote" },
  k: { key_code: "keypad_hyphen" },
  h: { key_code: "open_bracket", modifiers: ["shift"] },
  slash: { key_code: "slash", modifiers: ["shift"] },
  comma: { key_code: "close_bracket", modifiers: ["shift"] },
  // period: {},
  semicolon: { key_code: "close_bracket" },
};

const layer2Remaps: Partial<Record<FromAndToKeyCode, ToEvent>> = {
  a: { key_code: "1", modifiers: ["shift"] },
  r: { key_code: "2", modifiers: ["shift"] },
  s: { key_code: "3", modifiers: ["shift"] },
  t: { key_code: "6", modifiers: ["shift"] },
  g: { key_code: "5", modifiers: ["shift"] },

  m: { key_code: "5", modifiers: ["shift"] },
  n: { key_code: "7", modifiers: ["shift"] },
  e: { key_code: "8", modifiers: ["shift"] },
  i: { key_code: "hyphen", modifiers: ["shift"] },
  o: { key_code: "4", modifiers: ["shift"] },
  y: { key_code: "backslash", modifiers: ["shift"] },
  semicolon: { key_code: "backslash" },
  k: { key_code: "keypad_equal_sign" },
  h: { key_code: "open_bracket", modifiers: ["shift"] },
  comma: { key_code: "comma", modifiers: ["shift"] },
  period: { key_code: "period", modifiers: ["shift"] },
  slash: { key_code: "slash" },
};

const layer1First = Object.fromEntries(
  Object.entries(layer1Remaps).slice(0, 15),
);
const layer1Second = Object.fromEntries(Object.entries(layer1Remaps).slice(15));

const layer2First = Object.fromEntries(
  Object.entries(layer2Remaps).slice(0, 5),
);
const layer2Second = Object.fromEntries(Object.entries(layer2Remaps).slice(5));

export const generateLaptopRules = (lang?: "en" | "uk") => [
  rule("Laptop remaps").manipulators([
    withCondition(ifLaptopDevice())([
      map("spacebar", "optionalAny")
        .parameters({ "basic.to_if_held_down_threshold_milliseconds": 0 })
        .toIfAlone("spacebar", [], { halt: true })
        .toIfHeldDown("left_control"),
      map("z", "optionalAny")
        .parameters({ "basic.to_if_held_down_threshold_milliseconds": 0 })
        .toIfAlone("z", [], { halt: true })
        .toIfHeldDown("left_shift"),
      map("slash", "optionalAny")
        .parameters({ "basic.to_if_held_down_threshold_milliseconds": 0 })
        .toIfAlone("slash", [], { halt: true })
        .toIfHeldDown("left_shift"),
    ]),
  ]),

  // layer([key("r", lang), key("i", lang)], "first")
  //   .delay(100)
  //   // .modifiers("??")
  //   // .condition(ifLaptopDevice(), ifVar("caps", 0))
  //   .condition(ifLaptopDevice())
  //   .manipulators([
  //     withMapper(layer1Remaps as any)((k, v) => map(key(k, lang)).to(v)),
  //   ]),

  // layer(key("i", lang), "first")
  //   .delay(100)
  //   .modifiers("??")
  //   // .condition(ifLaptopDevice(), ifVar("caps", 0))
  //   .condition(ifLaptopDevice())
  //   .manipulators([
  //     withMapper(layer1First as any)((k, v) => map(key(k, lang)).to(v)),
  //   ]),

  // layer([key("x", lang), key("period", lang)], "second")
  //   .delay(100)
  //   // .modifiers("??")
  //   // .condition(ifLaptopDevice(), ifVar("caps", 0))
  //   .condition(ifLaptopDevice())
  //   .manipulators([
  //     withMapper(layer2Remaps as any)((k, v) => map(key(k, lang)).to(v)),
  //   ]),

  // layer(key("period", lang), "second")
  //   .delay(100)
  //   .modifiers("??")
  //   .condition(ifLaptopDevice())
  //   // .condition(ifLaptopDevice(), ifVar("caps", 0))
  //   .manipulators([
  //     withMapper(layer2First as any)((k, v) => map(key(k, lang)).to(v)),
  //     map(key("q", lang)).toConsumerKey("volume_decrement"),
  //     map(key("b", lang)).toConsumerKey("volume_increment"),
  //     map(key("z", lang)).toConsumerKey("display_brightness_decrement"),
  //     map(key("v", lang)).toConsumerKey("display_brightness_increment"),
  //   ]),
];
