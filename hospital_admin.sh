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

secure_data() {
    echo "Securing active_logs directory..."
    chmod 700 active_logs
    echo "Current permissions:"
    ls -ld active_logs
}

echo "=========================================="
echo "   Kenyatta National Hospital (KNH)"
echo "   Admin Setup Script Starting..."
echo "=========================================="

initialize_system

secure_data

echo ""
echo "=========================================="
echo "   System Environment Secured"
echo "   Date: $(date)"
echo "=========================================="
