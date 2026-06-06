#!/usr/bin/env python3
import random
import time
import sys
import os
import signal
from datetime import datetime

LOG_DIR = "active_logs"
PID_FILE = "/tmp/hospital_system.pid"

DEVICES = {
    "heart": [f"WARD_A_HR_{i:02d}" for i in range(1, 6)],
    "temp": [f"WARD_B_TEMP_{i:02d}" for i in range(1, 6)],
    "water": ["FACILITY_WATER_MAIN", "ICU_WATER_RESERVE"]
}

LOGS = {
    "heart": os.path.join(LOG_DIR, "heart_rate.log"),
    "temp": os.path.join(LOG_DIR, "temperature.log"),
    "water": os.path.join(LOG_DIR, "water_usage.log")
}

def ensure_environment():
    if not os.path.exists(LOG_DIR):
        os.makedirs(LOG_DIR)
    headers = {
        "heart": "Timestamp,Device_ID,Value,Status\n",
        "temp": "Timestamp,Device_ID,Value,Status\n",
        "water": "Timestamp,Device_ID,Value,Status\n"
    }
    for key, path in LOGS.items():
        if not os.path.exists(path) or os.stat(path).st_size == 0:
            with open(path, "w") as f:
                f.write(headers[key])

def generate_data():
    ensure_environment()
    while True:
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        for device in DEVICES["heart"]:
            hr = random.randint(45, 150)
            status = "NORMAL"
            if hr < 60 or hr > 100:
                status = "CRITICAL"
            elif 90 <= hr <= 100:
                status = "WARNING"
            with open(LOGS["heart"], "a") as f:
                f.write(f"{timestamp},{device},{hr},{status}\n")
        for device in DEVICES["temp"]:
            temp = round(random.uniform(34.5, 40.5), 1)
            status = "NORMAL"
            if temp > 38.0 or temp < 35.5:
                status = "CRITICAL"
            elif 37.5 <= temp <= 38.0:
                status = "WARNING"
            with open(LOGS["temp"], "a") as f:
                f.write(f"{timestamp},{device},{temp},{status}\n")
        for device in DEVICES["water"]:
            usage = random.randint(5, 45)
            status = "NORMAL"
            if usage > 35:
                status = "HIGH_USAGE"
            with open(LOGS["water"], "a") as f:
                f.write(f"{timestamp},{device},{usage},{status}\n")
        time.sleep(1)

def start():
    if os.path.exists(PID_FILE):
        print("System is already running.")
        return
    pid = os.fork()
    if pid > 0:
        with open(PID_FILE, "w") as f:
            f.write(str(pid))
        print(f"Hospital Management System started (PID: {pid}).")
    else:
        generate_data()

def stop():
    if os.path.exists(PID_FILE):
        with open(PID_FILE, "r") as f:
            pid = int(f.read().strip())
        try:
            os.kill(pid, signal.SIGTERM)
            os.remove(PID_FILE)
            print("Hospital Management System stopped.")
        except ProcessLookupError:
            os.remove(PID_FILE)
    else:
        print("No running system found.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: ./hospital_system.py [start|stop]")
        sys.exit(1)
    cmd = sys.argv[1].lower()
    if cmd == "start":
        start()
    elif cmd == "stop":
        stop()
