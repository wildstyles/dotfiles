# Import necessary modules
from typing import Any
from kitty.boss import Boss
from kitty.window import Window
import logging
import subprocess
import datetime
from time import time

# Set up logging
LOG_FILE_PATH = '/Users/ruslanvanzula/Projects/dotfiles/.config/kitty/logfile.log'  # Update this path
logging.basicConfig(
    filename=LOG_FILE_PATH,
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

def invoke_shell_script_with_session(session, tab_id):
    # Assuming 'sketchybar' command is operational and within the PATH
    try:
        result = subprocess.run(
            ['/opt/homebrew/bin/sketchybar', '--trigger', 'kitty_event', f'SESSION={session}', f'TAB={tab_id}'],
            capture_output=True,
            text=True,
            check=True
        )
        # logging.debug('Shell script output: STDOUT: %s, STDERR: %s', result.stdout, result.stderr)
        return result
    except subprocess.CalledProcessError as e:
        logging.error(f"An error occurred: {e}")
    except FileNotFoundError:
        logging.error('Sketchybar command not found. Ensure it is installed and in your PATH.')

def on_tab_bar_dirty(boss: Boss, window: Window, data: dict[str, Any]) -> None:
    milliseconds = int(time() * 1000)

    logging.debug("milliseconds: %s", milliseconds)
    logging.debug("Active tab ID: %s", boss.active_tab.id)

    session = boss.active_session if hasattr(boss, 'active_session') else ''
    invoke_shell_script_with_session(session, boss.active_tab.id)

