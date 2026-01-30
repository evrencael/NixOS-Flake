#!/usr/bin/env bash

# Check if Warp is connected
if warp-cli status | grep -q "Connected"; then
    echo '{"text":"󰒋 Warp", "class":"on"}'
else
    echo '{"text":"󰒋 Warp", "class":"off"}'
fi
