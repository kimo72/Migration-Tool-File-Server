Import-Module 'C:\Users\admin0987\Documents\GitHub\Migration-Tool-File-Server\Export File Screen function.psm1' -Force
$selectedVolumenes =@()
$selectedVolumenes +="K:\\"
#$selectedVolumenes +="F:\\"
$selectedVolumenes +="G:\\"
#$selectedVolumenes +="J:\\"
$DestinationPath = "C:\empty"
Get-FileScreenConfig -selectedVolumenes $selectedVolumenes -DestinationPath $DestinationPath




