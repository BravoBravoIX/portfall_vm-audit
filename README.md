**VM Build Sheet: vm-audit**

**Purpose:**
Simulates the internal audit and evidentiary review system. Participants are expected to securely transfer log files here from other VMs (coretech, gateway, opsnode), hash the content, and verify integrity. This VM is passive — it’s not compromised — and is used to reinforce proper chain-of-custody behaviour and validate incident response discipline.

---

### 1. Services and Software to Install

* `rsyslog`, `net-tools`, `vim`, `grep`, `sha256sum`, `scp`, `cron`

### 2. Directory and File Structure

```bash
/incident/archive/coretech/
/incident/archive/gateway/
/incident/archive/opsnode/
/incident/hash_records/
```

Each folder will receive incoming `.log` or `.ts` files from the respective VMs.

### 3. Optional Files Preloaded

* README.txt in each archive folder with instructions
* Expected hash values (can be injected or simulated per role)

### 4. Hash Logging Process

* Teams must:

  1. Transfer log or archive files using `scp`
  2. Generate SHA256 hash for each file received
  3. Store results in `/incident/hash_records/` with filename, hash, timestamp

### 5. Expected Participant Actions

* Receive logs via `scp`
* Run `sha256sum filename` on each
* Record findings in structured way
* Cross-check with original reference hash (if available)
* Escalate any discrepancies (especially if hashes mismatch — e.g. gateway trap)

### 6. Outcomes

* Properly logged hashes gain high score
* Missed or falsified entries reduce score
* Logs deleted or skipped from trap VMs flagged by later injects

### 7. Inject Linkages

* INJ013 (Missing logs or hash gaps)
* INJ013B (Gateway tampering mismatch)

### 8. Scoring Hooks

* Did they hash every received file?
* Did they log hash and timestamp correctly?
* Did they report anomalies promptly?
* Were all source logs accounted for?

---

**Next Step:** Prepare `setup_audit.sh`, `verify_audit_setup.sh`, and `participant_action_audit.sh`.
