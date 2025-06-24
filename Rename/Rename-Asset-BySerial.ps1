#Created by Aaron C.
#06/19/2025

#Purpose of script is get current serial number from computer BIOS to replace the old computers name to be more in line with naming conventions
#This script can be repurposed to rename computers by serial number in any environment that uses PowerShell.
#This script is intended to be run once at startup, so it will rename the computer and then delete itself after execution.


$serial = (Get-WmiObject Win32_BIOs).SerialNumber.Trim()
$newName = "2311s-$serial"
$logFile = "C:\Users\Public\Desktop\RenameAssetBySerial.log"

function Write-Log ($message) {
    $timestamp = Get-Date -Format "dd/mm/yyyy HH:mm:ss"
    Add-Content -Path $logFile -Value "$timestamp - $message"
}

try{
    $currentName = (Get-WmiObject Win32_ComputerSystem).Name.Trim()

    if($currentName -ne $newName) {
        Rename-Computer -newName $newName -Force -PassThru -Restart
    }

    #self delete
    $scriptPath = $MyInvocation.MyCommand.Path
    Start-Sleep -Seconds 10
    Remove-Item -Path $scriptPath -Force
    
    } catch {
        Write-Log "An error occured in script Rename-Asset-BySerial.ps1: $($_.Exception.Message)"
    }
#End of script