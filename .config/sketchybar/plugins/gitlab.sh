
#!/bin/bash


source "$CONFIG_DIR/colors.sh" # Loads all defined colors
source ~/Projects/dotfiles/.env

GITLAB_URL_FAILED="https://gitlab.com/api/v4/todos?action=build_failed"
GITLAB_URL_REVIEW_REQUESTED="https://gitlab.com/api/v4/todos?action=review_requested"
GITLAB_URL_DIRECTLY_ADDRESSED="https://gitlab.com/api/v4/todos?action=directly_addressed"

BUILD_FAILED_COUNT=$(curl --silent --location "$GITLAB_URL_FAILED" \
--header "PRIVATE-TOKEN: $GITLAB_TOKEN" | jq 'length')


REVIEW_REQUESTED_COUNT=$(curl --silent --location "$GITLAB_URL_REVIEW_REQUESTED" \
--header "PRIVATE-TOKEN: $GITLAB_TOKEN" | jq 'length')

DIRECTLY_ADDRESSED_COUNT=$(curl --silent --location "$GITLAB_URL_DIRECTLY_ADDRESSED" \
--header "PRIVATE-TOKEN: $GITLAB_TOKEN" | jq 'length')

ASSIGNED_COUNT=$((REVIEW_REQUESTED_COUNT + DIRECTLY_ADDRESSED_COUNT))

# Set color variables based on counts
if [ "$BUILD_FAILED_COUNT" -gt 0 ]; then
    color="$RED"
elif [ "$ASSIGNED_COUNT" -gt 0 ]; then
    color="$YELLOW"
else
    color="$WHITE"
fi

label=""

sketchybar --set gitlab icon="􀋊" label="$label" icon.color="$color"

