
function Import-Quotas ($DestinationPath)
{




if([System.IO.file]::Exists($($DestinationPath +"\Quotas.xml")) -eq $false -and [System.IO.file]::Exists($DestinationPath +"\QuotasThresholds.xml") -eq $false)
{
    $output = @()
    $output +=  "`nThe file ""Quotas.xml"" couldnt be found, The Quotas will not be imported."
    $output += "`nThe file ""QuotasThresholds.xml"" couldnt be found, The Quotas will not be imported."
    return $output
}
elseif(!([System.IO.file]::Exists($DestinationPath +"\Quotas.xml")))
{
    $output = "`nThe file ""Quotas.xml"" couldnt be found, The Quotas will not be imported."
    return $output
}
elseif(!([System.IO.file]::Exists($DestinationPath +"\QuotasThresholds.xml")))
{
    $output = "`nThe file ""QuotasThresholds.xml"" couldnt be found, The Quotas will not be imported."
    return $output
}
else
{
    $quotas = Import-Clixml -Path ($DestinationPath +"\Quotas.xml")
    $importQuotasThresholds = Import-Clixml -Path ($DestinationPath +"\QuotasThresholds.xml")
}
######################thiscreates de cuotas
  
  
  foreach ($quota in $quotas)
  {
    
      if($quota.path -ne $null)
      {
            $FsrmQuotaObject = new-object -com FSRM.FsrmQuotaManager
            try
            {
                 $createdQuotas = $FsrmQuotaObject.CreateQuota($quota.Path)
                 #$createdQuotas = $FsrmQuotaObject.CreateQuota("z:")
            }
            catch
            {
                $output = "`nUnable to create the quota in empty path $($quota.Path)"
            }
                       
                if($quota.SourceTemplateName -eq $null   )
                {
                    
                    #This creates the custom quotas#
                  
                   
                    #This creates the quota Thresholds
                    foreach ($Threshold in $quota.Thresholds)
                    {
                        $createdQuotas.AddThreshold($Threshold)
                        $createdQuotas.Description =($quota.Description) 
                        $createdQuotas.QuotaFlags =($quota.QuotaFlags) 
                        $createdQuotas.QuotaLimit =($quota.QuotaLimit)
                        $createdQuotas.Commit()
                    }
                    
                    #This creates the quota Actions
                    foreach ($quotaThreshold in $quota)
                            {
                             $importQuotasThresholds |Where-Object {$quotaThreshold.Guid -eq $_.Guid } |%{
                             $filterQuotas = $_
                                    switch ($_.ActionType)
                                    {
                                        1 { 
                                    
                                            $createdAction = $FsrmQuotaObject.GetQuota($quotaThreshold.path)
                                            $Action1 = $createdAction.CreateThresholdAction($filterQuotas.threshold0X,1)
                                            $Action1.RunLimitInterval = $filterQuotas.RunLimitInterval
                                            $Action1.EventType = $filterQuotas.EventType
                                            $Action1.MessageText = $filterQuotas.MessageText
                                            $createdAction.Commit()}
                                    
                                    
                                        2 { 
                                
                                            $createdAction = $FsrmQuotaObject.GetQuota($quotaThreshold.path)
                                            $Action2 = $createdAction.CreateThresholdAction($filterQuotas.threshold0X,2)       
                                            $Action2.RunLimitInterval =$filterQuotas.RunLimitInterval
                                            $Action2.MailFrom =$filterQuotas.MailFrom
                                            $Action2.MailReplyTo =$filterQuotas.MailReplyTo
                                            $Action2.MailTo =$filterQuotas.MailTo
                                            $Action2.MailCc =$filterQuotas.MailCc
                                            $Action2.MailBcc =$filterQuotas.MailBcc
                                            $Action2.MailSubject =$filterQuotas.MailSubject
                                            $Action2.MessageText =$filterQuotas.MessageText
                                            $createdAction.Commit()}
                                    
                                    
                                        3 { 
                                             $createdAction = $FsrmQuotaObject.GetQuota($quotaThreshold.path)
                                             $Action3 = $createdAction.CreateThresholdAction($filterQuotas.threshold0X,3)
                                             $Action3.RunLimitInterval=$filterQuotas.RunLimitInterval
                                             
                                             
                                                  try
                                                    {
                                                        $Action3.ExecutablePath=$filterQuotas.ExecutablePath
                                                    }
                                                    catch
                                                    {
                                                        $output = "Unable to create the custom Quota in the path $($CreateFileScreen.path), because couldnt find the executable path $($filterQuotas.ExecutablePath) of the action"
                                                        $_ | Out-File ($DestinationPath + "\logs\Quota.log") -Append
                                                        $output | Out-File ($DestinationPath + "\logs\Quota.log") -Append
                                                    }   
                                                             
                                             
                                             $Action3.Arguments=$filterQuotas.Arguments
                                             $Action3.Account=$filterQuotas.Account
                                             $Action3.WorkingDirectory=$filterQuotas.WorkingDirectory
                                             $Action3.MonitorCommand=$filterQuotas.MonitorCommand
                                             $Action3.KillTimeOut=$filterQuotas.KillTimeOut
                                             $Action3.LogResult=$filterQuotas.LogResult
                                             $createdAction.Commit()}
                                        4 { 
                                            $reportArray=@()
                                 
                                            foreach ($reportype in $filterQuotas.ReportTypes)
                                                        {   
                                                            $reportArray += $reportype
                                                        }
                                                
                                            $createdAction = $FsrmQuotaObject.GetQuota($quotaThreshold.path)
                                            $Action4 = $createdAction.CreateThresholdAction($filterQuotas.threshold0X,4)
                                            $Action4.RunLimitInterval = $filterQuotas.RunLimitInterval
                                            $Action4.ReportTypes = $reportArray
                                            $Action4.MailTo = $filterQuotas.MailTo
                                            $createdAction.Commit()}
                             
                                    }
                            
                              }#closes %
                         }#closes foreach
                        
                    
                    
                    
                }
                elseif($quota.SourceTemplateName -ne $null -and  $quota.MatchesSourceTemplate -eq $false )
                {
                    #$createdQuotas|gm 
                    
                    $createdQuotas.ApplyTemplate($quota.SourceTemplateName)
                   
                     #This deletes the quota Thresholds of the template
                    foreach ($DeletedThresholds in $($createdQuotas.Thresholds))
                    {
                        $createdQuotas.DeleteThreshold($DeletedThresholds)
                    }
                    
                    
                     #This creates the quota Thresholds
                    foreach ($Threshold in $quota.Thresholds)
                    {
                        $createdQuotas.AddThreshold($Threshold)
                        $createdQuotas.Description =($quota.Description) 
                        $createdQuotas.QuotaFlags =($quota.QuotaFlags) 
                        $createdQuotas.QuotaLimit =($quota.QuotaLimit)
                        $createdQuotas.Commit()
                    }
                    
                    #This creates the quota Actions
                    foreach ($quotaThreshold in $quota)
                            {
                             $importQuotasThresholds |Where-Object {$quotaThreshold.Guid -eq $_.Guid } |%{
                             $filterQuotas = $_
                                    switch ($_.ActionType)
                                    {
                                        1 { 
                                    
                                            $createdAction = $FsrmQuotaObject.GetQuota($quotaThreshold.path)
                                            $Action1 = $createdAction.CreateThresholdAction($filterQuotas.threshold0X,1)
                                            $Action1.RunLimitInterval = $filterQuotas.RunLimitInterval
                                            $Action1.EventType = $filterQuotas.EventType
                                            $Action1.MessageText = $filterQuotas.MessageText
                                            $createdAction.Commit()}
                                    
                                    
                                        2 { 
                                
                                            $createdAction = $FsrmQuotaObject.GetQuota($quotaThreshold.path)
                                            $Action2 = $createdAction.CreateThresholdAction($filterQuotas.threshold0X,2)       
                                            $Action2.RunLimitInterval =$filterQuotas.RunLimitInterval
                                            $Action2.MailFrom =$filterQuotas.MailFrom
                                            $Action2.MailReplyTo =$filterQuotas.MailReplyTo
                                            $Action2.MailTo =$filterQuotas.MailTo
                                            $Action2.MailCc =$filterQuotas.MailCc
                                            $Action2.MailBcc =$filterQuotas.MailBcc
                                            $Action2.MailSubject =$filterQuotas.MailSubject
                                            $Action2.MessageText =$filterQuotas.MessageText
                                            $createdAction.Commit()}
                                    
                                    
                                        3 { 
                                             $createdAction = $FsrmQuotaObject.GetQuota($quotaThreshold.path)
                                             $Action3 = $createdAction.CreateThresholdAction($filterQuotas.threshold0X,3)
                                             $Action3.RunLimitInterval=$filterQuotas.RunLimitInterval
                                             
                                             
                                                  try
                                                    {
                                                        $Action3.ExecutablePath=$filterQuotas.ExecutablePath
                                                    }
                                                    catch
                                                    {
                                                        $output = "Unable to create the custom Quota in the path $($CreateFileScreen.path), because couldnt find the executable path $($filterQuotas.ExecutablePath) of the action"
                                                        $_ | Out-File ($DestinationPath + "\logs\Quota.log") -Append
                                                        $output | Out-File ($DestinationPath + "\logs\Quota.log") -Append
                                                    }   
                                                             
                                             
                                             $Action3.Arguments=$filterQuotas.Arguments
                                             $Action3.Account=$filterQuotas.Account
                                             $Action3.WorkingDirectory=$filterQuotas.WorkingDirectory
                                             $Action3.MonitorCommand=$filterQuotas.MonitorCommand
                                             $Action3.KillTimeOut=$filterQuotas.KillTimeOut
                                             $Action3.LogResult=$filterQuotas.LogResult
                                             $createdAction.Commit()}
                                        4 { 
                                            $reportArray=@()
                                 
                                            foreach ($reportype in $filterQuotas.ReportTypes)
                                                        {   
                                                            $reportArray += $reportype
                                                        }
                                                
                                            $createdAction = $FsrmQuotaObject.GetQuota($quotaThreshold.path)
                                            $Action4 = $createdAction.CreateThresholdAction($filterQuotas.threshold0X,4)
                                            $Action4.RunLimitInterval = $filterQuotas.RunLimitInterval
                                            $Action4.ReportTypes = $reportArray
                                            $Action4.MailTo = $filterQuotas.MailTo
                                            $createdAction.Commit()}
                             
                                    }
                            
                              }#closes %
                         }#closes foreach
                    
                                 
                    
                    
                    

                }
                else
                {

                #this creates the quotas from templates
                
                    $createdQuotas.ApplyTemplate($quota.SourceTemplateName)
                    $createdQuotas.description =($quota.description)
                 
                   
                       try
                        {
                            $createdQuotas.Commit()
                        }
                        catch
                        {
                            
                            $output = "Unable to create the Quota in the path $($createdQuotas.path)"  
                            $_ | Out-File ($DestinationPath + "\logs\Quota.log") -Append
                            $output | Out-File ($DestinationPath + "\logs\Quota.log") -Append
                            write "Unable to create the Quota in the path $($createdQuotas.path)"  
                        }   
                   
                   
                   
                }#close else









      }
      
      
  }
      $output = "`nThe importation of the Quotas was successful, please review the log folder, for more information "
      return $output    

}
Export-ModuleMember -function Import-Quotas