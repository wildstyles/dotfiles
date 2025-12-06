#!/bin/bash

# Read JSON from clipboard, minify it, and then copy back to clipboard
pbpaste | jq -c . | pbcopy
