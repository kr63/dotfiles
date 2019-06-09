#!/bin/sh -eu

SCREENS=1
SCREEN_SIZE="1280x600"
# SCREEN_SIZE="800x600"
DISPLAY_NUMBER=5

ARCH_BIN=./xmonad-x86_64-linux

SCREEN_COUNTER=0
SCREEN_OPTS=""
X_OFFSET_CURRENT="0"
X_OFFSET_ADD=$(echo "$SCREEN_SIZE" | cut -dx -f1)

while expr "$SCREEN_COUNTER" "<" "$SCREENS"; do
  SCREEN_OPTS="$SCREEN_OPTS -origin ${X_OFFSET_CURRENT},0 -screen ${SCREEN_SIZE}+${X_OFFSET_CURRENT}"
  SCREEN_COUNTER=$(("$SCREEN_COUNTER" + 1))
  X_OFFSET_CURRENT=$(("$X_OFFSET_CURRENT" + "$X_OFFSET_ADD"))
done

(
  # shellcheck disable=SC2086
  Xephyr $SCREEN_OPTS +xinerama +extension RANDR \
         -ac -br -reset -terminate -verbosity 10 \
         -softCursor ":$DISPLAY_NUMBER" &

  export DISPLAY=":$DISPLAY_NUMBER"
  echo "Waiting for windows to appear..." && sleep 2

  xterm -hold xrandr &
  xterm &
  $ARCH_BIN
)
