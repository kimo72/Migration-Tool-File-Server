function Get-AutoapplyQuotasConfig ($selectedVolumenes, $DestinationPath)
{
     
    $output =@()
    if((Test-Path ($DestinationPath+ '\ExportAutoapplyQuotas.xml')) -eq $true)
    {
        $output += "`nA file called ""ExportAutoapplyQuotas.xml"" already exist in the specified location"
    }
    else
    {
        $fsrmQuotaManagerObject = new-object -com FSRM.FsrmQuotaManager
     
        $AutoapplyQuotasConfig  =@()
        $AutoapplyQuotasConfignull  =@()
        
         foreach ($volumeMatch in $selectedVolumenes)
        {
            $AutoapplyQuotasConfig += $fsrmQuotaManagerObject.EnumAutoApplyQuotas()| where {$_.path -match $volumeMatch} 
        }
        
        
        foreach ($AutoapplyQuota in $AutoapplyQuotasConfig)
        {
            if ( $AutoapplyQuota.path -ne $null)
            {
                $AutoapplyQuotasConfignull += $AutoapplyQuota
            }
          
        }    
            $AutoapplyQuotasConfignull | Export-Clixml -Path ($DestinationPath + "\ExportAutoapplyQuotas.xml")
            $output += "`nThe exportation of the file ""ExportAutoapplyQuotas.xml"" was successful"                       


    }
        return $output
        
}
Export-ModuleMember -function "Get-AutoapplyQuotasConfig"
