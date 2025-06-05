#!/bin/bash

# Audit VM Setup Verification Script

set -e

PASS=0
FAIL=0

function check_file() {
  local path="$1"
  local description="$2"

  if [ -f "$path" ]; then
    echo "[✓] $description ($path)"
    ((PASS++))
  else
    echo "[✗] MISSING: $description ($path)"
    ((FAIL++))
  fi
}

function check_directory() {
  local path="$1"
  local description="$2"

  if [ -d "$path" ]; then
    echo "[✓] $description ($path)"
    ((PASS++))
  else
    echo "[✗] MISSING: $description ($path)"
    ((FAIL++))
  fi
}

echo "[Audit VM Setup Verification]"

# Directories
check_directory /incident/archive/coretech "Coretech archive directory"
check_directory /incident/archive/gateway "Gateway archive directory"
check_directory /incident/archive/opsnode "Opsnode archive directory"
check_directory /incident/hash_records "Hash record directory"

# README Instructions
check_file /incident/archive/coretech/README.txt "Coretech README"
check_file /incident/archive/gateway/README.txt "Gateway README"
check_file /incident/archive/opsnode/README.txt "Opsnode README"

# Completion flag
check_file /opt/setup_audit_complete.flag "Setup completion flag"

# Summary

echo -e "\n[Summary]"
echo "Passed: $PASS"
echo "Failed: $FAIL"

if [ $FAIL -eq 0 ]; then
  echo "[✓] All audit VM setup checks passed."
  exit 0
else
  echo "[!] Audit VM setup verification failed."
  exit 1
fi
