
function Redo-FileManagementTask ($FileManagementTasks, $Id)
{

     $FileManagementTaskObj = @{
                                'Guid'=$GUID
                                'DaysSinceFileCreated' =$FileManagementTasks.DaysSinceFileCreated
                                'DaysSinceFileLastAccessed' =$FileManagementTasks.DaysSinceFileLastAccessed
                                'DaysSinceFileLastModified' =$FileManagementTasks.DaysSinceFileLastModified
                                'Description' =$FileManagementTasks.Description
                                'Enabled' =$FileManagementTasks.Enabled
                                'ExpirationDirectory' =$FileManagementTasks.ExpirationDirectory
                                'FileNamePattern' =$FileManagementTasks.FileNamePattern
                                'Formats' =$FileManagementTasks.Formats
                                'FromDate' =$FileManagementTasks.FromDate
                                'Logging' =$FileManagementTasks.Logging
                                'MailTo' =$FileManagementTasks.MailTo
                                'Name' =$FileManagementTasks.Name
                                'NamespaceRoots' =$FileManagementTasks.NamespaceRoots
                                'OperationType' =$FileManagementTasks.OperationType
                                'Parameters' =$FileManagementTasks.Parameters
                                'ReportEnabled' =$FileManagementTasks.ReportEnabled
                                'Task' =$FileManagementTasks.Task
                            }

                $FileManagementTask = New-Object –TypeName PSObject –Prop $FileManagementTaskObj 
                return  $FileManagementTask
    
}





Get-FileManagementTasks -DestinationPath "c:\empty"

function Get-FileManagementTasks ($selectedVolumenes, $DestinationPath)
{

    if((Test-Path ($DestinationPath+ '\FileManagementTasksActions.xml')) -eq $true -and (Test-Path ($DestinationPath + '\FileManagementTasks.xml')) -eq $true)
    {
        $output += "`nA file called ""FileManagementTasksActions.xml"" already exist in the specified location"
        $output += "`nA file called ""FileManagementTasks.xml"" already exist in the specified location"
        
    }
    
    $FsrmSettingObject = new-object -com FSRM.FsrmFileManagementJobManager
    
    $FileManagementTasksConfig =@()
    
    foreach ($volumeMatch in $selectedVolumenes)
        {
            $FileManagementTasksConfig += $FsrmSettingObject.EnumFileManagementJobs()#| where {$_.NamespaceRoots -match $volumeMatch} 
        }
         $FileManagementTasksConfig += $FsrmSettingObject.EnumFileManagementJobs()| where {$_.NamespaceRoots -match 'Y:\\'} 
        $eeeeee =$FsrmSettingObject.EnumFileManagementJobs()
        $eeeeee
        $eeeeee|%{$_|GM}
        $eeeeee|%{$_.PropertyConditions}
                $eeeeee|%{$_.CustomAction}
         $eeeeee|%{$_.EnumNotificationActions(3)}
        
        EnumNotificationActions
        ###################################################
            
            $exportedFileManagementTasksConfig =@()
        
            foreach ($ManagementTasks in $FileManagementTasksConfig )
            {
                 $GUID =[guid]::NewGuid()
                  $exportedFileManagementTasksConfig += Redo-FileManagementTask -FileManagementTasks $ManagementTasks -Id $GUID
                        
                  $exportedFileManagementTasksConfig
            }
        ##################################################
        
        
        
        
        
        $exportedFileManagementTasksActions| Export-Clixml -Path ( $DestinationPath + "\FileManagementTasksActions.xml")
        $exportedFileManagementTasksConfig | Export-Clixml -Path ( $DestinationPath + "\FileManagementTasks.xml") -Depth 4
        
           $output += "`nThe exportation of the file ""FileManagementTasksActions.xml"" was successful"
           $output += "`nThe exportation of the file ""FileManagementTasks.xml"" was successful"
    
        return $output
        
}