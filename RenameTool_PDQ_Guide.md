
# RenameTool Deployment Guide (PDQ)

This guide explains how to use `Schedule-Execute-Rename.ps1` and `Rename-Asset-BySerial.ps1` to automatically rename Windows computers based on their BIOS serial number, using a naming convention like `2311s-[SERIAL]`.

Deployment is done through **PDQ Deploy** and follows a secure, automated, and reversible process.

---

## Scripts Included

| File                           | Purpose                                                                 |
|--------------------------------|-------------------------------------------------------------------------|
| `Rename-Asset-BySerial.ps1`    | Script that performs the rename, logging, and self-deletion            |
| `Schedule-Execute-Rename.ps1`  | Script that deploys the rename script to the target system and registers it to run at next login |

---

## PDQ Deployment Setup

### Step 1: Create a New Package in PDQ Deploy

1. Open **PDQ Deploy**
2. Create a **New Package** named: `Rename Computer by Serial`

---

### Step 2: Add the Following Steps in Order

#### Step 1 – CMD Step: Leave Azure AD (if applicable)

```cmd
dsregcmd /leave
```

> This step ensures the device is not joined to Azure AD, which can sometimes interfere with rename operations. Skip this if your environment does not have this problem.

---

####  Step 2 – PowerShell Step: Temporarily Enable Administrative Rights to PowerShell Scripting

```powershell
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force 
```

> This allows the PowerShell scripts to run without being blocked by the system’s execution policy. It will be reverted after the rename process.

---

####  Step 3 – PowerShell Step: Deploy and Schedule Rename Script

Run the following script (attach `Schedule-Execute-Rename.ps1` to this step):

#### Step 4 – PowerShell Step: Revert Execution Policy

```powershell
Set-ExecutionPolicy Restricted -Scope LocalMachine -Force
```

> Re-enables scripting restrictions to maintain system security compliance.

---

## Folder Structure on Target Machines

After deployment, the following structure will be created on each machine:

```
C:\ProgramData\├── Rename-Asset-BySerial.ps1
└── RenameLog.txt
```

At next login, the script `Rename-Asset-BySerial.ps1` will execute automatically via `RunOnce`, rename the machine, restart it, and then delete itself.

---

## Sample Log Output

The script writes execution events to:

```
C:\ProgramData\RenameLog.txt
```

Example entries:

```
2025-06-19 10:42:01 - Current name: DESKTOP-ABC123 | New name: 2311s-ABC123
2025-06-19 10:42:02 - Computer renamed. Restarting...
```

If any error occurs, it will be captured in the same log file.

---

## Automatic Cleanup

The `Rename-Asset-BySerial.ps1` script:
- Renames the PC if needed
- Logs the activity
- Deletes itself after successful execution

No manual cleanup is needed.

---

## Summary of PDQ Package Steps

| Step | Type        | Description                                           |
|------|-------------|-------------------------------------------------------|
| 1    | CMD         | `dsregcmd /leave` (optional for Azure AD environments) |
| 2    | PowerShell  | Set execution policy to allow script execution        |
| 3    | PowerShell  | Deploy and schedule the rename script                 |
| 4    | PowerShell  | Revert execution policy for security                  |

---

## Permissions & Notes

- PDQ Deploy typically runs as **SYSTEM**, which has full permissions but if not rest of the steps are needed.
- Ensure the scripts are deployed with **admin rights**.
- `RunOnce` executes **at next user login**, not immediately.
- Name changes may take time to show in Azure Directory or Active Directory.

---

## Author
Created by: **Aaron C.**  
Last updated: **July 3, 2025**
