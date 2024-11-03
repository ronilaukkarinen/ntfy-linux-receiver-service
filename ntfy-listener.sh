#!/bin/bash

# Array of base URLs to subscribe to
NTFY_URLS=("https://your-url-1/endpoint" "https://your-url-2/endpoint")

# Function to subscribe to a single URL, appending /json to access the JSON feed
subscribe_to_url() {
    local url="$1/json"  # Append /json to the URL
    echo "Connecting to $url..."
    while true; do
        # Subscribe to JSON feed with no buffering
        curl -N -s -H "Accept: application/json" "$url" | while read -r line; do
            # Print each line received for debugging
            echo "Raw data from $url: $line"

            # Filter out title and message
            title=$(echo "$line" | jq -r 'select(.event == "message") | .title')
            message=$(echo "$line" | jq -r 'select(.event == "message") | .message')

            # Send a notification if the message is not empty
            if [[ -n "$message" ]]; then
                notify-send -i "/home/rolle/Pictures/Icons/ntfy.png" "$title" "$message"
            fi
        done
        # If the connection drops, wait 5 seconds and retry
        sleep 5
    done
}

# Start a subscription for each base URL
for url in "${NTFY_URLS[@]}"; do
    subscribe_to_url "$url" &
done

# Wait for all background jobs to finish
wait
