# Path to copy the renaming script to
$targetPath = "$env:ProgramData\Rename-Asset-BySerial.ps1"

# copy script from PDQ working directory to local path
Copy-Item -Path "Rename-Asset-BySerial.ps1" -Destination $targetPath -Force

#Register the script to run once at startup
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" -Name "RenameAssetBySerial" -Value $targetPath -Force
    -Name "RenamePCOnce" `
    -Value "PowerShell.exe -ExecutionPolicy Bypass -File `"$targetPath`"" `
    -PropertyType String -Force