
function Redo-AutomatiClassification ($AutomatiClassification)
{

     $AutomatiClassificationObj = @{  
                                    'AutomatiClassification' = "AutomatiClassification"                               
                                    'ClassificationReportFormats' = $AutomatiClassification.ClassificationReportFormats
                                    'Logging' = $AutomatiClassification.Logging
                                    'ClassificationReportMailTo' = $AutomatiClassification.ClassificationReportMailTo
                                    'ClassificationReportEnabled' = $AutomatiClassification.ClassificationReportEnabled
                                    
                               }

                $OBJ = New-Object –TypeName PSObject –Prop $AutomatiClassificationObj 
                return  $OBJ
    
}

 
function Redo-StorageReports ($StorageReports)
{

     $StorageReportsObj = @{  
                                    'StorageReports' = "StorageReports" 
                                    'FileScreenAudit1' = $StorageReports.GetDefaultFilter(9,2)           
                                    'FileScreenAudit2' = $StorageReports.GetDefaultFilter(9,6)                 
                                    'FilesByTypeFileGroup' = $StorageReports.GetDefaultFilter(2,5)
                                    'FilesByOwner1' = $StorageReports.GetDefaultFilter(6,6)
                                    'FilesByOwner2' = $StorageReports.GetDefaultFilter(6,7)
                                    'FilesByProperty1' = $StorageReports.GetDefaultFilter(10,7)
                                    'FilesByProperty2' = $StorageReports.GetDefaultFilter(10,8)
                                    'LargeFiles1'= $StorageReports.GetDefaultFilter(1,1)
                                    'LargeFiles2'= $StorageReports.GetDefaultFilter(1,7)
                                    'LeastRecentlyAccessed1'= $StorageReports.GetDefaultFilter(3,2)
                                    'LeastRecentlyAccessed2'= $StorageReports.GetDefaultFilter(3,7)
                                    'MostRecentlyAccessed1'= $StorageReports.GetDefaultFilter(4,3)
                                    'MostRecentlyAccessed2'= $StorageReports.GetDefaultFilter(4,7)
                                    'QuotaUsage'= $StorageReports.GetDefaultFilter(5,4)
                                                                                           
                               }

                $OBJ = New-Object –TypeName PSObject –Prop $StorageReportsObj 
                return  $OBJ
    
}
 


function Redo-NotificationLimits ($notificationLimits)
{

     $notificationLimitsObj = @{  
                                    'notificationlimits' = "notificationlimits"                               
                                    'EventLog' = $notificationLimits.GetActionRunLimitInterval(1)
                                    'Email' = $notificationLimits.GetActionRunLimitInterval(2)
                                    'Command' = $notificationLimits.GetActionRunLimitInterval(3)
                                    'Report'= $notificationLimits.GetActionRunLimitInterval(4)                                  
                               }

                $OBJ = New-Object –TypeName PSObject –Prop $notificationLimitsObj 
                return  $OBJ
    
}




function Redo-ReportsLocation ($ReportsLocation)
{

     $ReportsLocationObj = @{  
                                'ReportsLocation' = "ReportsLocation"                               
                                'ScheduledReport' = $ReportsLocation.GetOutputDirectory(2)
                                'InteractiveReport' = $ReportsLocation.GetOutputDirectory(3)
                                'IncidentReport' = $ReportsLocation.GetOutputDirectory(4)                                       
                           }

                $OBJ = New-Object –TypeName PSObject –Prop $ReportsLocationObj 
                return  $OBJ
    
}




        
 
function Export-FSRMServerConfiguration ($Destinationfolder)
{



     if((Test-Path ($Destinationfolder+ '\ServerConfigurations.xml')) -eq $true)
    {
        $output += "`nA file called ""ServerConfigurations.xml"" already exist in the specified location" 
        return  $output 
    }
        $exportedFsrmSettingConfig =@()
        $FsrmSettingConfig = new-object -com FSRM.FsrmSetting
        $FsrmReportManagerObject = new-object -com FSRM.FsrmReportManager
        $FsrmAutomatiClassification = new-object -com Fsrm.FsrmClassificationManager
        
        $exportedFsrmSettingConfig += Redo-AutomatiClassification -AutomatiClassification $FsrmAutomatiClassification
        $exportedFsrmSettingConfig += Redo-StorageReports -StorageReports $FsrmReportManagerObject
        $exportedFsrmSettingConfig += Redo-notificationLimits -NotificationLimits $FsrmSettingConfig
        $exportedFsrmSettingConfig += Redo-ReportsLocation -ReportsLocation $FsrmReportManagerObject
        $exportedFsrmSettingConfig += $FsrmSettingConfig
        $exportedFsrmSettingConfig | Export-Clixml -Path ( $Destinationfolder + "\ServerConfigurations.xml") 
        
        
        Schtasks /query /tn:”FsrmAutoClassification{c94c42c4-08d5-473d-8b2d-98ea77d55acd}” /xml > ( $Destinationfolder + "\classification.xml") 
        
        
        $output += "`nThe exportation of the file ""ServerConfigurations.xml"" was successful"
        
        return  $output
    }
  
  Export-ModuleMember -function "Export-FSRMServerConfiguration"  
    
