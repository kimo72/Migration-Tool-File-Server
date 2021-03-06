
function Import-AutoapplyQuotas ($DestinationPath)
{

        
       try
        {
            $importedAutoapplyQuotas =Import-Clixml  -Path ($DestinationPath +"\ExportAutoapplyQuotas.xml")
        }
        catch 
        {
            $output = "`nThe file ""ExportAutoapplyQuotas.xml"" couldnt be found, The Autoapply Quotas templates will not be imported."
            return $output
        }
        
        
        foreach ($AutoapplyQuotas in $importedAutoapplyQuotas)
        {
       
                try
                {
                    $FsrmQuotaObject = new-object -com FSRM.FsrmQuotaManager
                    $autoAplyQuota =$FsrmQuotaObject.CreateAutoApplyQuota($AutoapplyQuotas.SourceTemplateName,$AutoapplyQuotas.path)
                    $autoAplyQuota.description = ($AutoapplyQuotas.description)
                    #$AutoapplyQuot |gm
                    $autoAplyQuota.Commit()
                    
                }
                catch 
                {
                    $output = "Unable to create the AutoApplyQuotas in the path $($AutoapplyQuotas.path)"
                    $_ | Out-File ($DestinationPath + "\logs\AutoapplyQuotas.log") -Append
                    $output | Out-File ($DestinationPath + "\logs\AutoapplyQuotas.log") -Append
                    
                }
        }

          $output = "`nThe importation of the AutoapplyQuotas was successful, please review the log folder, for more information "
          return $output 

}


Export-ModuleMember -function "Import-AutoapplyQuotas"