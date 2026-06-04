#!/bin/bash

rotate_logs() {
    echo "Starting log rotation..."

    TIMESTAMP=$(date +"%Y%m%d_%H%M")

    # --- Safety checks ---
    if [ ! -d "active_logs" ]; then
        echo "Error: active_logs not found. Run initialize_system first."
        return 1
    fi

    if [ ! -d "archived_logs" ]; then
        echo "Error: archived_logs not found. Run initialize_system first."
        return 1
    fi

    # --- Check if there are logs to rotate ---
    if [ -z "$(ls active_logs/*.log 2>/dev/null)" ]; then
        echo "No log files found in active_logs. Nothing to rotate."
        return 0
    fi

    # --- Rotate each log file one by one ---
    for log_file in active_logs/*.log; do

        filename=$(basename "$log_file")
        base_name="${filename%.log}"
        archived_name="${base_name}_${TIMESTAMP}.log"

        echo "Rotating ${filename}..."
        mv "$log_file" "archived_logs/${archived_name}"
        echo "Moved to archived_logs/${archived_name}."

        touch "active_logs/${filename}"
        echo "Recreated empty ${filename} in active_logs."
        echo "---"

    done

    echo "Log rotation complete."
}

rotate_logs
