
function Import-FileScreen ($DestinationPath)
{

$importedFileScreen = Import-Clixml -Path ($DestinationPath+"\FileScreens.xml")#|%{$_.guid}
$importedFileScreenAction = Import-Clixml -Path ($DestinationPath+"\FileScreensActions.xml")#|%{$_.guid}
 
$FsrmFileScreenManagerObject = new-object -com FSRM.FsrmFileScreenManager
$importedFileScreen|%{
#this if validates if the template is empty
if($_.SourceTemplateName){
$CreateFileScreen = $FsrmFileScreenManagerObject.CreateFileScreen($_.path)
$CreateFileScreen.ApplyTemplate($_.SourceTemplateName)
$CreateFileScreen.Description = $_.Description
$CreateFileScreen.FileScreenFlags = $_.FileScreenFlags
$CreateFileScreen.Commit()
}
else
{
$CreateFileScreen = $FsrmFileScreenManagerObject.CreateFileScreen($_.path)
$CreateFileScreen.Description = $_.Description
$CreateFileScreen.FileScreenFlags = $_.FileScreenFlags
$uniqueBlockedFileGroups = $_.BlockedFileGroups|select -Unique
  
  foreach ($BlockedFileGroups in $uniqueBlockedFileGroups){
                    $group = $CreateFileScreen.BlockedFileGroups
                    $group.add($BlockedFileGroups)
                    $CreateFileScreen.BlockedFileGroups= $group
                    }
#this creates the actions
$FileScreen =$_


    
      
      $FileScreenAction = $importedFileScreenAction |Where-Object {$FileScreen.Guid -eq $_.Guid }
        
 foreach ($item in $FileScreenAction)
{

                switch ($item.ActionType)
                {

                    '1' {
                         $Action1 = $CreateFileScreen.CreateAction(1)
                         $Action1.MessageText = $item.MessageText
                         $Action1.EventType = $item.EventType
                         $Action1.RunLimitInterval = $item.RunLimitInterval}
                    
                    '2' {
                    #$createdAction = $FsrmFileScreenManagerObject.GetQuota($_.path)
                         $Action2 = $CreateFileScreen.CreateAction(2)
                         $Action2.RunLimitInterval = $item.RunLimitInterval
                         $Action2.MailFrom = $item.MailFrom
                         $Action2.MailReplyTo = $item.MailReplyTo
                         $Action2.MailTo = $item.MailTo
                         $Action2.MailCc = $item.MailCc
                         $Action2.MailBcc = $item.MailBcc
                         $Action2.MailSubject = $item.MailSubject
                         $Action2.MessageText = $item.MessageText}
                            #>
                    '3' {
                   # $item 
                    $Action3 = $CreateFileScreen.CreateAction(3)
                         $Action3.ExecutablePath = $item.ExecutablePath
                         $Action3.Arguments = $item.Arguments
                         $Action3.RunLimitInterval = $item.RunLimitInterval
                         $Action3.WorkingDirectory = $item.WorkingDirectory
                         $Action3.LogResult = $item.LogResult
                         $Action3.MonitorCommand = $item.MonitorCommand
                         $Action3.KillTimeOut = $item.KillTimeOut
                         $Action3.Account = $item.Account
                         }
                         #>
                    '4' {
                    
                         $reportArray=@()
     
                        foreach ($reportype in $item.ReportTypes)
                                    {   
                                        $reportArray += $reportype
                                    }
                         $Action4 = $CreateFileScreen.CreateAction(4)
                         $Action4.ReportTypes = $reportArray
                         
                         $Action4.RunLimitInterval = $item.RunLimitInterval
                         $Action4.MailTo = $item.MailTo}

                }



}

}
$CreateFileScreen.Commit()




}
}