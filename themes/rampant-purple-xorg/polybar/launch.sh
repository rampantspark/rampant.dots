#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Launch bar1 and bar2
# echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
# polybar left 2>&1 | tee -a /tmp/polybar1.log & disown
# polybar center 2>&1 | tee -a /tmp/polybar1.log & disown
# polybar right 2>&1 | tee -a /tmp/polybar1.log & disown
# MONITOR=HDMI-0 polybar -q left -c "SDIR"/config &
#


while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch polybar
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload left &
    MONITOR=$m polybar --reload center &
    MONITOR=$m polybar --reload right &
  done
else
  polybar --reload top &
fi

echo "Bars launched..."
