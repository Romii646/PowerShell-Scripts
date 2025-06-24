# FolderPath is used to copy the script to the target system
$folderPath = "C:Users\Public\Desktop"

# Path to copy the renaming script to
$targetPath = Join-Path $folderPath "Rename-Asset-BySerial.ps1" # Copies Rename-PC-BySerial.ps1 from the PDQ working directory where the deploy step runs to the target system.

# copy script from PDQ working directory to local path ensure that we have a full path for -path
Copy-Item -Path "Rename-Asset-BySerial.ps1" -Destination $targetPath -Force

# Register the script to run once at startup
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" -Name "RenameAssetBySerial" -Value "PowerShell.exe -ExecutionPolicy Bypass -File `"$targetPath`"" -PropertyType String -Force