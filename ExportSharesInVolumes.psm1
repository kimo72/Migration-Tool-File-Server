
#$shares = Get-WMIObject -class Win32_share | Where-Object {$_.Path -match "C:" -and $_.Name -notmatch '`$'}


#$shareFilter = "SELECT * FROM Win32_Share WHERE Name != 'ADMIN$' AND Name != 'IPC$' AND Description != 'Default share'"

function Export-sharesToFile {

    param 
    ( 
        [string]$FileRepositoryPath,
        [Array]$volumens
    )

    $FileRepositoryPath += '\sharePermission.csv'
    $FileRepositoryPath
    $sharePermissions = 'DomainUser;Action;Permission;share;Path'
    $sharePermissions | out-file $FileRepositoryPath -Append

    foreach($volumen in $volumens){
    $sharedVolume
    $sharedVolume = $volumen
    write-host $shareFilter = "SELECT * FROM Win32_Share WHERE Name != 'ADMIN$' AND Name != 'IPC$' AND Description != 'Default share' AND Path LIKE '$sharedVolume%'"
    $shareFilter
    $sharesInVolume = Get-WmiObject -query $shareFilter
        foreach($listedShare in $sharesInVolume){

            $ShareName = $listedShare.Name

            $objShareSec = Get-WMIObject -Class Win32_LogicalShareSecuritySetting -Filter "name='$ShareName'" 
    
            $SD = $objShareSec.GetSecurityDescriptor().Descriptor
            $ShareName
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
                    $sharePermissions | out-file $FileRepositoryPath -Append
            }
            Remove-Variable -Name ACL
        #>
        
        if((Test-Path ($FileRepositoryPath += '\sharePermission.csv') -eq $true )
        {
            $output = "The exportation of the file ""sharePermission.csv"" was successful"
        }
        else
        {
            $output = "A file called ""sharePermission.csv"" already exist in the specified location"
        }
        return $output
    }
}