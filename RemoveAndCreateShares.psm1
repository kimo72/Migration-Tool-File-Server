function Import-ClusterServershares {

    param 
    ( 
        [string]$FileRepositoryPath
    )
        #$FileRepositoryPath = 'C:\Users\Administrator.WINTER\Desktop\sharePermission.csv' 
    $FileRepositoryPath += '\sharePermission.csv'
    $allSharesExported = Import-Csv $FileRepositoryPath -Delimiter ';' #| where {$_.share -contains 'Files'}

    $serversTotals = $allSharesExported.share

    
    $allSharesExportedUniqueValues = $serversTotals | Select-Object -Unique
    
        # Parte que elimina todos los recursos existentes
        
        <#
        $queryDelete = "SELECT * FROM Win32_Share WHERE Name != 'ADMIN$' AND Name != 'IPC$' AND Description != 'Default share'"
        $sharesFUncionalitydeleteShares = Get-WmiObject -Query $queryDelete


        foreach($Sharetodelete in $sharesFUncionalitydeleteShares){
           $Sharetodelete.delete()
        }
        #>

    
    foreach ($uniqueShareValues in $allSharesExportedUniqueValues){
        $i++

        write-host "Escriba esto: "$uniqueShareValues.ToString() + $i
       
        $loadSharePermissions = Import-Csv $FileRepositoryPath -Delimiter ';' | where {$_.share -contains $uniqueShareValues }

        foreach($sharePath in $loadSharePermissions){
            $sharePathFounded = $sharePath.Path
            $shareNameToSet = $sharePath.share
            
        }
        
    
        #$loadSharePermissions = Import-Csv "C:\Users\Administrator.WINTER\Desktop\sharePermission.csv" -Delimiter ';' | where {$_.share -contains 'Files'}

        $fullcontrol = 2032127
        $change = 1245631
        $read = 1179785


        

        #AccessMasks:
        #2032127 = Full Control
        #1245631 = Change
        #1179817 = Read
        $sd = ([WMIClass] "Win32_SecurityDescriptor").CreateInstance()
        #Share with Domain Admins
        foreach($Acentry in $loadSharePermissions){

            $userentry = $Acentry.DomainUser.ToString()
            $AcentrySpliting = $userentry.Split('`\')
            write-host $FinalPermission - $userentry
            $FinalPermission = ""

            if ($Acentry.Permission -match 'read'){
                $FinalPermission = 1179817
            }elseif ($Acentry.Permission -match 'Modify'){
                $FinalPermission = 1245631
            }elseif($Acentry.Permission -match 'FullControl'){
                $FinalPermission = 2032127
            }
            
            if ($AcentrySpliting.count -gt 1){
                $ACE = ([WMIClass] "Win32_ACE").CreateInstance()
                $Trustee = ([WMIClass] "Win32_Trustee").CreateInstance()
                $Trustee.Name = $AcentrySpliting[1]
                $Trustee.Domain = $Null
                ##$Trustee.SID = ([wmi]"win32_userAccount.Domain='york.edu',Name='$name'").sid   
                $ace.AccessMask = $FinalPermission
                $ace.AceFlags = 3
                $ace.AceType = 0
                $ACE.Trustee = $Trustee 
                $sd.DACL += $ACE.psObject.baseobject
            }else{
                $ACE = ([WMIClass] "Win32_ACE").CreateInstance()
                $Trustee = ([WMIClass] "Win32_Trustee").CreateInstance()
                $Trustee.Name = $AcentrySpliting[0]
                $Trustee.Domain = $Null
                ##$Trustee.SID = ([wmi]"win32_userAccount.Domain='york.edu',Name='$name'").sid   
                $ace.AccessMask = $FinalPermission
                $ace.AceFlags = 3
                $ace.AceType = 0
                $ACE.Trustee = $Trustee 
                $sd.DACL += $ACE.psObject.baseobject             
            }
            Remove-Variable -Name ace
            Remove-Variable -Name Trustee
            Remove-Variable -Name AcentrySpliting
        }



        $FolderPath = $sharePathFounded
        $ShareName = $shareNameToSet
        $Type = 0
        write-host 'Parameters: ' $FolderPath '.' $ShareName '.' $Type
        $objWMI = [wmiClass] 'Win32_share'
        $objWMI.create($FolderPath, $ShareName, 0,100,"","",$sd)
        Remove-Variable -Name SD

        }
}

Export-ModuleMember -function Import-ClusterServershares