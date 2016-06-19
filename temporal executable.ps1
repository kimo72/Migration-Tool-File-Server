import-module 'C:\Users\Administrator\Documents\GitHub\Migration-Tool-File-Server\ExportQuota.psm1' -force

$LogicVolumen = @()
$LogicVolumen += 'K:\\'
#$LogicVolumen += 'H:'

Get-QuotaConfig -DestinationPath "C:\empty" -selectedVolumenes $LogicVolumen