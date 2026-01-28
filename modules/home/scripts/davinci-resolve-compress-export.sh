#!/usr/bin/env bash

set -e

usage() {
  echo "Usage: $0 <input_file> <output_file.mp4> [mode]"
  echo "  mode: fast | slow (default: slow)"
  exit 1
}

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  usage
fi

INPUT="$1"
OUTPUT="$2"
MODE="${3:-slow}"

case "$MODE" in
  fast)
    ffmpeg -i "$INPUT" -c:v hevc_nvenc -rc vbr -cq 24 -b:v 0 -c:a copy "$OUTPUT"
    ;;
  slow)
    ffmpeg -i "$INPUT" -c:v libx265 -vtag hvc1 -c:a copy "$OUTPUT"
    ;;
  *)
    echo "Unknown mode: $MODE"
    usage
    ;;
esac
