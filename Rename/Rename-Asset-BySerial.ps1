#Created by Aaron C.
#06/19/2025

#Purpose of script is get current serial number from computer BIOS to replace the old computers name to be more in line with naming conventions

$serial = (Get-WmiObject Win32_BIOs).SerialNumber.Trim()
$newName = "2311s-$serial"

$currentName = (Get-WmiObject Win32_ComputerSystem).Name.Trim()

if($currentName -ne $newName) {
    Rename-Computer -newName $newName -Force -PassThru -Restart
}

#self delete
$scriptPath = $MyInvocation.MyCommand.Path
Start-Sleep -Seconds 10
Remove-Item -Path $scriptPath -Force
#End of script