import {
  createHyperSubLayers,
  open,
  shell,
  tmuxSession,
  rectangle,
} from "./utils";

export const hyperkeyMaps = [
  {
    description: "Hyper Key (⌃⌥⇧⌘)",
    manipulators: [
      {
        description: "Caps Lock -> Hyper Key",
        from: {
          key_code: "caps_lock",
          modifiers: {
            optional: ["any"],
          },
        },
        to: [
          {
            set_variable: {
              name: "hyper",
              value: 1,
            },
          },
          {
            key_code: "left_shift",
            modifiers: ["control", "command", "option"],
          },
        ],
        to_after_key_up: [
          {
            set_variable: {
              name: "hyper",
              value: 0,
            },
          },
        ],
        to_if_alone: [
          {
            // key_code: "caps_lock",
            key_code: "delete_or_backspace",
          },
        ],
        type: "basic",
      },
    ],
  },

  ...createHyperSubLayers({
    s: {
      v: shell(["~/Projects/dotfiles/scripts/tunnelblick-connect.sh"]),
      x: shell(["~/Projects/dotfiles/.config/sketchybar/plugins/mic_click.sh"]),
    },
    y: {
      s: shell(['~/Projects/dotfiles/scripts/toggle-time-tracking.sh "Scout"']),
      t: shell([
        '~/Projects/dotfiles/scripts/toggle-time-tracking.sh "Training"',
      ]),
    },
    l: {
      p: open("https://gitlab.com/scout-gg/api/globpay"),
      s: open("https://gitlab.com/scout-gg/api/scott"),
      g: open("https://gitlab.com/scout-gg/api/game-server"),
      f: open("https://gitlab.com/scout-gg/frontend/sgg-frontend"),
    },
    n: {
      j: open(
        "https://scoutgaming.atlassian.net/jira/software/c/projects/SGG/boards/359?assignee=712020%3A8f6ea6b1-da5d-4291-a82e-dc862db5a1f0"
      ),
      t: open(
        "https://docs.google.com/spreadsheets/d/1ZSN7hTOy23kp8T6wDZdrbtC0ay0ET_kouRmeXdqGz1c/edit?gid=0#gid=0"
      ),
      c: open("https://calendar.google.com/calendar/u/1/r"),
      m: open("https://meet.google.com/landing?hs=197&authuser=1"),
      g: open("https://github.com/"),
      l: open("https://gitlab.com/scout-gg"),
      y: open("https://youtube.com/"),
      o: open("https://olx.ua"),
    },
    w: {
      t: shell(["~/Projects/dotfiles/scripts/adjust-rectangle-padding.sh"]),
      s: shell(["~/Projects/dotfiles/scripts/switch-interface-scaling.sh"]),
      f: rectangle("maximize"),
      m: rectangle("left-half"), // same key where I got left arrow but without layer
      i: rectangle("right-half"),
    },
    t: {
      c: tmuxSession("dotfiles"),
      l: tmuxSession("scout-process"),
      s: tmuxSession("scout"),
      r: shell([
        "open -a WezTerm.app && ~/Projects/dotfiles/scripts/navigate-daily-notes.sh",
      ]),
    },
    e: {
      l: shell(["~/Projects/dotfiles/scripts/run-scout.sh local"]),
      s: shell(["~/Projects/dotfiles/scripts/run-scout.sh stage"]),
      a: shell(["~/Projects/dotfiles/scripts/run-scout.sh qa"]),
      x: shell(["~/Projects/dotfiles/scripts/run-scout.sh stop"]),
    },
  }),
];
