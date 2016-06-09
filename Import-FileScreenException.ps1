$importedFileScreensExceptions = Import-Clixml -Path C:\empty\FileScreensExceptions.xml

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

$createFileScreenException.Commit()
}
}





#$FsrmFileScreenManagerObject.EnumFileScreenExceptions()|%{ $_|% {$_.AllowedFileGroups|gm}}

