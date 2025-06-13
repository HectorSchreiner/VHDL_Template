#!/usr/bin/env bash

# Flexible VHDL simulation script using GHDL and GTKWave
# Supports: single file, design+testbench, multiple files, --wave, --stop-time
# Usage:
#   ./simulate.sh file.vhdl entity [--wave] [--stop-time=500ns]
#   ./simulate.sh design.vhdl tb.vhdl tb_entity [--wave] [--stop-time=1us]
#   ./simulate.sh file1.vhdl ... fileN.vhdl entity [--wave] [--stop-time=...ns]

set -euo pipefail

usage() {
  echo "Usage:"
  echo "  $0 <vhdl_files...> <entity> [--wave] [--stop-time=<time>]"
  echo "  Examples:"
  echo "    $0 tb.vhdl tb_entity --wave"
  echo "    $0 design.vhdl tb.vhdl tb_entity --stop-time=1us"
  echo "    $0 *.vhdl tb_entity --wave --stop-time=500ns"
  exit 1
}

# Defaults
LAUNCH_WAVE=false
STOP_TIME="200ns"

# Parse all args
POSITIONAL_ARGS=()
for arg in "$@"; do
  case $arg in
    --wave)
      LAUNCH_WAVE=true
      ;;
    --stop-time=*)
      STOP_TIME="${arg#*=}"
      ;;
    --*)
      echo "[Error] Unknown option: $arg"
      usage
      ;;
    *)
      POSITIONAL_ARGS+=("$arg")
      ;;
  esac
done

# Require at least one VHDL file and one entity
if [[ ${#POSITIONAL_ARGS[@]} -lt 2 ]]; then
  usage
fi

# Extract entity and VHDL files
ENTITY_NAME="${POSITIONAL_ARGS[-1]}"
VHDL_FILES=("${POSITIONAL_ARGS[@]:0:${#POSITIONAL_ARGS[@]}-1}")
WAVE_FILE="${ENTITY_NAME}.ghw"

# Analyze all VHDL files
for file in "${VHDL_FILES[@]}"; do
  echo "[GHDL] Analyzing $file..."
  ghdl -a "$file"
done

echo "[GHDL] Elaborating $ENTITY_NAME..."
ghdl -e "$ENTITY_NAME"

echo "[GHDL] Running simulation (stop time = $STOP_TIME)..."
ghdl -r "$ENTITY_NAME" --wave="$WAVE_FILE" --stop-time="$STOP_TIME"

if $LAUNCH_WAVE; then
  echo "[GTKWave] Launching waveform viewer..."
  gtkwave "$WAVE_FILE"
else
  echo "[Done] Waveform saved to $WAVE_FILE (not opened)."
fi
