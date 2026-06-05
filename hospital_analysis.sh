#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

ACTIVE_LOGS="active_logs"
REPORTS="reports"
CRITICAL_ALERTS="${REPORTS}/critical_alerts.txt"

process_vitals() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}  KNH Clinical Vitals Analysis${NC}"
    echo -e "${CYAN}========================================${NC}"

    if [ ! -d "${ACTIVE_LOGS}" ]; then
        echo -e "${RED}[ERROR] '${ACTIVE_LOGS}' directory not found.${NC}"
        echo -e "${YELLOW}        Run hospital_admin.sh first to initialise the system.${NC}"
        return 1
    fi

    if [ ! -d "${REPORTS}" ]; then
        echo -e "${YELLOW}[INFO] '${REPORTS}' directory not found. Creating it...${NC}"
        mkdir -p "${REPORTS}"
    fi

    HEART_RATE_LOG="${ACTIVE_LOGS}/heart_rate.log"
    TEMPERATURE_LOG="${ACTIVE_LOGS}/temperature.log"

    {
        echo "========================================"
        echo "  KNH CRITICAL ALERTS REPORT"
        echo "  Generated: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "========================================"
        echo ""
    } > "${CRITICAL_ALERTS}"

    TOTAL_CRITICAL=0

    echo -e "\n${YELLOW}[1/2] Scanning Heart Rate log for CRITICAL events...${NC}"

    if [ ! -f "${HEART_RATE_LOG}" ]; then
        echo -e "${RED}      [WARN] ${HEART_RATE_LOG} not found – skipping.${NC}"
        echo "  [Heart Rate] Log file not found – skipped." >> "${CRITICAL_ALERTS}"
    else
        HR_COUNT=$(grep -c "CRITICAL" "${HEART_RATE_LOG}" 2>/dev/null || echo 0)
        echo -e "${GREEN}      Found ${HR_COUNT} CRITICAL heart rate event(s).${NC}"

        {
            echo "---- HEART RATE CRITICAL EVENTS ----"
            grep "CRITICAL" "${HEART_RATE_LOG}" | \
            awk 'BEGIN {
                    printf "%-22s %-20s %-10s\n", "Timestamp", "Device_ID", "Value"
                    print "------------------------------------------------------"
                 }
                 {
                    printf "%-22s %-20s %-10s\n", $1, $2, $3
                 }'
            echo ""
        } >> "${CRITICAL_ALERTS}"

        TOTAL_CRITICAL=$((TOTAL_CRITICAL + HR_COUNT))
    fi

    echo -e "${YELLOW}[2/2] Scanning Temperature log for CRITICAL events...${NC}"

    if [ ! -f "${TEMPERATURE_LOG}" ]; then
        echo -e "${RED}      [WARN] ${TEMPERATURE_LOG} not found – skipping.${NC}"
        echo "  [Temperature] Log file not found – skipped." >> "${CRITICAL_ALERTS}"
    else
        TEMP_COUNT=$(grep -c "CRITICAL" "${TEMPERATURE_LOG}" 2>/dev/null || echo 0)
        echo -e "${GREEN}      Found ${TEMP_COUNT} CRITICAL temperature event(s).${NC}"

        {
            echo "---- TEMPERATURE CRITICAL EVENTS ----"
            grep "CRITICAL" "${TEMPERATURE_LOG}" | \
            awk 'BEGIN {
                    printf "%-22s %-20s %-10s\n", "Timestamp", "Device_ID", "Value"
                    print "------------------------------------------------------"
                 }
                 {
                    printf "%-22s %-20s %-10s\n", $1, $2, $3
                 }'
            echo ""
        } >> "${CRITICAL_ALERTS}"

        TOTAL_CRITICAL=$((TOTAL_CRITICAL + TEMP_COUNT))
    fi

    {
        echo "========================================"
        echo "  TOTAL CRITICAL EVENTS : ${TOTAL_CRITICAL}"
        echo "========================================"
    } >> "${CRITICAL_ALERTS}"

    echo -e "\n${GREEN}[DONE] Critical alerts saved to: ${CRITICAL_ALERTS}${NC}"
    echo -e "${CYAN}       Total critical events detected: ${TOTAL_CRITICAL}${NC}\n"
}

water_audit() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}  KNH Facility Water Audit${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo -e "${YELLOW}[INFO] water_audit() pending Member 6 implementation.${NC}"
}

main() {
    echo -e "${CYAN}"
    echo "  ╔══════════════════════════════════════╗"
    echo "  ║   KNH Hospital Analysis Dashboard   ║"
    echo "  ╚══════════════════════════════════════╝"
    echo -e "${NC}"

    select choice in "Process Vitals (M5)" "Water Audit (M6)" "Run All" "Exit"; do
        case $choice in
            "Process Vitals (M5)")
                process_vitals
                ;;
            "Water Audit (M6)")
                water_audit
                ;;
            "Run All")
                process_vitals
                water_audit
                ;;
            "Exit")
                echo -e "${GREEN}Exiting KNH Analysis Dashboard. Goodbye.${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please choose 1–4.${NC}"
                ;;
        esac
    done
}

main
