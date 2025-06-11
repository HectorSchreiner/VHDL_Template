#!/usr/bin/env bash

# Usage: ./simulate.sh <filename.vhdl> <entity_name> [--wave]

set -euo pipefail

# Help message
usage() {
  echo "Usage: $0 <filename.vhdl> <entity_name> [--wave]"
  echo "  --wave    Launch GTKWave after simulation (optional)"
  exit 1
}

# Argument parsing
if [[ $# -lt 2 || $# -gt 3 ]]; then
  usage
fi

VHDL_FILE="$1"
ENTITY_NAME="$2"
LAUNCH_WAVE=false

if [[ "${3:-}" == "--wave" ]]; then
  LAUNCH_WAVE=true
fi

WAVE_FILE="${ENTITY_NAME}.ghw"

# Compile and elaborate
echo "[GHDL] Analyzing $VHDL_FILE..."
ghdl -a "$VHDL_FILE"

echo "[GHDL] Elaborating $ENTITY_NAME..."
ghdl -e "$ENTITY_NAME"

# Run simulation
echo "[GHDL] Running simulation..."
ghdl -r "$ENTITY_NAME" --wave="$WAVE_FILE" --stop-time=200ns

# Optionally open GTKWave
if $LAUNCH_WAVE; then
  echo "[GTKWave] Launching waveform viewer..."
  gtkwave "$WAVE_FILE"
else
  echo "[Done] Waveform saved to $WAVE_FILE (not opened)."
fi
