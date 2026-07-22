# 📘 Abtech SOC: Wazuh EDR & SIEM Operations Guide

**Document Version:** 1.0  
**Classification:** Internal — SOC Engineering Team  
**Platform:** Wazuh 4.9.x on Ubuntu 24.04 LTS (Dockerized)  

## 1. Overview
This document outlines the standard operating procedures (SOP), architectural configurations, and active response mechanisms for the Abtech Autonomous SOC environment. The SIEM is deployed as a single-node Docker cluster operating over a secure Tailscale Mesh VPN.

## 2. Agent Deployment & Enrollment
To ensure zero exposure to the public internet, all Wazuh agents communicate with the Manager exclusively via the Tailscale VPN interface.

**Standard Linux Agent Deployment (Ubuntu/Debian):**
```bash
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.9.0-1_amd64.deb
sudo WAZUH_MANAGER='100.xxx.xx.xx' WAZUH_AGENT_NAME='[Target-Hostname]' dpkg -i ./wazuh-agent_4.9.0-1_amd64.deb
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

## 3. SOAR Integration (n8n Webhook)
Alerts hitting a severity threshold of **Level 10 or higher** are automatically shipped to the n8n SOAR engine via a custom Python integration script.

**Configuration path (`/var/ossec/etc/ossec.conf`):**
```xml
  <integration>
    <name>custom-n8n</name>
    <hook_url>http://100.12x.xx.xx:xxxx/webhook/wazuh-alert</hook_url>
    <level>10</level>
    <alert_format>json</alert_format>
  </integration>
```
*Note: Due to Docker named-volume caching (`wazuh_etc`), configuration edits must be applied to the host-mapped file and the container must be restarted to ingest changes.*

## 4. Active Response (Automated Containment)
The SOC is configured to automatically quarantine compromised endpoints. 
The `firewall-drop` active response is triggered under the following conditions:
*   **Target Rule ID:** `5712` (SSHD Brute Force)
*   **Timeout:** 180 seconds (Configurable based on threat modeling)
*   **Whitelist Exclusions:** `127.0.0.1` and `localhost` are globally whitelisted to prevent system lockout.

## 5. System Troubleshooting & Diagnostics
If the n8n webhook fails to fire during a suspected incident, analysts should verify the agent connection state and exponential backoff locks.
