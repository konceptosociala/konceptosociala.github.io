#!/bin/sh

POSTS_DIR="."
OUTPUT_FILE="index.json"

echo "[" > "$OUTPUT_FILE"
FIRST=true

# Loop through all markdown files
for file in "$POSTS_DIR"/*.md; do
    # Skip if file is catalogue.md
    [ "$(basename "$file")" = "catalogue.md" ] && continue

    # Skip if not a regular file
    [ ! -f "$file" ] && continue

    # Extract title (remove leading/trailing quotes if present)
    title=$(grep -m1 '^title:' "$file" | sed 's/^title:[[:space:]]*//; s/^"//; s/"$//')
    date=$(grep -m1 '^date:' "$file" | sed 's/^date:[[:space:]]*//')

    # Add comma if not the first entry
    if [ "$FIRST" = true ]; then
        FIRST=false
    else
        echo "," >> "$OUTPUT_FILE"
    fi

    # Append JSON object
    printf '  { "title": "%s", "date": "%s", "link": "%s" }' \
        "$title" "$date" "$(basename "$file" .md)" >> "$OUTPUT_FILE"

done

echo "" >> "$OUTPUT_FILE"
echo "]" >> "$OUTPUT_FILE"

echo "Generated $OUTPUT_FILE"
