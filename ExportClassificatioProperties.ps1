  $FsrmClassificationObject = new-object -com FSRM.FsrmClassificationManager
  $FsrmClassificationObject.EnumPropertyDefinitions()
  Get-FileManagementTasks ($selectedVolumenes, $DestinationPathins 