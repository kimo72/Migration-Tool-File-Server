
function Redo-QuotActionType1 ($ThresholdAction)
{
        $QuotActionType1 = @{'Guid'=$GUID
                            'id'=$itemaction.id
                            'threshold0X'=$itemthreshold
                            'ActionType'=$itemaction.ActionType
                            'RunLimitInterval'=$itemaction.RunLimitInterval
                            'EventType'=$itemaction.EventType
                            'MessageText'=$itemaction.MessageText
                            }
                            
            $actionType = New-Object –TypeName PSObject –Prop $QuotActionType1
            return $actionType 
}

function Redo-QuotActionType2 ($ThresholdAction)
{
    
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
            $actionType = New-Object –TypeName PSObject –Prop $QuotActionType2
            return $actionType 
    
}

function Redo-QuotActionType3 ($ThresholdAction)
{
    
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
                           
            $actionType = New-Object –TypeName PSObject –Prop $QuotActionType3
            return $actionType 
                
}

function Redo-QuotActionType4 ($ThresholdAction)
{

        $QuotActionType4 = @{'Guid'=$GUID
                            'id'=$itemaction.id
                            'threshold0X'=$itemthreshold
                            'ActionType'=$itemaction.ActionType
                            'RunLimitInterval'=$itemaction.RunLimitInterval
                            'ReportTypes'=$itemaction.ReportTypes
                            'MailTo'=$itemaction.MailTo
                           } 
            $actionType = New-Object –TypeName PSObject –Prop $QuotActionType4
            return $actionType 
}

function Redo-Quota ($QuotaConfig)
{

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

                $quota = New-Object –TypeName PSObject –Prop $Quotaproperties 
                return  $quota
}



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
                

                            
                                     if ($itemaction.ActionType -EQ 1)
                                                {
                                                    $exportedQuotasThresholds += Redo-QuotActionType1 -ThresholdAction $itemaction
                                                }
                                     if ($itemaction.ActionType -EQ 2)
                                                {
                                                    $exportedQuotasThresholds += Redo-QuotActionType2 -ThresholdAction $itemaction
                                                }
                                     if ($itemaction.ActionType -EQ 3)
                                                {
                                                    $exportedQuotasThresholds += Redo-QuotActionType3 -ThresholdAction $itemaction
                                                }
                                     if ($itemaction.ActionType -EQ 4)
                                                {
                                                    $exportedQuotasThresholds += Redo-QuotActionType4 -ThresholdAction $itemaction
                                                }
                            
                                                               
        }
      
      
      
 
        
        
    }
   
  $exportedQuotas += Redo-Quota -QuotaConfig $itemquota
}
$exportedQuotas| Export-Clixml -Path ("c:" + "\Quotas.xml")
$exportedQuotasThresholds | Export-Clixml -Path ("c:" + "\QuotasThresholds.xml")















