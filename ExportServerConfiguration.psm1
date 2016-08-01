
function Redo-notificationLimits ($notificationLimits)
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
        

        $exportedFsrmSettingConfig += Redo-notificationLimits -notificationLimits $FsrmSettingConfig
        $exportedFsrmSettingConfig += Redo-ReportsLocation -ReportsLocation $FsrmReportManagerObject
        $exportedFsrmSettingConfig += $FsrmSettingConfig
        $exportedFsrmSettingConfig | Export-Clixml -Path ( $Destinationfolder + "\ServerConfigurations.xml") 
        
        $output += "`nThe exportation of the file ""ServerConfigurations.xml"" was successful"
        
        return  $output
    }
  
  Export-ModuleMember -function "Export-FSRMServerConfiguration"  
    
