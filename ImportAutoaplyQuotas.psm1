
function Import-AutoapplyQuotas ($DestinationPath)
{

        
       try
        {
            $importedAutoapplyQuotas =Import-Clixml  -Path ($DestinationPath +"\ExportAutoapplyQuotas.xml")
        }
        catch 
        {
            $output = "`nThe file ""ExportAutoapplyQuotas.xml"" couldnt be found, The Autoapply Quotas templates will not be imported."
        }
        
        
        foreach ($AutoapplyQuotas in $importedAutoapplyQuotas)
        {
       
                try
                {
                    $FsrmQuotaObject = new-object -com FSRM.FsrmQuotaManager
                    $autoAplyQuota =$FsrmQuotaObject.CreateAutoApplyQuota($AutoapplyQuotas.SourceTemplateName,$AutoapplyQuotas.path)
                    $autoAplyQuota = ($AutoapplyQuotas.description)
                    $AutoapplyQuot |gm
                    $autoAplyQuota.Commit()
                    
                }
                catch 
                {
                    $output = "Unable to create the AutoApplyQuotas in the path $($AutoapplyQuotas.path)"
                    $_ | Out-File ($DestinationPath + "\logs\AutoapplyQuotas.log") -Append
                    $output | Out-File ($DestinationPath + "\logs\AutoapplyQuotas.log") -Append
                    
                }
        }


          return $output 

}


Export-ModuleMember -function "Import-AutoapplyQuotas"