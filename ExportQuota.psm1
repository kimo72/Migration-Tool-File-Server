
#function used in the creation of the quotas
function Redo-QuotActionType1 ($ThresholdAction,$Id,$Threshold)
{
        $QuotActionType1 = @{'Guid'=$GUID
                            'id'=$ThresholdAction.id
                            'threshold0X'=$Threshold
                            'ActionType'=$ThresholdAction.ActionType
                            'RunLimitInterval'=$ThresholdAction.RunLimitInterval
                            'EventType'=$ThresholdAction.EventType
                            'MessageText'=$ThresholdAction.MessageText
                            }
                            
            $actionType = New-Object –TypeName PSObject –Prop $QuotActionType1
            return $actionType 
}
#function used in the creation of the quotas
function Redo-QuotActionType2 ($ThresholdAction,$Id,$Threshold)
{
    
        $QuotActionType2 = @{'Guid'=$GUID
                            'id'=$ThresholdAction.id
                            'threshold0X'=$Threshold
                            'ActionType'=$ThresholdAction.ActionType
                            'RunLimitInterval'=$ThresholdAction.RunLimitInterval
                            'MailFrom'=$ThresholdAction.MailFrom
                            'MailReplyTo'=$ThresholdAction.MailReplyTo
                            'MailTo'=$ThresholdAction.MailTo
                            'MailCc'=$ThresholdAction.MailCc
                            'MailBcc'=$ThresholdAction.MailBcc
                            'MailSubject'=$ThresholdAction.MailSubject
                            'MessageText'=$ThresholdAction.MessageText
                            }   
            $actionType = New-Object –TypeName PSObject –Prop $QuotActionType2
            return $actionType 
    
}
#function used in the creation of the quotas
function Redo-QuotActionType3 ($ThresholdAction,$Id,$Threshold)
{
    
        $QuotActionType3 = @{'Guid'=$GUID
                            'id'=$ThresholdAction.id
                            'threshold0X'=$Threshold
                            'ActionType'=$ThresholdAction.ActionType
                            'RunLimitInterval'=$ThresholdAction.RunLimitInterval
                            'ExecutablePath'=$ThresholdAction.ExecutablePath
                            'Arguments'=$ThresholdAction.Arguments
                            'Account'=$ThresholdAction.Account
                            'WorkingDirectory'=$ThresholdAction.WorkingDirectory
                            'MonitorCommand'=$ThresholdAction.MonitorCommand
                            'KillTimeOut'=$ThresholdAction.KillTimeOut
                            'LogResult'=$ThresholdAction.LogResult
                            }  
                           
            $actionType = New-Object –TypeName PSObject –Prop $QuotActionType3
            return $actionType 
                
}
#function used in the creation of the quotas
function Redo-QuotActionType4 ($ThresholdAction,$Id,$Threshold)
{

        $QuotActionType4 = @{'Guid'=$GUID
                            'id'=$ThresholdAction.id
                            'threshold0X'=$Threshold
                            'ActionType'=$ThresholdAction.ActionType
                            'RunLimitInterval'=$ThresholdAction.RunLimitInterval
                            'ReportTypes'=$ThresholdAction.ReportTypes
                            'MailTo'=$ThresholdAction.MailTo
                           } 
            $actionType = New-Object –TypeName PSObject –Prop $QuotActionType4
            return $actionType 
}
#function used in the creation of the quotas
function Redo-Quota ($QuotaConfig,$Id)
{

            $Quotaproperties = @{'Guid'=$GUID
                            'id'=$Id
                            'Description'=$QuotaConfig.Description
                            'QuotaLimit'=$QuotaConfig.QuotaLimit
                            'QuotaFlags'=$QuotaConfig.QuotaFlags
                            'Thresholds'=$QuotaConfig.Thresholds
                            'Path'=$QuotaConfig.Path
                            'UserSid'=$QuotaConfig.UserSid
                            'UserAccount'=$QuotaConfig.UserAccount
                            'SourceTemplateName'=$QuotaConfig.SourceTemplateName
                            'MatchesSourceTemplate'=$QuotaConfig.MatchesSourceTemplate
                            'QuotaUsed'=$QuotaConfig.QuotaUsed
                            'QuotaPeakUsage'=$QuotaConfig.QuotaPeakUsage
                            'QuotaPeakUsageTime'=$QuotaConfig.QuotaPeakUsageTime
                            }

                $quota = New-Object –TypeName PSObject –Prop $Quotaproperties 
                return  $quota
}





#function used to create the selected fuctions creation of the quotas
function Get-QuotaConfig ($selectedVolumenes, $DestinationPath)
{

    $output =@()
     if((Test-Path ($DestinationPath+ '\Quotas.xml')) -eq $true -and (Test-Path ($DestinationPath + '\QuotasThresholds.xml')) -eq $true)
    {
        $output += "`nA file called ""Quotas.xml"" already exist in the specified location"
        $output += "`nA file called ""QuotasThresholds.xml"" already exist in the specified location"
        
    }
    else
    {

            $DestinationPath2 = $DestinationPath
            $selectedVolumenes2 = $selectedVolumenes

            $fsrmQuotamanagerObj = new-object -com FSRM.FsrmQuotaManager
            $quotasArray = @()
            $exportedQuotasThresholds = @()
            $exportedQuotas  = @()


                foreach ($volumeMatch in $selectedVolumenes2)
                {
                    $quotasArray += $fsrmQuotamanagerObj.EnumQuotas()| where {$_.path -match $volumeMatch} 
                }
             
            
            



            foreach ($quotas in $quotasArray)
                {
                      
                    if ( $quotas.path -eq $null)
                    {
                        
                    }
                    else
                    {
                        
                        $GUID =[guid]::NewGuid()
                
                        foreach ($Thresholds in ($quotas.Thresholds))
                        { $actions = $quotas.EnumThresholdActions($Thresholds)
                      
                                foreach ($item in $actions)
                                    {
                                    
                                         if ($($item |select -ExpandProperty ActionType) -EQ 1)
                                                    {
                                                        $exportedQuotasThresholds += Redo-QuotActionType1 -ThresholdAction $item -id $GUID -Threshold $Thresholds
                                                    }
                                         if (($item |select -ExpandProperty ActionType) -EQ 2)
                                                    {
                                                       $exportedQuotasThresholds += Redo-QuotActionType2 -ThresholdAction $item -id $GUID -Threshold $Thresholds
                                                    }
                                         if (($item |select -ExpandProperty ActionType) -EQ 3)
                                                    {
                                                        $exportedQuotasThresholds += Redo-QuotActionType3 -ThresholdAction $item -id $GUID -Threshold $Thresholds
                                                    }
                                         if (($item |select -ExpandProperty ActionType) -EQ 4)
                                                    {
                                                        $exportedQuotasThresholds += Redo-QuotActionType4 -ThresholdAction $item -id $GUID -Threshold $Thresholds
                                                    }
                                    }
                                                    
                          
                    }
                     $exportedQuotas += Redo-Quota -QuotaConfig $quotas -id $GUID   



                    }                    
                    
                          
                                   
                }

            #export the created objects
            $exportedQuotas| Export-Clixml -Path ($DestinationPath + "\Quotas.xml")
            $exportedQuotasThresholds | Export-Clixml -Path ($DestinationPath + "\QuotasThresholds.xml")
            $output += "`nThe exportation of the file ""Quotas.xml"" was successful"
            $output += "`nThe exportation of the file ""QuotasThresholds.xml"" was successful"
    }
    
  return $output  
}



Export-ModuleMember -function "Get-QuotaConfig"