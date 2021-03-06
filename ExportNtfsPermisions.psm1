function executeProcess ($arguments)
{
                   $psi = New-object System.Diagnostics.ProcessStartInfo 
                   $psi.CreateNoWindow = $false 
                   $psi.UseShellExecute = $true 
                   $psi.RedirectStandardOutput = $false 
                   $psi.RedirectStandardError = $false 
                   $psi.FileName = "cmd"
                   $psi.Arguments = "$arguments"
                   $process = New-Object System.Diagnostics.Process 
                   $process.StartInfo = $psi 
                   [void]$process.Start()
                   #$output = $process.StandardOutput.ReadToEnd()
                   #$process.WaitForExit()               
                   return $psi.Arguments
}



function Get-NtfsPermisions ($selectedVolumenes, $DestinationPath)
{

   if ((Test-Path($DestinationPath + "\Ntfs-Permisions")) -eq $true) {}else{new-item -Path ($DestinationPath + "\Ntfs-Permisions")  -Force -ItemType Directory}
   if ((Test-Path($DestinationPath + "\Logs")) -eq $true) {}else{new-item -Path ($DestinationPath + "\Logs")  -Force -ItemType Directory}
   if ((Test-Path($DestinationPath + "\Logs\Ntfs-errors")) -eq $true) {}else{new-item -Path ($DestinationPath + "\Logs\Ntfs-Errors\")  -Force -ItemType Directory}
   if ((Test-Path($DestinationPath + "\Logs\Ntfs-succesful")) -eq $true) {}else{new-item -Path ($DestinationPath + "\Logs\Ntfs-Succesful\")  -Force -ItemType Directory}
   

    foreach ($item in $selectedVolumenes)
    {
    $fileName = $item.Replace(":\\","") 

    $volumeArraryNtfs += executeProcess -arguments ("/c icacls " + $fileName +":\* /save " +"`"$DestinationPath"  + "\Ntfs-Permisions\"+ $fileName+ ".txt`"" + " /t /c > "+ "`"$DestinationPath" + "\Logs\Ntfs-succesful\" + $fileName+ ".log`" 2> " + "`"$DestinationPath" + "\Logs\Ntfs-Errors\" + $fileName+ ".log`"" )
    }

        #return $volumeArraryNtfs 
        return "`nThe exportation of the NTFS permission has finished, please refer to the log folder to review the errors."
    
}

Export-ModuleMember -function  Get-NtfsPermisions