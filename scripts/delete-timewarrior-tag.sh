
#!/bin/bash

# Specify the tag you want to delete
TAG=${1:-"SGG"}

# Get the IDs of entries with the specified tag
entry_ids=$(timew summary :all | awk -v tag="$TAG" '$0 ~ tag {match($0, /@[0-9]+/); print substr($0, RSTART, RLENGTH)}')

# Check if any entries were found
if [[ -z "$entry_ids" ]]; then
    echo "No entries found with tag '${TAG}'"
    exit 0
fi

# Loop through each entry ID and delete
for id in $entry_ids; do
    echo "Deleting entry ID: $id"
    timew delete "$id"
done

echo "All entries with tag '${TAG}' have been deleted."
