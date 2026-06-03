# Coding-lab_Group21

Group Roles:
Member 1: The Architect.........hospital_admin.shinitialize_system() — creates active_logs, archived_logs, and reports directories.

Member 2: The Security Lead........hospital_admin.shsecure_data() — sets permissions so only the owner can read/write active_logs.

Member 3: The Orchestrator........hospital_admin.shExecution logic — calls Member 1 and 2's functions in order and prints a "System Environment Secured" message with the date.

Member 4: The Archivist......hospital_archive.shrotate_logs() — moves logs to archived_logs with timestamps and recreates empty files in active_logs.

Member 5: Clinical Analyst.......hospital_analysis.shprocess_vitals() — greps CRITICAL rows and saves Timestamp, Device_ID, and Value to reports/critical_alerts.txt.

Member 6: Facility Auditor........hospital_analysis.shwater_audit() — calculates average ICU water usage and prints a formatted summary.

Instructions:
1. ./hospital_admin.sh              → initialize directories and secure permissions
2. python3 hospital_system.py start → engine starts writing live data to active_logs
3. ./hospital_analysis.sh           → analyze vitals and audit water usage
4. python3 hospital_system.py stop  → pause engine before archiving
5. ./hospital_archive.sh            → rotate logs to archived_logs, recreate empty files
6. python3 hospital_system.py start → engine resumes on fresh log files

Project Overview:
Coding-lab_Group21/
├── hospital_admin.sh       # Setup and permissions (Members 1, 2, 3)
├── hospital_analysis.sh    # Data analysis (Members 5, 6)
├── hospital_archive.sh     # Log rotation (Member 4)
├── hospital_system.py      # Python data engine
├── active_logs/            # Current log files (live data)
├── archived_logs/          # Rotated logs with timestamps
├── reports/                # Generated reports and alerts
└── README.md               # This file

