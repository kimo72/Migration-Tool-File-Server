

$QuotaManager = new-object -com FSRM.FsrmQuotaManager
$quouta = $QuotaManager.EnumQuotas()


$exportedQuotasThresholds =@()
$exportedQuotas =@()
foreach($itemquota in $quouta)
{
    $GUID =[guid]::NewGuid()
    $quotatemplates = $itemquota.Thresholds
    foreach($itemthreshold in $quotatemplates)
    {
       
        $actions = $itemquota.EnumThresholdActions([int]$itemthreshold)
        foreach($itemaction in $actions)
        {
                    #write "2#DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD" 
                    #$itemquota.Path
                    #$itemthreshold
                
                   $itemaction
                    $QuotActionType1 = @{'Guid'=$GUID
                            'id'=$itemaction.id
                            'threshold0X'=$itemthreshold
                            'ActionType'=$itemaction.ActionType
                            'RunLimitInterval'=$itemaction.RunLimitInterval
                            'EventType'=$itemaction.EventType
                            'MessageText'=$itemaction.MessageText
                            }
                            
                            
                            
                   $QuotActionType2 = @{'Guid'=$GUID
                            'id'=$itemaction.id
                            'threshold0X'=$itemthreshold
                            'ActionType'=$itemaction.ActionType
                            'RunLimitInterval'=$itemaction.RunLimitInterval
                            'MailFrom'=$itemaction.MailFrom
                            'MailReplyTo'=$itemaction.MailReplyTo
                            'MailTo'=$itemaction.MailTo
                            'MailCc'=$itemaction.MailCc
                            'MailBcc'=$itemaction.MailBcc
                            'MailSubject'=$itemaction.MailSubject
                            'MessageText'=$itemaction.MessageText
                            }   
                            
                                              
                   $QuotActionType3 = @{'Guid'=$GUID
                            'id'=$itemaction.id
                            'threshold0X'=$itemthreshold
                            'ActionType'=$itemaction.ActionType
                            'RunLimitInterval'=$itemaction.RunLimitInterval
                            'ExecutablePath'=$itemaction.ExecutablePath
                            'Arguments'=$itemaction.Arguments
                            'Account'=$itemaction.Account
                            'WorkingDirectory'=$itemaction.WorkingDirectory
                            'MonitorCommand'=$itemaction.MonitorCommand
                            'KillTimeOut'=$itemaction.KillTimeOut
                            'LogResult'=$itemaction.LogResult
                            }       
                            
                   $QuotActionType4 = @{'Guid'=$GUID
                            'id'=$itemaction.id
                            'threshold0X'=$itemthreshold
                            'ActionType'=$itemaction.ActionType
                            'RunLimitInterval'=$itemaction.RunLimitInterval
                            'ReportTypes'=$itemaction.ReportTypes
                            'MailTo'=$itemaction.MailTo
                           } 
                            
                         
                            
                            
                            
                            
                                     if ($itemaction.ActionType -EQ 1)
                                                {
                                                    $exportedQuotasThresholds += New-Object –TypeName PSObject –Prop $QuotActionType1
                                                }
                                     if ($itemaction.ActionType -EQ 2)
                                                {
                                                    $exportedQuotasThresholds += New-Object –TypeName PSObject –Prop $QuotActionType2
                                                }
                                     if ($itemaction.ActionType -EQ 3)
                                                {
                                                    $exportedQuotasThresholds += New-Object –TypeName PSObject –Prop $QuotActionType3
                                                }
                                     if ($itemaction.ActionType -EQ 4)
                                                {
                                                    $exportedQuotasThresholds += New-Object –TypeName PSObject –Prop $QuotActionType4
                                                }
                            
                                                               
        }
      
      
      
      $Quotaproperties = @{'Guid'=$GUID
                'id'=$itemquota.id
                'Description'=$itemquota.Description
                'QuotaLimit'=$itemquota.QuotaLimit
                'QuotaFlags'=$itemquota.QuotaFlags
                'Thresholds'=$itemquota.Thresholds
                'Path'=$itemquota.Path
                'UserSid'=$itemquota.UserSid
                'UserAccount'=$itemquota.UserAccount
                'SourceTemplateName'=$itemquota.SourceTemplateName
                'MatchesSourceTemplate'=$itemquota.MatchesSourceTemplate
                'QuotaUsed'=$itemquota.QuotaUsed
                'QuotaPeakUsage'=$itemquota.QuotaPeakUsage
                'QuotaPeakUsageTime'=$itemquota.QuotaPeakUsageTime
                
                }


      
        
        
    }
    
  $exportedQuotas += New-Object –TypeName PSObject –Prop $Quotaproperties 
}
$exportedQuotas| Export-Clixml -Path ("c:" + "\Quotas.xml")
$exportedQuotasThresholds | Export-Clixml -Path ("c:" + "\QuotasThresholds.xml")















