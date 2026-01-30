#!/usr/bin/env bash

# Get keyboard backlight brightness (0-100%)
kb_brightness=$(brightnessctl -d '*::kbd_backlight' get 2>/dev/null || echo "0")
kb_max=$(brightnessctl -d '*::kbd_backlight' max 2>/dev/null || echo "1")
kb_percent=$((kb_brightness * 100 / kb_max))

# Get display brightness (0-100%)
display_brightness=$(brightnessctl get 2>/dev/null || echo "0")
display_max=$(brightnessctl max 2>/dev/null || echo "1")
display_percent=$((display_brightness * 100 / display_max))

# Output as JSON for waybar
text= "\"󰌌 ${kb_percent}% | 󰃞 ${display_percent}%\""
tooltip= "\"Keyboard: ${kb_percent}%\\nDisplay: ${display_percent}%\""

echo "{\"text\": $text, \"tooltip\": $tooltip}"
