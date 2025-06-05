#!/bin/bash

SETUP_FLAG="/opt/setup_audit_complete.flag"

function install_packages() {
  echo "[+] Installing required packages..."
  apt-get update -qq
  apt-get install -y vim grep scp rsyslog net-tools sha256sum cron
}

function create_directories() {
  echo "[+] Creating archive and hash directories..."
  mkdir -p /incident/archive/coretech
  mkdir -p /incident/archive/gateway
  mkdir -p /incident/archive/opsnode
  mkdir -p /incident/hash_records
}

function create_readme() {
  echo "[+] Creating README files with log handling instructions..."
  for target in coretech gateway opsnode; do
    cat > "/incident/archive/$target/README.txt" <<EOF
===========================
Log Transfer Instructions
===========================

1. Use 'scp' to securely copy log files to this directory from the $target VM.
   Example:
     scp /var/log/sim/ais_feed.log audituser@vm-audit:/incident/archive/$target/

2. Upon receipt, run:
     sha256sum [filename] >> /incident/hash_records/$target_hashes.txt

3. Include timestamp in the entry manually, or run:
     echo "\"$(date -u)\" \$(sha256sum [filename])" >> /incident/hash_records/$target_hashes.txt

4. Report any discrepancies with reference hashes to Legal/Coordinator immediately.
EOF
  done
}

function mark_complete() {
  echo "[+] Marking setup complete."
  touch "$SETUP_FLAG"
}

function reset_vm() {
  echo "[!] Resetting vm-audit to pre-scenario state..."
  rm -rf /incident/archive/*
  rm -rf /incident/hash_records/*
  rm -f "$SETUP_FLAG"
  echo "[+] Reset complete."
  exit 0
}

if [[ "$1" == "-reset" ]]; then
  reset_vm
fi

if [ -f "$SETUP_FLAG" ]; then
  echo "[!] Setup already completed. Use -reset to reset."
  exit 1
fi

install_packages
create_directories
create_readme
mark_complete

echo "[✓] vm-audit setup complete. Ready for scenario."
