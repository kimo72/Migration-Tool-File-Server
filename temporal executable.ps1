import-module 'C:\Users\Administrator\Documents\GitHub\Migration-Tool-File-Server\ImportNtfsPermisions.psm1'  -force
$LogicVolumen = @()
$LogicVolumen += 'K:\\'
$LogicVolumen += 'H:\\'
$LogicVolumen += 'G:\\'
$LogicVolumen += 'E:\\'
#$LogicVolumen += 'k:\\'

 $aaa = Import-NtfsPermisions -DestinationPath "C:\empty" 
 $aaa