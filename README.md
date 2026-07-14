# 🖥️ IT Lab Scripts — PowerShell Toolkit
### by Oluseye Owoeye | IT Support Engineer | Level 1/2 | Konstanz, Germany

A collection of real-world PowerShell scripts built in my home lab to simulate 
and automate daily Level 1/2 IT Support tasks. All scripts are actively used 
in my lab environment running Windows Server 2022, Active Directory and Hyper-V.

---

## 📂 Scripts in This Repository

### 1. 🔍 SystemHealthCheck.ps1
**Purpose:** Quick system health overview for IT support diagnostics

**What it checks:**
- Computer name and operating system
- RAM — total, used and free
- Disk space — total, used and free
- Network IP address and default gateway
- Internet connectivity status
- Number of running Windows services

**Use case:** First script to run when a user reports slow performance or system issues

---

### 2. 🌐 NetworkDiagnostics.ps1
**Purpose:** Automated network troubleshooting — Level 1/2 ticket response tool

**What it checks:**
- IP configuration — detects APIPA (169.254.x.x) DHCP failure automatically
- Default gateway reachability
- Internet connectivity via ping to 8.8.8.8
- DNS resolution test
- Active network adapter status and speed

**Diagnosis output:** Each check returns a clear PASS/FAIL with recommended fix

**Use case:** Any network connectivity ticket — internet down, cannot reach shared drive, VPN issues

---

### 3. 👤 ADUserCheck.ps1
**Purpose:** Active Directory user account diagnostic tool

**What it does:**
- When connected to domain: pulls live AD user data including account status, 
  lockout status, password expiry and group membership
- When running locally: switches to simulation mode showing correct commands 
  and responses for the four most common AD tickets

**Common tickets covered:**
- User cannot log in — account disabled
- User forgot password — password reset procedure
- Account locked out — unlock command
- New employee needs account — creation command

**Use case:** Every AD ticket a Level 1/2 engineer handles daily

---

### 4. 🔄 UserOnboarding_Offboarding.ps1
**Purpose:** Full employee lifecycle automation tool

**Onboarding features:**
- Collects new employee details interactively
- Auto-generates username and email from name
- Generates complete 16-step IT onboarding checklist
- Displays exact PowerShell commands to create AD account
- Saves onboarding report to documentation folder automatically

**Offboarding features:**
- Displays commands to disable AD account
- Shows group membership removal commands
- Includes Microsoft 365 session revocation command

**Use case:** New starter setup and leaver process — Level 2 daily responsibility

---

## 🧪 Lab Environment

| Component | Details |
|---|---|
| **Hypervisor** | Microsoft Hyper-V |
| **Server OS** | Windows Server 2022 |
| **Client OS** | Windows 11 Pro |
| **Directory** | Active Directory Domain Services |
| **Cloud** | Microsoft Azure — AZ-900 in progress |
| **Automation** | PowerShell 5.1 |

---

## 📜 Certifications

- ✅ Google Technical Support Fundamentals — Dec 2022
- ✅ The Bits and Bytes of Computer Networking — Jan 2023
- 🔄 Google IT Support Professional Certificate — In Progress
- 🔄 Microsoft AZ-900 Azure Fundamentals — In Progress

---

## 📬 Contact

- 📍 Konstanz, Germany
- 📧 saisans127@gmail.com
- 💼 Available immediately for Level 1/2 IT Support roles in Germany and Europe
