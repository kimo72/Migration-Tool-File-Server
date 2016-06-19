import-module 'C:\Users\Administrator\Documents\GitHub\Migration-Tool-File-Server\Export-NtfsPermisions.psm1' -force

$LogicVolumen = @()
$LogicVolumen += 'K:\\'
$LogicVolumen += 'H:\\'
$LogicVolumen += 'c:\\'
$LogicVolumen += 'j:\\'
$LogicVolumen += 'k:\\'

 $aaa =Get-NtfsPermisions -DestinationPath "C:\empty" -selectedVolumenes $LogicVolumen
 $aaa