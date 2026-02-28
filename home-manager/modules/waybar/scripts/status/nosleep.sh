#!/usr/bin/env bash
if pgrep -x hypridle > /dev/null; then
    echo '{"text":"󰒳 Sleep", "class":"on"}'
else
    echo '{"text":"󰒳 Sleep", "class":"off"}'
fi
