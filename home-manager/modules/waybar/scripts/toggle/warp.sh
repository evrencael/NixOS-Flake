if warp-cli status | grep -q "Connected"; then
    warp-cli disconnect
else
    warp-cli connect
fi
