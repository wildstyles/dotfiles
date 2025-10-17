#!/bin/bash


if [ $# -lt 1 ]; then
    echo "Usage: $0 Word must be passed!"
    exit 1
fi

STOP_FLAG=true

for arg in "$@"; do
  if [ "$arg" = "-s" ]; then
    STOP_FLAG=false
    break
  fi
done

WORD=$1
RAW_RESULT=$(trans :uk -indent 8 "$WORD")

echo "$RAW_RESULT"

# Stop execution if the "-s" flag is passed
if $STOP_FLAG; then
    echo "Haven't saved to dictionary"
    exit 0
fi

RESULT=$(echo "$RAW_RESULT" | \
    tr -d '\r' |                          # Remove carriage return characters
    sed 's/\x1b\[[0-9;]*m//g;' |          # Remove ANSI escape codes (such as [1m, [22m)
    tr -cd '[[:print:]]\n'               # Remove non-printable characters
)


# want to stop execution here if "-s" flag passed
 
PRONUNCIATION=$(echo "$RESULT" | sed -n '2p')
BRIEF_TRANSLATION=$(echo "$RESULT" | awk 'NR==4')
LAST_LINE_TRANSLATION=$(echo "$RESULT" | awk 'END {print}' | xargs | sed 's/^,//')

CATEGORIES=("verb" "noun" "adjective" "adverb" "pronoun" "abbreviation" "preposition" "conjunction") 

FORALL_OUTPUT=""

CURRENT_MONTH=$(date +%Y-%m-%b)
CURRENT_DATE=$(date +%Y-%m-%d-%A)
OUTPUT_FILE="$HOME/Projects/karabiner/dictionary/$CURRENT_MONTH.md"

# Find the next available index for the ordered list
INDEX=$(awk '/^[0-9]+\. / { gsub(/\.$/, "", $1); print $1 }' $OUTPUT_FILE | sort -n | tail -1)
INDEX=$((INDEX + 1))

for CATEGORY in "${CATEGORIES[@]}"; do
    BLOCK=$(echo "$RESULT" | awk -v cat="$CATEGORY" '
    $0 ~ cat {found=1; print; next} # Match lines that contain the CATEGORY
    found && !/^$/{print; next}
    found && /^$/{exit}
    ')

    output=$(echo "$BLOCK" | awk -v word="$WORD" -v category="$CATEGORY" '
        BEGIN {
            result = ""
            noun_count = 0  # Counter for Russian nouns included
        }

        # Identify a Russian noun with the correct indentation (8 spaces)
        /^[ ]{8}/ {
            if (noun_count < 3) {  # Limit total number of Russian nouns
                noun = substr($0, 9)  # Extract the Russian noun by trimming leading spaces

                getline  # Get the translations line

                if ($0 ~ /^[ ]{16}/) {  # Ensure this line has 16 spaces for English translations
                    split(substr($0, 17), translations, ", ")  # Split translations
                    translation_str = ""  # Valid translations
                    english_count = 0  # Counter for valid English translations

                    for (i = 1; i <= length(translations); i++) {
                        # Adjust to use traditional indexing
                        if (translations[i] != word && english_count < 3) {  # Filter out excluded word and limit to 3
                            if (translation_str == "") {
                                translation_str = "*"translations[i]"*"
                            } else {
                                translation_str = translation_str ", *" translations[i]"*"  # Subsequent entries
                            }
                            english_count++  # Increment English translation count
                        }
                    }
                    
                    # Assemble the result with the noun and its translations
                    if (translation_str != "") {
                        result = result (result ? ", " : "") noun "(" translation_str ")"  # Append noun and its translations
                    } else {
                        result = result (result ? ", " : "") noun  # Append only noun if no translations
                    }
                    
                    noun_count++  # Increment Russian noun count after processing
                }
            }
        }

        END {
            # Print the final result after all processing, prefixed with bullet point
            if (result != "") {
                print "- `" category "`: " result  # Include category in the output
            }
        }
    ')
    
    # Append output for the current category to the final output variable
    if [[ "$output" != "" ]]; then  # Ensure we do not add empty outputs
        PREFIX_LENGTH=${#INDEX}
        SPACES=$(printf '%*s' "$((PREFIX_LENGTH + 2))" '' | tr ' ' ' ')

        FORALL_OUTPUT+="${SPACES}$output\n"  # Add a newline for proper formatting
    fi
done


COMBINED_TRANSLATION="$BRIEF_TRANSLATION"
if [ -n "$LAST_LINE_TRANSLATION" ]; then
    COMBINED_TRANSLATION="$BRIEF_TRANSLATION, $LAST_LINE_TRANSLATION"
fi

# Split the combined result into words
IFS=', ' read -r -a words_array <<< "$COMBINED_TRANSLATION"

TRANSLATION=""

# Iterate over words and build a unique list
for word in "${words_array[@]}"; do
    # Trim whitespace from the word
    trimmed_word=$(echo "$word" | xargs)

    # Check if the word is already in the result
    if ! echo "$TRANSLATION" | grep -q -w "$trimmed_word"; then
        if [ -z "$TRANSLATION" ]; then
            TRANSLATION="$trimmed_word"  # First word
        else
            TRANSLATION="$TRANSLATION, $trimmed_word"  # Append subsequent words
        fi
    fi
done


if [ ! -f $OUTPUT_FILE ]; then
    echo "## $CURRENT_DATE" > "$OUTPUT_FILE" 
fi

# Check if the entry already exists by specific format
if ! grep -q "\*\*$WORD\*\*" "$OUTPUT_FILE"; then
  if ! grep -q "## $CURRENT_DATE" "$OUTPUT_FILE"; then
      echo "## $CURRENT_DATE" >> "$OUTPUT_FILE"
  fi

  echo >> "$OUTPUT_FILE"

  if [ -n "$PRONUNCIATION" ]; then
      echo "$INDEX. **$WORD** - \`$PRONUNCIATION\` - $TRANSLATION" >> "$OUTPUT_FILE"
  else
      echo "$INDEX. **$WORD** - $TRANSLATION" >> "$OUTPUT_FILE"
  fi

  echo >> $OUTPUT_FILE
  echo -e "$FORALL_OUTPUT" >> $OUTPUT_FILE  # Use -e to interpret escape sequences including \n

  sed -i '' -e '$!b' -e '/^$/!q' -e 'd' "$OUTPUT_FILE" # clear last empty line
fi

