function Import-FSRMServerConfiguration ($DestinationPath)
{



    if([System.IO.file]::Exists($($DestinationPath +"\ServerConfigurations.xml")) -eq $false)
    {
        $output = @()
        $output +=  "`nThe file ""ServerConfigurations.xml"" couldnt be found, The FSRM Server Configurations will not be imported."
        return $output
    }
    else
    {
        $importedServerConfigurations = Import-Clixml -Path ($DestinationPath +"\ServerConfigurations.xml")#|%{$_.guid}
        $importedServerConfigurations = Import-Clixml -Path ($DestinationPath + "\ServerConfigurations.xml")#|%{$_.guid}
        #$importedServerConfigurations = Import-Clixml -Path ("C:\empty\ServerConfigurations.xml")#|%{$_.guid}
    }

    $FsrmSettingConfigObject = new-object -com FSRM.FsrmSetting

    
    # Imports notification limits Tab configurations 
    $notificationlimits = $importedServerConfigurations|Where-Object{$_.notificationlimits -eq "notificationlimits"}    
    $FsrmSettingConfigObject.SetActionRunLimitInterval(1,$notificationlimits.EventLog)
    $FsrmSettingConfigObject.SetActionRunLimitInterval(2,$notificationlimits.Email)
    $FsrmSettingConfigObject.SetActionRunLimitInterval(3,$notificationlimits.Command)
    $FsrmSettingConfigObject.SetActionRunLimitInterval(4,$notificationlimits.Report)
   
     
     # Imports email notification and Screening Audit Tab configurations 
 
    $emailNotifications= $importedServerConfigurations|Where-Object{$_.PSTypeNames -contains "Deserialized.System.__ComObject"} 
    $FsrmSettingConfigObject.AdminEmail = $emailNotifications.AdminEmail
    $FsrmSettingConfigObject.DisableCommandLine = $emailNotifications.DisableCommandLine
    $FsrmSettingConfigObject.EnableScreeningAudit = $emailNotifications.EnableScreeningAudit
    $FsrmSettingConfigObject.MailFrom = $emailNotifications.MailFrom
    $FsrmSettingConfigObject.SmtpServer = $emailNotifications.SmtpServer
    
    
     # Imports Reports Location Tab configurations
    $FsrmReportManagerObject = new-object -com FSRM.FsrmReportManager
    $ReportsfolderLocation = $importedServerConfigurations|Where-Object{$_.ReportsLocation -eq "ReportsLocation"}
   
    
    
              try
                {
                     $FsrmReportManagerObject.SetOutputDirectory(2,$ReportsfolderLocation.ScheduledReport)
                }
                catch
                {
                    $output = "Unable to set the folder to store the ScheduledReport in the path $($ReportsfolderLocation.ScheduledReport), please validate if the folder exist"
                    $_ | Out-File ($DestinationPath + "\logs\FSRMServerConfiguration.log") -Append
                    $output | Out-File ($DestinationPath + "\logs\FSRMServerConfiguration.log") -Append
                }  
                
                
              try
                {
                     $FsrmReportManagerObject.SetOutputDirectory(3,$ReportsfolderLocation.InteractiveReport)
                }
                catch
                {
                    $output = "Unable to set the folder to store the Interactive Reports in the path $($ReportsfolderLocation.InteractiveReport), please validate if the folder exist"
                    $_ | Out-File ($DestinationPath + "\logs\FSRMServerConfiguration.log") -Append
                    $output | Out-File ($DestinationPath + "\logs\FSRMServerConfiguration.log") -Append
                }  
                
                
              try
                {
                     $FsrmReportManagerObject.SetOutputDirectory(4,$ReportsfolderLocation.IncidentReport)
                }
                catch
                {
                    $output = "Unable to set the folder to store the Incidents Reports in the path $($ReportsfolderLocation.IncidentReport), please validate if the folder exist"
                    $_ | Out-File ($DestinationPath + "\logs\FSRMServerConfiguration.log") -Append
                    $output | Out-File ($DestinationPath + "\logs\FSRMServerConfiguration.log") -Append
                }  
                
                
                # Imports the storage reports Tab configurations 
                
              $StorageReports = $importedServerConfigurations|Where-Object{$_.StorageReports -eq "StorageReports"}  
              
        
                        $FsrmReportManagerObject.SetDefaultFilter(9,2,$StorageReports.FileScreenAudit1)           
                        $FsrmReportManagerObject.SetDefaultFilter(9,6,($StorageReports.FileScreenAudit2).ToArray())                 
                        $FsrmReportManagerObject.SetDefaultFilter(2,5,($StorageReports.FilesByTypeFileGroup).ToArray())
                        $FsrmReportManagerObject.SetDefaultFilter(6,6,($StorageReports.FilesByOwner1).ToArray())
                        $FsrmReportManagerObject.SetDefaultFilter(6,7,$StorageReports.FilesByOwner2)
                        $FsrmReportManagerObject.SetDefaultFilter(10,7,$StorageReports.FilesByProperty1)
                        $FsrmReportManagerObject.SetDefaultFilter(10,8,$StorageReports.FilesByProperty2)
                        $FsrmReportManagerObject.SetDefaultFilter(1,1,$StorageReports.LargeFiles1)
                        $FsrmReportManagerObject.SetDefaultFilter(1,7,$StorageReports.LargeFiles2)
                        $FsrmReportManagerObject.SetDefaultFilter(3,2,$StorageReports.LeastRecentlyAccessed1)
                        $FsrmReportManagerObject.SetDefaultFilter(3,7,$StorageReports.LeastRecentlyAccessed2)
                        $FsrmReportManagerObject.SetDefaultFilter(4,3,$StorageReports.MostRecentlyAccessed1)
                        $FsrmReportManagerObject.SetDefaultFilter(4,7,$StorageReports.MostRecentlyAccessed2)
                        $FsrmReportManagerObject.SetDefaultFilter(5,4,$StorageReports.QuotaUsage)
              
              # Imports the automatic clasificacion Tab configurations
              
              
              $AutomatiClassification = $importedServerConfigurations|Where-Object{$_.AutomatiClassification -eq "AutomatiClassification"} 
              
              
                 $FsrmReportManagerObject = new-object -com Fsrm.FsrmClassificationManager
                 $FsrmReportManagerObject.ClassificationReportFormats = ($AutomatiClassification.ClassificationReportFormats).toarray()
                 $FsrmReportManagerObject.Logging = $AutomatiClassification.Logging
                 $FsrmReportManagerObject.ClassificationReportMailTo = $AutomatiClassification.ClassificationReportMailTo
                 $FsrmReportManagerObject.ClassificationReportEnabled = $AutomatiClassification.ClassificationReportEnabled
              
          
        schtasks /create /xml:"$($DestinationPath +"\classification.xml")" /tn:"FsrmAutoClassification{c94c42c4-08d5-473d-8b2d-98ea77d55acd}"
              
              
              
             
              
            
    
    $output = "`nThe importation of the FSRM Server Configuration was successful, please review the log folder, for more information "
    return $output 

}


Export-ModuleMember -function "Import-FSRMServerConfiguration"

