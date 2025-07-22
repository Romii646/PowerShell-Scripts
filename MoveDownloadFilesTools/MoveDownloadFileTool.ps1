# Move-NewDownloadsToOneDrive.ps1
# Created by Aaron C.
# Purpose: Moves newer files from Downloads to OneDrive Documents\Downloads_Backup on logon

$downloads = "$env:USERPROFILE\Downloads"
$onedrive = "$env:OneDrive\Documents\Downloads_Backup"
$logFile = "C:\ProgramData\OneDriveDownloadMover.log"

# Ensure target directory exists
if (-not (Test-Path $onedrive)) {
    New-Item -ItemType Directory -Path $onedrive -Force
}

function Write-Log($msg) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "$timestamp - $msg"
}

try {
    $files = Get-ChildItem -Path $downloads -File
    foreach ($file in $files) {
        $targetFile = Join-Path $onedrive $file.Name
        if (-not (Test-Path $targetFile) -or ($file.LastWriteTime -gt (Get-Item $targetFile).LastWriteTime)) {
            Move-Item -Path $file.FullName -Destination $targetFile -Force
            Write-Log "Moved: $($file.Name)"
        }
    }
} catch {
    Write-Log "Error: $($_.Exception.Message)"
}
