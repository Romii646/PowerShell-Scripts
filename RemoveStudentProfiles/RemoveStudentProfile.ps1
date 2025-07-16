#User profile deletion script
#Created by Aaron C.


<# $LogDir = "C:\ProgramData\SchoolTools"

If(-not(Test-Path $LogDir)){
    New-Item -ItemType Directory -Path $LogDir -Force
} #>

$LogFile = "C:\Users\Desktop\ProfileCleanup.log"
function Write-Log ($message) {
    $timestamp = Get-Date -Format "dd/mm/yyyy HH:mm:ss"
    Add-Content -Path $logFile -Value "$timestamp - $message"
}

$ProfilesToKeep = @(
    "Administrator",
    "Default",
    "DefaultAccount",
    "Public",
    "SYSTEM",
    "LOCAL SERVICE",
    "NETWORK SERVICE"
)

# Grab all User Profiles except System files and anyother excluding specific file in @ProfilesToKeep variable.
$UserProfilesToDelete = Get-CimInstance -ClassName Win32_UserProfile | Where-Object {
    $_.Special -eq $false -and $_.LocalPath -notmatch "C:\\Windows\\System32" -and 
    ($ProfilesToKeep -notcontains ($_.LocalPath -Split '\\')[-1]) -and #Extracts the last part from the file path [-1]
    ($_.LocalPath -notlike "Windows")
}

#Start of operation to delete user profiles
if($UserProfilesToDelete.Count -gt 0) {
    try{
        foreach($UserProfile in $UserProfilesToDelete) {
            $UserProfile.Delete()
        }
    } 
    catch {
         Write-Log "Failed to delete profile: $($UserProfile.LocalPath). Error: $($_.Exception.Message)"
    }
}
else{
    exit
}
# new temp path array with system-wide locations
$TempPath = @(
    "$env:SystemDrive\Windows\Temp",
    "$env:ProgramData\temp",
    "$env:LOCALAPPDATA\Temp",
    "$env:TEMP" #User's temporary profile.
)

Get-ChildItem "C:\Users\*" -Directory | ForEach-Object {
    $TempPath += "$($_.FullName)\AppData\Local\Temp"
    $TempPath += "$($_.FullName)\AppData\Roaming\Microsoft\Windows\Recent"  
}

foreach($Path in ($TempPath | Select-Object -Unique)) {
    if (Test-Path $Path) {
        try {
            Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        } 
        catch {
            Write-Log "Failed to clean $Path. Error $($_.Exception.Message)"
        }
    }
    else{
        Write-Log "Temp path does not exist: $Path"

    }
}

# Self delete
    $scriptPath = $MyInvocation.MyCommand.Path
    Start-Sleep -Seconds 10
    try {
        Remove-Item -Path $scriptPath -Force
    } catch {
        Write-Log "An error occurred while trying to delete the script: $($_.Exception.Message)"
    }
    Restart-Computer -Force
        
<# Use Case: School Devices
“The techs want the devices to feel new to the next student, but not spend all day reimaging machines.”

This script is intended for:

Reset each computer to a clean state

Get rid of old students profiles/data between school year

Should save hours of IT time #>