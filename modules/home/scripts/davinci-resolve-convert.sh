#!/bin/bash

# Automatically get the name of this script
SCRIPT_NAME=$(basename "$0")

show_help() {
    echo "Usage: $SCRIPT_NAME <folder_name>"
    echo "Description: Recursively converts videos to DNxHR for Resolve."
}

# Handle unbound variable
TARGET_INPUT="${1:-}"
if [ -z "$TARGET_INPUT" ]; then
    show_help
    exit 1
fi

# Get absolute path
TARGET_DIR=$(realpath "$TARGET_INPUT" 2>/dev/null || true)
if [ -z "$TARGET_DIR" ] || [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_INPUT' does not exist."
    show_help
    exit 1
fi

OUT_BASE_DIR="$TARGET_DIR/converted_for_resolve"
LOG_FILE="$OUT_BASE_DIR/conversion.log"

mkdir -p "$OUT_BASE_DIR"
echo "--- Conversion Log: $(date) ---" > "$LOG_FILE"

# Move to the target directory
OLD_PWD=$(pwd)
cd "$TARGET_DIR" || exit 1

# Initialize counters explicitly
SUCCESS_COUNT=0
FAIL_COUNT=0

# Read files into array
mapfile -d '' VIDEO_FILES < <(find . -type f \( -iname "*.mp4" -o -iname "*.mov" -o -iname "*.mkv" \) -not -path "./converted_for_resolve/*" -print0)

for file in "${VIDEO_FILES[@]}"; do
    rel_path="${file#./}"
    dir_name=$(dirname "$rel_path")
    base_name=$(basename "$rel_path")
    filename="${base_name%.*}"
    
    target_subfolder="$OUT_BASE_DIR/$dir_name"
    mkdir -p "$target_subfolder"

    echo "Processing: $rel_path..." >&2

    # if ffmpeg -nostdin -y \
    #    -i "$rel_path" \
    #    -c:v dnxhd \
    #    -profile:v dnxhr_hq \
    #    -threads 8 \
    #    -c:a pcm_s16le \
    #    -pix_fmt yuv422p \
    #    -movflags +faststart \
    #    "$target_subfolder/${filename}_dnx.mov" >> "$LOG_FILE" 2>&1; then
    # Faster alternative to DNxHR
    if ffmpeg -nostdin -y -i "$rel_path" \
       -c:v cfhd -quality 3 \
       -c:a pcm_s16le \
       "$target_subfolder/${filename}_cineform.mov" >> "$LOG_FILE" 2>&1; then
        echo "[SUCCESS] $rel_path" >> "$LOG_FILE"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        echo "[FAILED]  $rel_path" >> "$LOG_FILE"
        echo "  FAILED: $rel_path" >&2
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
done

# Return home
cd "$OLD_PWD"

{
    echo ""
    echo "=============================="
    echo "      CONVERSION SUMMARY"
    echo "=============================="
    echo "Total Successful: $SUCCESS_COUNT"
    echo "Total Failed:     $FAIL_COUNT"
    echo "Log: $LOG_FILE"
    echo "=============================="

    if [ "$SUCCESS_COUNT" -gt 0 ]; then
        echo -e "\nSUCCESSFUL FILES:"
        grep "\[SUCCESS\]" "$LOG_FILE" | sed 's/\[SUCCESS\] //'
    fi

    if [ "$FAIL_COUNT" -gt 0 ]; then
        echo -e "\nFAILED FILES:"
        grep "\[FAILED\]" "$LOG_FILE" | sed 's/\[FAILED\]  //'
    fi
} >&2
