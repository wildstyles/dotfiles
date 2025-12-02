# Import necessary modules
from typing import Any
from kitty.boss import Boss
from kitty.window import Window
import logging

import os
import subprocess
import json
import pprint

# Set up logging
LOG_FILE_PATH = '/Users/ruslanvanzula/Projects/dotfiles/.config/kitty/logfile.log'  # Update this path
logging.basicConfig(
    filename=LOG_FILE_PATH,
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

def invoke_shell_script_with_session(session):
    # Assuming 'sketchybar' command is operational and within the PATH
    try:
        result = subprocess.run(['/opt/homebrew/bin/sketchybar', '--trigger', 'kitty_event', f'SESSION={session}'], capture_output=True, text=True, check=True)
        # logging.debug('its okay')
        print("STDOUT:", result.stdout)  # Check standard output
        print("STDERR:", result.stderr)  # Check standard error
        return result
    except subprocess.CalledProcessError as e:
        print(f"An error occurred: {e}")
    except FileNotFoundError:
        logging.debug('not found')
        print("Sketchybar command not found. Ensure it is installed and in your PATH.")


def on_tab_bar_dirty(boss: Boss, window: Window, data: dict[str, Any]) -> None:
    # Assuming there's a valid `boss` object with `active_session`
    # print(json.dumps(boss, indent=2))
    for tab in boss.all_tabs:
        logging.debug(tab)

    # logging.debug(list(boss.all_tabs()))
    # logging.debug(boss.prev_tab)
    # logging.debug(json.dumps(boss.all_tabs, indent=2))

    session = boss.active_session if hasattr(boss, 'active_session') else ''
    invoke_shell_script_with_session(session)
