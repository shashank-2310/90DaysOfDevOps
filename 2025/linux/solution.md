# Week 2 – Linux System Administration & Automation: Solution

This document records commands and notes for all Week 2 tasks. Commands assume a Linux shell (native, WSL, or remote). Replace placeholders like `<your-username>` as needed.

---

## 1️⃣ User & Group Management

Commands used:

```bash
# Create group and user
sudo groupadd devops_team || true
sudo useradd -m -s /bin/bash -G devops_team devops_user

# Set password (interactive)
sudo passwd devops_user

# Grant sudo access (via sudo group)
sudo usermod -aG sudo devops_user
# Or add a dedicated sudoers drop-in (careful with syntax)
echo 'devops_user ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/devops_user
sudo chmod 440 /etc/sudoers.d/devops_user

# Restrict SSH login for certain users (example denies testuser)
# Edit sshd_config safely
sudo sed -i.bak '/^DenyUsers/d' /etc/ssh/sshd_config
echo 'DenyUsers testuser' | sudo tee -a /etc/ssh/sshd_config

# Reload SSH daemon
sudo systemctl reload ssh || sudo systemctl reload sshd
```

Verify:

```bash
getent passwd devops_user
id devops_user
getent group devops_team
sudo -l -U devops_user
```

Notes:
- Use `visudo` for manual edits to avoid syntax errors.
- On some distros the service is `sshd` instead of `ssh`.

---

## 2️⃣ File & Directory Permissions

Commands used:

```bash
# Create workspace and file
sudo mkdir -p /devops_workspace
sudo touch /devops_workspace/project_notes.txt

# Set ownership to devops_user:devops_team
sudo chown devops_user:devops_team /devops_workspace /devops_workspace/project_notes.txt

# Permissions: owner rw-, group r--, others --- (640 for file, 750 for dir)
sudo chmod 750 /devops_workspace
sudo chmod 640 /devops_workspace/project_notes.txt

# Verify
ls -ld /devops_workspace
ls -l /devops_workspace/project_notes.txt
```

Expected:
- `/devops_workspace` shows `drwxr-x---` (750) and owned by `devops_user:devops_team`.
- `project_notes.txt` shows `-rw-r-----` (640).

---

## 3️⃣ Log File Analysis (AWK, grep, sed)

Setup and download:

```bash
mkdir -p ~/logs
cd ~/logs
curl -L -o Linux_2k.log \
  https://raw.githubusercontent.com/logpai/loghub/master/Linux/Linux_2k.log
```

Tasks and commands:

```bash
# a) Find all occurrences of the word "error" (case-insensitive)
grep -i "error" Linux_2k.log | tee errors.log

# b) Extract timestamps and log levels (example pattern; adjust as needed)
# Assuming timestamps like 2024-01-01 12:34:56 and levels INFO/WARN/ERROR
awk '{
  ts=$1" "$2; lvl="";
  for(i=1;i<=NF;i++){
    if($i ~ /INFO|WARN|ERROR|TRACE|DEBUG/){lvl=$i; break}
  }
  if(lvl!=""){print ts, lvl}
}' Linux_2k.log | tee timestamps_levels.log

# c) Replace all IPv4 addresses with [REDACTED]
sed -E 's/([0-9]{1,3}\.){3}[0-9]{1,3}/[REDACTED]/g' \
  Linux_2k.log > Linux_2k_redacted.log

# Bonus: Most frequent entries (top 10)
sort Linux_2k.log | uniq -c | sort -nr | head -10 | tee top10.log
```

Notes:
- Log formats vary; tweak the `awk` extraction to your log’s structure.
- Use `rg` (ripgrep) if available for faster searches on large logs.

---

## 4️⃣ Volume Management & Disk Usage

Loop device practice (safe on local VMs/WSL2):

```bash
sudo mkdir -p /mnt/devops_data

# Create a sparse 1G file to simulate a disk
sudo dd if=/dev/zero of=/tmp/devops_data.img bs=1M count=0 seek=1024

# Create filesystem and mount
sudo mkfs.ext4 -F /tmp/devops_data.img
sudo mount -o loop /tmp/devops_data.img /mnt/devops_data

# Verify
df -h | grep devops_data || true
mount | grep devops_data || true

# Optional: persist via /etc/fstab (add a line like below)
# /tmp/devops_data.img  /mnt/devops_data  ext4  loop,defaults  0 0
```

Cleanup (optional):

```bash
sudo umount /mnt/devops_data
sudo rm -f /tmp/devops_data.img
```

