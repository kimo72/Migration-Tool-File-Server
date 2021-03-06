function Get-FileScreenExceptionsConfig ($selectedVolumenes, $DestinationPath)
{
       if([System.IO.File]::Exists($DestinationPath+ '\FileScreensExceptions.xml') -eq $true)
    {
        $output = "`nA file called ""FileScreensExceptions.xml"" already exist in the specified location"
        
    }
    
    else
    {

        $FsrmFileScreenObj = new-object -com FSRM.FsrmFileScreenManager
        $FileScreenExceptionsConfig =@()
        foreach ($volumeMatch in $selectedVolumenes)
            {
                $FileScreenExceptionsConfig += $FsrmFileScreenObj.EnumFileScreenExceptions()| where {$_.path -match $volumeMatch} 
            }
            #$output =$FileScreenExceptionsConfig
        $ExportedFileScreenExceptionsConfig =@()    
        foreach ($FileScreenExceptions in $FileScreenExceptionsConfig)
            {
                
                if ( $FileScreenExceptions.path -ne $null)
                {
                    $ExportedFileScreenExceptionsConfig += $FileScreenExceptions     
                }

            }
            
            $ExportedFileScreenExceptionsConfig |Export-Clixml -Path  ($DestinationPath +"\FileScreensExceptions.xml")            
            $output = "`nThe importation of the file ""FileScreensExceptions.xml"" was successful"

    
    }
    
    return $output
    
}

Export-ModuleMember -function Get-FileScreenExceptionsConfig