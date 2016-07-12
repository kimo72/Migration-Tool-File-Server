function Import-FileScreenException ($DestinationPath)
{



     try
        {
            $importedFileScreensExceptions = Import-Clixml -Path ($DestinationPath + "\FileScreensExceptions.xml")
        }
        catch 
        {
            $output = "`nThe file ""FileScreensExceptions.xml"" couldnt be found, The Quotas templates will not be imported."
        }   


$importedFileScreensExceptions|% {

    if ($_.Path)
    {

    $FsrmFileScreenManagerObject = new-object -com FSRM.FsrmFileScreenManager
    $createFileScreenException = $FsrmFileScreenManagerObject.CreateFileScreenException($_.Path)
    $createFileScreenException.Description = $_.Description
    $uniqueAllowedFileGroups = $_.AllowedFileGroups|select -Unique
            
                foreach ($fileGroup in $uniqueAllowedFileGroups){
                        $group = $createFileScreenException.AllowedFileGroups
                        $group.add($fileGroup)
                        $createFileScreenException.AllowedFileGroups= $group
                        }
                    
                     try
                        {
                            $createFileScreenException.Commit()
                        }
                        catch 
                        {
                            $output = "The file Screen $($CreateFileScreen.path)  already exist"
                        }   


    }
}
    return $output
}

Export-ModuleMember -function Import-FileScreenException