Notes:
- On production, you’d mount a real block device (e.g., `/dev/xvdf`).
- Ensure proper fstab entries and `fsck` options for reliability.

---

## 5️⃣ Process Management & Monitoring

Commands used:

```bash
# Start a background ping
touch ~/ping_test.log
nohup bash -c 'ping -w 60 google.com >> ~/ping_test.log 2>&1' &

# Monitor
ps aux | grep ping | grep -v grep

top -b -n 1 | head -20
# htop is interactive; if installed, run:
# htop

# Kill the process (example using pkill)
# Replace <pid> with the actual PID if needed
pkill -f "ping -w 60 google.com" || true

# Verify
pgrep -f ping || echo "Ping process not running"
```

Notes:
- `nohup` allows the process to continue after logout; logs redirected to `~/ping_test.log`.
- Prefer `systemd` units or supervisors for long-running services.

---

## 6️⃣ Automate Backups with Shell Scripting

Backup directory and script:

```bash
sudo mkdir -p /backups
```

Script example (save as `/usr/local/bin/backup_devops_workspace.sh`):

```bash
#!/usr/bin/env bash
set -euo pipefail
SRC_DIR="/devops_workspace"
DEST_DIR="/backups"
DATE=$(date +%F)
ARCHIVE="backup_${DATE}.tar.gz"
COLOR_GREEN='\e[32m'
COLOR_RESET='\e[0m'

sudo tar -czf "${DEST_DIR}/${ARCHIVE}" -C "/" "${SRC_DIR#/*}"
echo -e "${COLOR_GREEN}Backup created: ${DEST_DIR}/${ARCHIVE}${COLOR_RESET}"

# Optional: rotation – keep last 7 backups
ls -1t "${DEST_DIR}"/backup_*.tar.gz 2>/dev/null | tail -n +8 | xargs -r rm -f
```

Make executable and test:

```bash
echo "Creating script..."
# If writing to /usr/local/bin requires sudo, write locally then move
cat > /tmp/backup_devops_workspace.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
SRC_DIR="/devops_workspace"
DEST_DIR="/backups"
DATE=$(date +%F)
ARCHIVE="backup_${DATE}.tar.gz"
COLOR_GREEN='\e[32m'
COLOR_RESET='\e[0m'

sudo tar -czf "${DEST_DIR}/${ARCHIVE}" -C "/" "${SRC_DIR#/*}"
echo -e "${COLOR_GREEN}Backup created: ${DEST_DIR}/${ARCHIVE}${COLOR_RESET}"

ls -1t "${DEST_DIR}"/backup_*.tar.gz 2>/dev/null | tail -n +8 | xargs -r rm -f
EOF

sudo mv /tmp/backup_devops_workspace.sh /usr/local/bin/backup_devops_workspace.sh
sudo chmod +x /usr/local/bin/backup_devops_workspace.sh

# Run once
/usr/local/bin/backup_devops_workspace.sh
```

Schedule with cron:

```bash
# Edit root crontab for daily 2 AM backup
sudo crontab -e
# Add line:
# 0 2 * * * /usr/local/bin/backup_devops_workspace.sh >/var/log/backup_devops_workspace.log 2>&1
```

Notes:
- Script prints a success message in green as required.
- Rotation keeps the latest 7 archives; adjust by changing `+8` to `+(N+1)`.

---

## 🚀 Bonus Tasks

Top 5 most common messages:

```bash
awk '{msg=$0; count[msg]++} END {for (m in count) print count[m], m}' Linux_2k.log \
  | sort -nr | head -5
```

Files modified in last 7 days:

```bash
sudo find /var/log -type f -mtime -7 -printf "%TY-%Tm-%Td %TT %p\n" | sort
```

Filter ERROR and WARNING only:

```bash
egrep -i "\b(ERROR|WARNING|WARN)\b" Linux_2k.log | tee errors_warnings.log
```

---

## 📢 Submission
- Create a LinkedIn post summarizing your work; attach screenshots or key logs.
- Use hashtags: `#90DaysOfDevOps #LinuxAdmin #DevOps`.
- Optionally link your repo and any write-ups.

---

## ✅ Checklist
- [x] Created `devops_user` in `devops_team`, sudo configured, SSH restriction applied
- [x] Set permissions for `/devops_workspace` and `project_notes.txt`
- [x] Downloaded and analyzed `Linux_2k.log` with grep/awk/sed
- [x] Mounted loop-backed volume at `/mnt/devops_data` and verified
- [x] Managed background process and verified termination
- [x] Wrote backup script with green success text, rotation, and cron
