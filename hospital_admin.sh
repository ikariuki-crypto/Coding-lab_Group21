#!/bin/bash

initialize_system() {
    echo "Initializing system..."

    local dirs=("active_logs" "archived_logs" "reports")

    for dir in "${dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            echo "Creating ${dir} directory..."
            mkdir -p "$dir"
            echo "${dir} directory created successfully."
        else
            echo "${dir} directory already exists. Skipping."
        fi
    done

    echo "System initialization complete."
}

initialize_system   
