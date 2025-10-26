import { To, KeyCode, Manipulator, KarabinerRules, From, Conditions } from "./types";

/**
 * Custom way to describe a command in a layer
 */
export interface LayerCommand {
  to: To[];
  description?: string;
}

type HyperKeySublayer = {
  // The ? is necessary, otherwise we'd have to define something for _every_ key code
  [key_code in KeyCode]?: LayerCommand;
};

/**
 * Create a Hyper Key sublayer, where every command is prefixed with a key
 * e.g. Hyper + O ("Open") is the "open applications" layer, I can press
 * e.g. Hyper + O + G ("Google Chrome") to open Chrome
 */
export function createHyperSubLayer(
  sublayer_key: KeyCode,
  commands: HyperKeySublayer,
  allSubLayerVariables: string[]
): Manipulator[] {
  const subLayerVariableName = generateSubLayerVariableName(sublayer_key);

  return [
    // When Hyper + sublayer_key is pressed, set the variable to 1; on key_up, set it to 0 again
    {
      description: `Toggle Hyper sublayer ${sublayer_key}`,
      type: "basic",
      from: {
        key_code: sublayer_key,
        modifiers: {
          optional: ["any"],
        },
      },
      to_after_key_up: [
        {
          set_variable: {
            name: subLayerVariableName,
            // The default value of a variable is 0: https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/conditions/variable/
            // That means by using 0 and 1 we can filter for "0" in the conditions below and it'll work on startup
            value: 0,
          },
        },
      ],
      to: [
        {
          set_variable: {
            name: subLayerVariableName,
            value: 1,
          },
        },
      ],
      // This enables us to press other sublayer keys in the current sublayer
      // (e.g. Hyper + O > M even though Hyper + M is also a sublayer)
      // basically, only trigger a sublayer if no other sublayer is active
      conditions: [
        ...allSubLayerVariables
          .filter(
            (subLayerVariable) => subLayerVariable !== subLayerVariableName
          )
          .map((subLayerVariable) => ({
            type: "variable_if" as const,
            name: subLayerVariable,
            value: 0,
          })),
        {
          type: "variable_if",
          name: "hyper",
          value: 1,
        },
      ],
    },
    // Define the individual commands that are meant to trigger in the sublayer
    ...(Object.keys(commands) as (keyof typeof commands)[]).map(
      (command_key): Manipulator => ({
        ...commands[command_key],
        type: "basic" as const,
        from: {
          key_code: command_key,
          modifiers: {
            optional: ["any"],
          },
        },
        // Only trigger this command if the variable is 1 (i.e., if Hyper + sublayer is held)
        conditions: [
          {
            type: "variable_if",
            name: subLayerVariableName,
            value: 1,
          },
        ],
      })
    ),
  ];
}

export const createSimpleRemap = (from: KeyCode, to: KeyCode) => ({
  from: { key_code: from },
  to: [{ key_code: to }]
})


export const laptopCondition: Conditions = {
  identifiers: [{
      product_id: 835,
      vendor_id: 1452,
    }], 
  type: "device_if",
}

export const charibdisCondition: Conditions = {
  identifiers: [{
      product_id: 24926,
      vendor_id: 7504,
    }],
  type: "device_if",
}

export const ukLanguageCondition: Conditions = {
  input_sources: [{ language: "uk" }],
  type: "input_source_if",
}


export const createColemakRemap = (
  from: KeyCode,
  to: KeyCode,
): KarabinerRules => {
  return {
    description: `Remap ${from} to ${to}`,
    manipulators: [
      {
        type: "basic",
        from: {
          key_code: from,
          modifiers: {
            optional: ["any"],
          },
        },
        to: [{ key_code: to }],
        conditions: [charibdisCondition, ukLanguageCondition]
      },
    ],
  }
};

export const createAltLayer = (subLayers: {
  [key_code in KeyCode]?: HyperKeySublayer | LayerCommand;
}): KarabinerRules[] => {
  return Object.entries(subLayers).map(([key, value]) => ({
    description: `Alt + ${key}`,
    manipulators: [
      {
        ...value,
        type: "basic" as const,
        from: {
          key_code: key as KeyCode,
          modifiers: {
            mandatory: ["left_option"],
          },
        },
      },
    ],
  }));
};

/**
 * Create all hyper sublayers. This needs to be a single function, as well need to
 * have all the hyper variable names in order to filter them and make sure only one
 * activates at a time
 */
export function createHyperSubLayers(subLayers: {
  [key_code in KeyCode]?: HyperKeySublayer | LayerCommand;
}): KarabinerRules[] {
  const allSubLayerVariables = (
    Object.keys(subLayers) as (keyof typeof subLayers)[]
  ).map((sublayer_key) => generateSubLayerVariableName(sublayer_key));

  return Object.entries(subLayers).map(([key, value]) =>
    "to" in value
      ? {
          description: `Hyper Key + ${key}`,
          manipulators: [
            {
              ...value,
              type: "basic" as const,
              from: {
                key_code: key as KeyCode,
                modifiers: {
                  optional: ["any"],
                },
              },
              conditions: [
                {
                  type: "variable_if",
                  name: "hyper",
                  value: 1,
                },
                ...allSubLayerVariables.map((subLayerVariable) => ({
                  type: "variable_if" as const,
                  name: subLayerVariable,
                  value: 0,
                })),
              ],
            },
          ],
        }
      : {
          description: `Hyper Key sublayer "${key}"`,
          manipulators: createHyperSubLayer(
            key as KeyCode,
            value,
            allSubLayerVariables
          ),
        }
  );
}

function generateSubLayerVariableName(key: KeyCode) {
  return `hyper_sublayer_${key}`;
}

/**
 * Shortcut for "open" shell command
 */
export function open(...what: string[]): LayerCommand {
  return {
    to: what.map((w) => ({
      shell_command: `open ${w}`,
    })),
    description: `Open ${what.join(" & ")}`,
  };
}

/**
 * Utility function to create a LayerCommand from a tagged template literal
 * where each line is a shell command to be executed.
 */
export function shell(
  strings: TemplateStringsArray,
  ...values: any[]
): LayerCommand {
  const commands = strings.reduce((acc, str, i) => {
    const value = i < values.length ? values[i] : "";
    const lines = (str + value)
      .split("\n")
      .filter((line) => line.trim() !== "");
    acc.push(...lines);
    return acc;
  }, [] as string[]);

  return {
    to: commands.map((command) => ({
      shell_command: command.trim(),
    })),
    description: commands.join(" && "),
  };
}

/**
 * Shortcut for managing window sizing with Rectangle
 */
export function rectangle(name: string): LayerCommand {
  return {
    to: [
      {
        shell_command: `open -g rectangle://execute-action?name=${name}`,
      },
    ],
    description: `Window: ${name}`,
  };
}

export function tmuxWindow(index: string): LayerCommand {
  return {
    to: [
      {
        shell_command: `/opt/homebrew/bin/tmux select-window -t ${index}`,
      },
    ],
    description: `Tmux window: ${index}`,
  };
}
export function tmuxSession(name: string): LayerCommand {
  return {
    to: [
      {
        shell_command: `open -a WezTerm.app && ~/Projects/dotfiles/scripts/tmux-switch-session.sh ${name}`,
      },
    ],
    description: `Tmux session: ${name}`,
  };
}

/**
 * Shortcut for "Open an app" command (of which there are a bunch)
 */
export function app(name: string): LayerCommand {
  // return open(
  //   `-a '${name}.app' && open -g '/Applications/MoveCursorToCenterOfActiveWindow.app'`
  // );
  return open(`-a '${name}.app'`);
}
