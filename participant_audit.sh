#!/bin/bash

# Participant Action Simulation Script for vm-audit
# Guides through correct evidentiary handling and hashing of incoming logs

set -e

ARCHIVE_BASE="/incident/archive"
HASH_DIR="/incident/hash_records"

### 1. Check incoming log files

echo -e "\n[1] Reviewing received log files from all sources..."
for vm in coretech gateway opsnode; do
  echo -e "\n--- $vm ---"
  ls -lh "$ARCHIVE_BASE/$vm" | grep -v README || echo "[i] No files received yet from $vm."
done

### 2. Hash each log and record in hash log

echo -e "\n[2] Generating hashes and recording to hash records..."
TIMESTAMP=$(date -u)
for vm in coretech gateway opsnode; do
  for file in "$ARCHIVE_BASE/$vm"/*; do
    [ -f "$file" ] && [[ "$file" != *README* ]] && {
      HASH=$(sha256sum "$file")
      echo "$TIMESTAMP $HASH" >> "$HASH_DIR/${vm}_hashes.txt"
      echo "[✓] Hashed: $(basename "$file") → ${vm}_hashes.txt"
    }
  done

done

### 3. Review current hash records

echo -e "\n[3] Reviewing hash records for audit trace..."
for record in "$HASH_DIR"/*; do
  echo -e "\n--- $(basename "$record") ---"
  cat "$record"
done

### 4. Example cross-check with original hash (if provided)

echo -e "\n[4] Reminder: Cross-check with provided reference hashes from other VMs where applicable."
echo "Use 'diff', 'grep', or visual inspection methods as needed."

### 5. Final

echo -e "\n[✓] Evidence handling and hashing simulation complete on vm-audit."
