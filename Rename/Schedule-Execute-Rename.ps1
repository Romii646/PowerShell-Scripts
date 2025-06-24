# Created by Aaron C.
#The file to be run in the PDQ enviroments (powershell step)
# FolderPath is used to copy the script to the target system
#"C:\ProgramData would be the most recommened location to copy Rename-asset-BySerial.ps1 file
$folderPath = "C:\Users\Public\Desktop"
$logFile = Join-Path $folderPath "RenameAssetbySerial.log"

# Copies Rename-PC-BySerial.ps1 from the PDQ working directory where the deploy step runs to the target system.
$targetPath = Join-Path $folderPath "Rename-Asset-BySerial.ps1" 

function Write-Log ($message) {
    $timestamp = Get-Date -Format "dd/mm/yyyy HH:mm:ss"
    Add-Content -Path $logFile -Value "$timestamp - $message"
}

try{
# copy script from PDQ working directory to local path 
    Copy-Item -Path ".\Rename-Asset-BySerial.ps1" -Destination $targetPath -Force
}catch{
    Write-Log "Failed to copy script to target path: $targetPath. Error: $($_.Exception.Message)"
}

try{
# Register the script to the registry and run once at startup
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" -Name "RenameAssetBySerial" -Value "PowerShell.exe -ExecutionPolicy Bypass -File `"$targetPath`"" -PropertyType String -Force
    Write-Log "RunOnce key created. Script will run at next user login."
} catch {
    Write-Log "Failed to register script to run at startup. Error: $($_.Exception.Message)"
}