#!/bin/bash

initialize_system() {
    [ ! -d active_logs ] && mkdir active_logs && echo "Creating active_logs directory..."
    [ ! -d archived_logs ] && mkdir archived_logs && echo "Creating archived_logs directory..."
    [ ! -d reports ] && mkdir reports && echo "Creating reports directory..."
}

secure_data() {
    echo "Securing active_logs directory..."

    chmod 700 active_logs

    echo "Current permissions:"
    ls -ld active_logs
}

initialize_system
secure_data

echo "System Environment Secured - $(date)"
