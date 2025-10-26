import fs from "fs";
import { KarabinerRules } from "./types.ts";
import { chromeRemaps } from './chrome-remaps.ts'
import { laptopRemaps, laptopSimpleRemaps } from './laptop-remaps.ts'
import { charibdisRemaps, charibdisSimpleRemaps } from './charibdis-remaps.ts'
import { qqToEscape } from "./qq-to-escape.ts";
import { languageSwitches } from "./language-switches.ts";
import { hyperkeyMaps } from "./hyperkey-maps.ts";
import { openAppMaps } from "./open-app-maps.ts";
import { holdingMaps } from './holding-maps.ts'

const rules: KarabinerRules[] = [
  qqToEscape,
  ...chromeRemaps,
  ...charibdisRemaps,
  ...laptopRemaps,
  ...languageSwitches,
  ...hyperkeyMaps,
  ...openAppMaps,
  ...hyperkeyMaps,
  ...holdingMaps
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
                product_id: 835,
                vendor_id: 1452,
              },
              manipulate_caps_lock_led: false,
            },
          ],
          name: "Laptop profile",
          simple_modifications: laptopSimpleRemaps,
          virtual_hid_keyboard: { keyboard_type_v2: "iso" },
          complex_modifications: {
            rules,
          },
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
