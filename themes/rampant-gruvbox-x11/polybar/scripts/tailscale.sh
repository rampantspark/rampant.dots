#!/bin/bash

# Regex pattern for matching IPv4 addresses
regex="([0-9]{1,3}\.){3}[0-9]{1,3}"

# Run tailscale status command and store output
tailscale_status=$(tailscale status)

# Check if Tailscale is stopped
if [[ $tailscale_status == *"Tailscale is stopped."* ]]; then
    echo "disconnected"
else
    # Extract IPv4 addresses from the output
    ip_addresses=$(echo "$tailscale_status" | grep -E -o "$regex")

    # Check if any IP addresses were found
    if [ -n "$ip_addresses" ]; then
        echo "$ip_addresses"
    fi
fi
