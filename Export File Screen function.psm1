
                                                
                                                
                                                
function Redo-FileScreen ($fileScreenProperties,$I)
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







function Get-FileScreenConfig ($selectedVolumenes, $DestinationPath)
{
    

   
    
    
        $fsrmScreensObject = new-object -com FSRM.FsrmFileScreenManager
      
        $FileScreenConfig  =@()
        
        
         foreach ($volumeMatch in $selectedVolumenes)
        {
            $FileScreenConfig += $fsrmScreensObject.EnumFileScreens()| where {$_.path -match $volumeMatch} 
        }






        $exportedFileScreenConfig  =@()
        $exportedFileScreenActions =@()

        foreach ($fileScreen in $FileScreenConfig)
        {
                $GUID =[guid]::NewGuid()   
                $fileScreen.EnumActions()
                    foreach ($fileScreenActions in $fileScreen)
                            {
                           $444 =$fileScreenActions.EnumActions()
                               $444 
                    foreach ($12 in $fileScreenActions)
                            {
                          $GUID
                                  $333= $fileScreen.EnumActions()
                                 write $333
                          
                            }
                          
                            }


        $exportedFileScreenConfig += Redo-FileScreen -fileScreenProperties $fileScreen -id $GUID
        }

        $exportedFileScreenActions| Export-Clixml -Path ("C:\empty" + "\FileScreensActions.xml")
        $exportedFileScreenConfig | Export-Clixml -Path ("c:\empty" + "\FileScreens.xml")
        
}

Export-ModuleMember -function "Get-FileScreenConfig"










