#!/bin/bash

# Cleanup function for SIGINT
cleanup() {
    echo ""
    echo "[INFO] Interruption detected. Cleaning up..."
    if [ -d "$PROJECT_DIR" ]; then
        tar -czf "attendance_tracker_${INPUT}_archive.tar.gz" "$PROJECT_DIR"
        echo "[INFO] Archive created: attendance_tracker_${INPUT}_archive.tar.gz"
        rm -rf "$PROJECT_DIR"
        echo "[INFO] Incomplete directory removed."
    fi
    exit 1
}

trap cleanup SIGINT

# Section 1: Directory Setup
echo "[INFO] Starting Attendance Tracker setup..."
echo ""

read -rp "Enter project name: " INPUT

if [ -z "$INPUT" ]; then
    echo "[ERROR] No project name provided. Exiting."
    exit 1
fi

PROJECT_DIR="attendance_tracker_${INPUT}"

if [ -d "$PROJECT_DIR" ]; then
    echo "[ERROR] Directory '$PROJECT_DIR' already exists. Exiting."
    exit 1
fi

mkdir -p "$PROJECT_DIR"
echo "[INFO] Created directory: $PROJECT_DIR"

mkdir -p "${PROJECT_DIR}/Helpers"
mkdir -p "${PROJECT_DIR}/reports"
echo "[INFO] Created subdirectories: Helpers/ and reports/"

touch "${PROJECT_DIR}/attendance_checker.py"
touch "${PROJECT_DIR}/Helpers/assets.csv"
touch "${PROJECT_DIR}/Helpers/config.json"
touch "${PROJECT_DIR}/reports/reports.log"
echo "[INFO] Project files created successfully."

# Section 2: Dynamic Configuration
echo ""
read -rp "Do you want to update attendance thresholds? (yes/no): " UPDATE

if [ "$UPDATE" = "yes" ]; then
    read -rp "Enter new Warning threshold (default 75): " WARNING
    read -rp "Enter new Failure threshold (default 50): " FAILURE

    if [ -z "$WARNING" ]; then WARNING=75; fi
    if [ -z "$FAILURE" ]; then FAILURE=50; fi

    sed -i "s/\"warning_threshold\": [0-9]*/\"warning_threshold\": $WARNING/" "${PROJECT_DIR}/Helpers/config.json"
    sed -i "s/\"failure_threshold\": [0-9]*/\"failure_threshold\": $FAILURE/" "${PROJECT_DIR}/Helpers/config.json"

    echo "[INFO] Thresholds updated: Warning=${WARNING}% Failure=${FAILURE}%"
else
    echo "[INFO] Keeping default thresholds."
fi

# Section 3: Environment Validation
echo ""
echo "[INFO] Running health check..."

if python3 --version &>/dev/null; then
    echo "[INFO] python3 is installed: $(python3 --version)"
else
    echo "[ERROR] python3 is not installed."
fi

echo "[INFO] Verifying project structure..."
for f in "${PROJECT_DIR}/attendance_checker.py" \
          "${PROJECT_DIR}/Helpers/assets.csv" \
          "${PROJECT_DIR}/Helpers/config.json" \
          "${PROJECT_DIR}/reports/reports.log"; do
    if [ -f "$f" ]; then
        echo "[INFO] Found: $f"
    else
        echo "[ERROR] Missing: $f"
    fi
done

echo ""
echo "[INFO] Setup complete. Project '$PROJECT_DIR' is ready."
