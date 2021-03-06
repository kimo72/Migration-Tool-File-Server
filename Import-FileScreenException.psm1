function Import-FileScreenException ($DestinationPath)
{



     try
        {
            $importedFileScreensExceptions = Import-Clixml -Path ($DestinationPath + "\FileScreensExceptions.xml")
        }
        catch 
        {
            $output = "`nThe file ""FileScreensExceptions.xml"" couldnt be found, The  FileScreens Exceptions will not be imported."
            return  $output
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
                            $output ="Unable to create the FileScreenException in the path $($createFileScreenException.path)"
                            $_ | Out-File ($DestinationPath + "\logs\FileScreenException.log") -Append
                            $output | Out-File ($DestinationPath + "\logs\FileScreenException.log") -Append
                            
                            
                        }   


    }
}
    return $output
}

Export-ModuleMember -function Import-FileScreenException