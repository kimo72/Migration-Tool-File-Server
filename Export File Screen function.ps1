
                                                
                                                
                                                
function Redo-FileScreen ($fileScreenProperties)
{

            $fileScreenObj = @{'Guid'=$GUID
                            'id'=$fileScreenProperties.id
                            'Description'=$fileScreenProperties.Description
                            'BlockedFileGroups'=$fileScreenProperties.BlockedFileGroups
                            'FileScreenFlags'=$fileScreenProperties.FileScreenFlags
                            'Path'=$fileScreenProperties.Path
                            'SourceTemplateName'=$fileScreenProperties.SourceTemplateName
                            'MatchesSourceTemplate'=$fileScreenProperties.MatchesSourceTemplate
                            'UserSid'=$fileScreenProperties.UserSid
                            'UserAccount'=$fileScreenProperties.UserAccount
                            
                            }

                $fileScreen = New-Object –TypeName PSObject –Prop $fileScreenObj 
                return  $fileScreen
}


function Redo-FileScreenActions1 ($fileScreenAction, $param2)
{

     $fileScreenActions1 = @{'Guid'=$GUID
                            'id'=$fileScreenActions.id
                            'ActionType'=$fileScreenActions.ActionType
                            'RunLimitInterval'=$fileScreenActions.RunLimitInterval
                            'EventType'=$fileScreenActions.EventType
                            'MessageText'=$fileScreenActions.MessageText                       
                            }

                $fileScreen = New-Object –TypeName PSObject –Prop $fileScreenActions1 
                return  $fileScreen
    
}


function Redo-FileScreenActions2 ($fileScreenAction, $param2)
{

     $fileScreenActions2 = @{'Guid'=$GUID
                            'id'=$fileScreenActions.id
                            'ActionType'=$fileScreenActions.ActionType
                            'RunLimitInterval'=$fileScreenActions.RunLimitInterval
                            'MailFrom'=$fileScreenActions.MailFrom
                            'MailReplyTo'=$fileScreenActions.MailReplyTo
                            'MailTo'=$fileScreenActions.MailTo
                            'MailCc'=$fileScreenActions.MailCc
                            'MailBcc'=$fileScreenActions.MailBcc
                            'MailSubject'=$fileScreenActions.MailSubject
                            'MessageText'=$fileScreenActions.MailSubject
                            
                            }

                $fileScreen = New-Object –TypeName PSObject –Prop $fileScreenActions2 
                return  $fileScreen
    
}


function Redo-FileScreenActions3 ($fileScreenAction, $param2)
{

     $fileScreenActions3 = @{'Guid'=$GUID
                            'id'=$fileScreenActions.id
                            'ActionType'=$fileScreenActions.ActionType
                            'RunLimitInterval'=$fileScreenActions.RunLimitInterval
                            'ExecutablePath'=$fileScreenActions.ExecutablePath
                            'Arguments'=$fileScreenActions.Arguments
                            'Account'=$fileScreenActions.Account
                            'WorkingDirectory'=$fileScreenActions.WorkingDirectory
                            'MonitorCommand'=$fileScreenActions.MonitorCommand
                            'KillTimeOut'=$fileScreenActions.KillTimeOut
                            'LogResult'=$fileScreenActions.LogResult
                            
                            }

                $fileScreen = New-Object –TypeName PSObject –Prop $fileScreenActions3 
                return  $fileScreen
    
}

function Redo-FileScreenActions4 ($fileScreenAction, $param2)
{
    
    
     $fileScreenActions4 = @{'Guid'=$GUID
                            'id'=$fileScreenActions.id
                            'ActionType'=$fileScreenActions.ActionType
                            'RunLimitInterval'=$fileScreenActions.RunLimitInterval
                            'ReportTypes'=$fileScreenActions.ReportTypes
                            'MailTo'=$fileScreenActions.MailTo

                            
                            }

                $fileScreen = New-Object –TypeName PSObject –Prop $fileScreenActions4 
                return  $fileScreen
}






$fsrmScreensObject = new-object -com FSRM.FsrmFileScreenManager
$fileScreenProperties = $fsrmScreensObject.EnumFileScreens()

$exportedFileScreenConfig  =@()
$exportedFileScreenActions =@()

foreach ($fileScreen in $fileScreenProperties)
{
        $GUID =[guid]::NewGuid()   
        
            foreach ($fileScreenActions in $fileScreen)
                    {
                  
                            $co2 =$fileScreenActions.EnumActions()
                            #this foreach create an array with the file Screen Action
                            foreach ($fileScreenAction in $co2)
                                    {
                                       
                                       
                                       
                                        if ($fileScreenAction.ActionType -EQ 1)
                                                {
                                                write "1s"
                                                    $exportedFileScreenActions += Redo-QuotActionType1 -ThresholdAction $fileScreenAction
                                                }
                                     if ($fileScreenAction.ActionType -EQ 2)
                                                {
                                                write "2s"
                                                    $exportedFileScreenActions += Redo-QuotActionType2 -ThresholdAction $fileScreenAction
                                                }
                                     if ($fileScreenAction.ActionType -EQ 3)
                                                {
                                                write "3s"
                                                    $exportedFileScreenActions += Redo-QuotActionType3 -ThresholdAction $fileScreenAction
                                                }
                                     if ($fileScreenAction.ActionType -EQ 4)
                                                {
                                                write "4s"
                                                    $exportedFileScreenActions += Redo-QuotActionType4 -ThresholdAction $fileScreenAction
                                                }
                                       
 
                                    }#this foreach create an array with the file Screen Action
                                    
                                  
                       
                  
                    }


$exportedFileScreenConfig += Redo-FileScreen -fileScreenProperties $fileScreen 
}

$exportedFileScreenActions| Export-Clixml -Path ("c:" + "\FileScreensActions.xml")
$exportedFileScreenConfig | Export-Clixml -Path ("c:" + "\FileScreens.xml")
