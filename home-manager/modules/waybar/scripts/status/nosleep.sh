#!/usr/bin/env bash
if pgrep -x hypridle > /dev/null; then
    echo '{"text":"󰒲", "class":"on"}'
else
    echo '{"text":"󰒳", "class":"off"}'
fi
