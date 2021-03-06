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



function Import-NtfsPermisions ($DestinationPath)
{

$NtfsPermisions = Get-ChildItem "C:\empty\Ntfs-Permisions"

 foreach ($NTFSfile in $NtfsPermisions)
    {
        $volumeArraryNtfs += executeProcess -arguments ("/c icacls " + $NTFSfile.BaseName +":\ /restore " + "`"$($NTFSfile.FullName)`"" + " /t /c > "+ "`"$DestinationPath" + "\Logs\Ntfs-succesful\Import-" + $NTFSfile.BaseName+ ".log`" 2> " + "`"$DestinationPath" + "\Logs\Ntfs-Errors\Import-" + $NTFSfile.BaseName+ ".log`"" )
    }

        #return $volumeArraryNtfs 
        return "`nThe Importation of the NTFS permission has finished, please refer to the log folder to review the errors."
    
}

Export-ModuleMember -function Import-NtfsPermisions