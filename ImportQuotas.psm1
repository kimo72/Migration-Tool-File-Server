
function Import-Quotas ($DestinationPath)
{


$quotas = Import-Clixml -Path ($DestinationPath +"\Quotas.xml")
$importQuotasThresholds = Import-Clixml -Path ($DestinationPath +"\QuotasThresholds.xml")
######################thiscreates de cuotas
  
  
    foreach ($quota in $quotas)
    {
        $FsrmQuotaObject = new-object -com FSRM.FsrmQuotaManager
        $filecreenss = $FsrmQuotaObject.CreateQuota($quota.Path)
        if($quota.SourceTemplateName -eq $null )
        {

            try
            {
                foreach ($Threshold in $quota.Thresholds)
                {
                $filecreenss.AddThreshold($Threshold)
                $filecreenss.Description =($quota.Description) 
                $filecreenss.QuotaFlags = ($quota.QuotaFlags) 
                $filecreenss.QuotaLimit = ($quota.QuotaLimit)
                $filecreenss.Commit()
                }

                 foreach ($quota in $quotas)
                 {$importQuotasThresholds |Where-Object {$quota.Guid -eq $_.Guid } |%{
                 $filterQuotas = $_
                        switch ($_.ActionType)
                        {
                            1 { 
                        
                                $createdAction = $FsrmQuotaObject.GetQuota($quota.path)
                                $Action1 = $createdAction.CreateThresholdAction($filterQuotas.threshold0X,1)
                                $Action1.RunLimitInterval = $filterQuotas.RunLimitInterval
                                $Action1.EventType = $filterQuotas.EventType
                                $Action1.MessageText = $filterQuotas.MessageText
                                $createdAction.Commit()}
                        
                        
                            2 { 
                    
                                $createdAction = $FsrmQuotaObject.GetQuota($quota.path)
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
                                 $createdAction = $FsrmQuotaObject.GetQuota($quota.path)
                                 $Action3 = $createdAction.CreateThresholdAction($filterQuotas.threshold0X,3)
                                 $Action3.RunLimitInterval=$filterQuotas.RunLimitInterval
                                 $Action3.ExecutablePath=$filterQuotas.ExecutablePath
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
                                    
                                $createdAction = $FsrmQuotaObject.GetQuota($quota.path)
                                $Action4 = $createdAction.CreateThresholdAction($filterQuotas.threshold0X,4)
                                $Action4.RunLimitInterval = $filterQuotas.RunLimitInterval
                                $Action4.ReportTypes = $reportArray
                                $Action4.MailTo = $filterQuotas.MailTo
                                $createdAction.Commit()}
                 
                        }
                
             }
             
             
        }


            }
            catch 
            {
                Write-Host "Unable to create the Quota in the path $($quota.path)"
            }
       

           
       
             
             
             
            
        }
        else
        {
            try
            {
                $filecreenss.ApplyTemplate($quota.SourceTemplateName)
                $filecreenss.Commit()
            }
            catch
            {
                Write-Host "Unable to create the quota from template, in the path $($quota.path)"
            }
            
        }
      
      
    }

}
