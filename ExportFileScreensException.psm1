function Get-FileScreenConfigExceptions ($selectedVolumenes, $DestinationPath)
{
       if((Test-Path ($DestinationPath+ '\FileScreensExceptions.xml')) -eq $true)
    {
        $output = "`nA file called ""FileScreensExceptions.xml"" already exist in the specified location"
        
    }
    
    else
    {

        $FsrmFileScreenObj = new-object -com FSRM.FsrmFileScreenManager
        $FileScreenExceptionsConfig =@()
        foreach ($volumeMatch in $selectedVolumenes)
            {
                $FileScreenExceptionsConfig += $FsrmFileScreenObj.EnumFileScreens()| where {$_.path -match $volumeMatch} 
            }
            $output =$FileScreenExceptionsConfig
        $ExportedFileScreenExceptionsConfig =@()    
        foreach ($FileScreenExceptions in $FileScreenConfigExceptions)
            {
                
                if ( $FileScreenExceptions.path -ne $null)
                {
                    $ExportedFileScreenExceptionsConfig += $FileScreenExceptions     
                }

            }
            
            $ExportedFileScreenExceptionsConfig |Export-Clixml -Path C:\empty\FileScreensExceptions.xml            
            $output = "`nThe importation of the file ""FileScreensExceptions.xml"" was successful"

    
    }
    
    return $output
    
}

Export-ModuleMember -function Get-FileScreenConfigExceptions