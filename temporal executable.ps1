import-module 'C:\Users\admin0987\Documents\GitHub\Migration-Tool-File-Server\ExportSharesInVolume.psm1' -force

$LogicVolumen = @()
$LogicVolumen += 'D:'
$LogicVolumen += 'F:'

Export-shares-To-File -FileRepositoryPath 'C:\Users' -volumens $LogicVolumen