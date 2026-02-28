#!/usr/bin/env bash

# Function to get brightness percentage
get_brightness() {
    brightness=$(brightnessctl -d "$1" get 2>/dev/null || echo "0")
    max=$(brightnessctl -d "$1" max 2>/dev/null || echo "1")

    if [ "$max" -gt 0 ]; then
        percent=$((brightness * 100 / max))
    else
        percent=0
    fi

    echo "$percent"
}

# Get display brightness (0-100%)
display_pcnt=$(get_brightness acpi_video0)

# Get keyboard backlight brightness (0-100%)
kb_pcnt=$(get_brightness 'spi::kbd_backlight')

# Output as JSON for waybar
text="\"󰌌 ${kb_pcnt}% | 󰍹 ${display_pcnt}%\""
tooltip="\"Keyboard: ${kb_pcnt}%\\nDisplay: ${display_pcnt}%\""
echo "{\"text\": $text, \"tooltip\": $tooltip}"
