#!/bin/bash
# =============================================================
# Script: hospital_analysis.sh
# Description: Analyzes live data from the active_logs folder
# Members: Member 5 (Clinical Analyst) & Member 6 (Facility Auditor)
# =============================================================

# ------------------------------------------------------
# MEMBER 5 - Clinical Analyst
# Function: process_vitals()
# ------------------------------------------------------
process_vitals() {
    echo "-----------------------------------------------"
    echo " Running Clinical Vitals Analysis..."
    echo "-----------------------------------------------"

    local heart_rate_log="active_logs/heart_rate.log"
    local temperature_log="active_logs/temperature.log"
    local output_file="reports/critical_alerts.txt"

    if [[ ! -d "reports" ]]; then
        echo "ERROR: reports/ directory not found. Please run hospital_admin.sh first."
        return 1
    fi

    if [[ ! -f "$heart_rate_log" && ! -f "$temperature_log" ]]; then
        echo "ERROR: No log files found in active_logs/. Is the hospital engine running?"
        return 1
    fi

    > "$output_file"
    echo "Timestamp,Device_ID,Value,Type" >> "$output_file"

    if [[ -f "$heart_rate_log" ]]; then
        grep "CRITICAL" "$heart_rate_log" | awk -F',' '{
            print $1 "," $2 "," $3 ",Heart_Rate"
        }' >> "$output_file"
        echo "  [OK] Heart Rate log scanned."
    else
        echo "  [WARN] Heart Rate log not found: $heart_rate_log"
    fi

    if [[ -f "$temperature_log" ]]; then
        grep "CRITICAL" "$temperature_log" | awk -F',' '{
            print $1 "," $2 "," $3 ",Temperature"
        }' >> "$output_file"
        echo "  [OK] Temperature log scanned."
    else
        echo "  [WARN] Temperature log not found: $temperature_log"
    fi

    local alert_count
    alert_count=$(tail -n +2 "$output_file" | wc -l)

    echo ""
    echo "  Critical alerts found : $alert_count"
    echo "  Saved to              : $output_file"
    echo ""
}

# ------------------------------------------------------
# MEMBER 6 - Facility Auditor
# Function: water_audit()
# ------------------------------------------------------
water_audit() {
    echo "-----------------------------------------------"
    echo " Running Facility Water Audit..."
    echo "-----------------------------------------------"

    local log_file="active_logs/water_usage.log"
    local device_id="ICU_WATER_RESERVE"

    if [[ ! -f "$log_file" ]]; then
        echo "ERROR: Water usage log not found at $log_file"
        return 1
    fi

    awk -F',' -v device="$device_id" '
        NR == 1 { next }
        $2 == device {
            sum += $3
            count++
        }
        END {
            if (count == 0) {
                printf "\n  [WATER AUDIT] No data found for device: %s\n\n", device
            } else {
                avg = sum / count
                printf "\n============================================\n"
                printf "   KNH FACILITY WATER AUDIT REPORT\n"
                printf "============================================\n"
                printf "   Device      : %s\n", device
                printf "   Readings    : %d\n", count
                printf "   Total Usage : %.2f L\n", sum
                printf "   Average     : %.2f L per reading\n", avg
                printf "============================================\n\n"
            }
        }
    ' "$log_file"
}

# ------------------------------------------------------
# MAIN
# ------------------------------------------------------
echo "============================================"
echo "   KNH HOSPITAL ANALYSIS SYSTEM"
echo "   Date: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"
echo ""

process_vitals
water_audit

echo "Analysis Complete."
