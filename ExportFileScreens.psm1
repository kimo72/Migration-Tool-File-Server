function Redo-FileScreen ($fileScreenAction,$Id)
{

            $fileScreenObj = @{'Guid'=$GUID
                            'id'=$fileScreenAction.id
                            'Description'=$fileScreenAction.Description
                            'BlockedFileGroups'=$fileScreenAction.BlockedFileGroups
                            'FileScreenFlags'=$fileScreenAction.FileScreenFlags
                            'Path'=$fileScreenAction.Path
                            'SourceTemplateName'=$fileScreenAction.SourceTemplateName
                            'MatchesSourceTemplate'=$fileScreenAction.MatchesSourceTemplate
                            'UserSid'=$fileScreenAction.UserSid
                            'UserAccount'=$fileScreenAction.UserAccount
                            
                            }

                $fileScreen = New-Object –TypeName PSObject –Prop $fileScreenObj 
                return  $fileScreen
}


function Redo-FileScreenActions1 ($fileScreenAction, $Id)
{

     $fileScreenActions1 = @{'Guid'=$GUID
                            'id'=$fileScreenAction.id
                            'ActionType'=$fileScreenAction.ActionType
                            'RunLimitInterval'=$fileScreenAction.RunLimitInterval
                            'EventType'=$fileScreenAction.EventType
                            'MessageText'=$fileScreenAction.MessageText                       
                            }

                $fileScreen = New-Object –TypeName PSObject –Prop $fileScreenActions1 
                return  $fileScreen
    
}


function Redo-FileScreenActions2 ($fileScreenAction, $Id)
{

     $fileScreenActions2 = @{'Guid'=$GUID
                            'id'=$fileScreenAction.id
                            'ActionType'=$fileScreenAction.ActionType
                            'RunLimitInterval'=$fileScreenAction.RunLimitInterval
                            'MailFrom'=$fileScreenAction.MailFrom
                            'MailReplyTo'=$fileScreenAction.MailReplyTo
                            'MailTo'=$fileScreenAction.MailTo
                            'MailCc'=$fileScreenAction.MailCc
                            'MailBcc'=$fileScreenAction.MailBcc
                            'MailSubject'=$fileScreenAction.MailSubject
                            'MessageText'=$fileScreenAction.MailSubject
                            
                            }

                $fileScreen = New-Object –TypeName PSObject –Prop $fileScreenActions2 
                return  $fileScreen
    
}


function Redo-FileScreenActions3 ($fileScreenAction, $Id)
{

     $fileScreenActions3 = @{'Guid'=$GUID
                            'id'=$fileScreenAction.id
                            'ActionType'=$fileScreenAction.ActionType
                            'RunLimitInterval'=$fileScreenAction.RunLimitInterval
                            'ExecutablePath'=$fileScreenAction.ExecutablePath
                            'Arguments'=$fileScreenAction.Arguments
                            'Account'=$fileScreenAction.Account
                            'WorkingDirectory'=$fileScreenAction.WorkingDirectory
                            'MonitorCommand'=$fileScreenAction.MonitorCommand
                            'KillTimeOut'=$fileScreenAction.KillTimeOut
                            'LogResult'=$fileScreenAction.LogResult
                            
                            }

                $fileScreen = New-Object –TypeName PSObject –Prop $fileScreenActions3 
                return  $fileScreen
    
}


function Redo-FileScreenActions4 ($fileScreenAction, $Id)
{
    
    
     $fileScreenActions4 = @{'Guid'=$GUID
                            'id'=$fileScreenAction.id
                            'ActionType'=$fileScreenAction.ActionType
                            'RunLimitInterval'=$fileScreenAction.RunLimitInterval
                            'ReportTypes'=$fileScreenAction.ReportTypes
                            'MailTo'=$fileScreenAction.MailTo

                            
                            }

                $fileScreen = New-Object –TypeName PSObject –Prop $fileScreenActions4 
                return  $fileScreen
}







function Get-FileScreenConfig ($selectedVolumenes, $DestinationPath)
{
    

 $output =@()
     if((Test-Path ($DestinationPath+ '\FileScreensActions.xml')) -eq $true -and (Test-Path ($DestinationPath + '\FileScreens.xml')) -eq $true)
    {
        $output += "`nA file called ""FileScreensActions.xml"" already exist in the specified location"
        $output += "`nA file called ""FileScreens.xml"" already exist in the specified location"
        
    }
    
    else
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




            if ( $fileScreen.path -eq $null)
                {
                        
                }
                else
                {
                     $GUID =[guid]::NewGuid()   
                $FileScreenActions = $fileScreen.EnumActions()
               
                    
                               
                    foreach ($Actions in $FileScreenActions)
                            {
                                switch ($Actions.ActionType)
                                        {
                                            
                                            '1' {$exportedFileScreenActions += Redo-FileScreenActions1 -fileScreenAction $Actions -ID $GUID}
                                            '2' {$exportedFileScreenActions += Redo-FileScreenActions2 -fileScreenAction $Actions -ID $GUID}
                                            '3' {$exportedFileScreenActions += Redo-FileScreenActions3 -fileScreenAction $Actions -ID $GUID}
                                            '4' {$exportedFileScreenActions += Redo-FileScreenActions4 -fileScreenAction $Actions -ID $GUID}
                                           
                                        }
                            }

        $exportedFileScreenConfig +=  Redo-FileScreen -fileScreenAction $fileScreen -ID $GUID
           
        }
        
                }

               
        
      
        $exportedFileScreenConfig
        $exportedFileScreenActions| Export-Clixml -Path ( $DestinationPath + "\FileScreensActions.xml")
        $exportedFileScreenConfig | Export-Clixml -Path ( $DestinationPath + "\FileScreens.xml")
        
           $output += "`nThe exportation of the file ""FileScreensActions.xml"" was successful"
           $output += "`nThe exportation of the file ""FileScreens.xml"" was successful"
    }
        return $output
        
        
        
        
        
        
        
}

Export-ModuleMember -function "Get-FileScreenConfig"