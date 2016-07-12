
#$shares = Get-WMIObject -class Win32_share | Where-Object {$_.Path -match "C:" -and $_.Name -notmatch '`$'}


#$shareFilter = "SELECT * FROM Win32_Share WHERE Name != 'ADMIN$' AND Name != 'IPC$' AND Description != 'Default share'"

function Export-sharesToFile {

    param 
    ( 
        [string]$FileRepositoryPath,
        [Array]$volumens
    )
           
           $volumens2 =@()
           foreach($vol in $volumens){
           $vol.replace(":\",":")
           $volumens2 +=  $vol
           }
              $volumens2 
                                       
        $sharePermissions = 'DomainUser;Action;Permission;share;Path'
        $sharePermissions | out-file ($FileRepositoryPath+ '\sharePermission.csv') -Append
        
        foreach($volumen in $volumens){
            $sharedVolume
            $sharedVolume = $volumen
            $nonadministrativeVolume = "\\DAVIVIENDAFS\" + $sharedVolume.replace(":","$")
            $nonadministrativeVolumeLetter = $sharedVolume.replace(":",":\")
            $shareFilter = "SELECT * FROM Win32_Share WHERE Name != 'ADMIN$' AND Name != 'IPC$' AND Description != 'Default share' AND Path LIKE '$sharedVolume%'"

            $sharesInVolume = Get-WmiObject -query $shareFilter
            $objShareSec = Get-WMIObject -Class Win32_LogicalShareSecuritySetting -ComputerName localhost

            foreach($listedShare in $sharesInVolume){

               
               $ShareName = $listedShare.Name
               $ShareName 
               
               if ($listedShare.Path -ne $nonadministrativeVolumeLetter){
                    $filteredShare = $objShareSec | where-object {$_.Name -eq $ShareName}
               
                           $SD = $filteredShare.GetSecurityDescriptor().Descriptor 
                           
                           $SD.DACL.Count
                            
                           foreach($ace in $SD.DACL)
                           {
                             $UserName = $ace.Trustee.Name  
                             If ($ace.Trustee.Domain -ne $Null) {$UserName = "$($ace.Trustee.Domain)\$UserName"}
                             If ($ace.Trustee.Name -eq $Null) {$UserName = $ace.Trustee.SIDString }
                         
                             [Array]$ACL += New-Object Security.AccessControl.FileSystemAccessRule($UserName, $ace.AccessMask, $ace.AceType)
                           }            

                           foreach($item in $ACL){

                               $sharePermissions = $item.IdentityReference.ToString() + ';' + $item.AccessControlType.ToString() + ';' + $item.FileSystemRights.ToString() + ';' + $ShareName + ';' + $listedShare.Path
                               $sharePermissions | out-file ($FileRepositoryPath+ '\sharePermission.csv')-Append
                           }
                           Remove-Variable -Name ACL
               }
            }
        }
   #>
}