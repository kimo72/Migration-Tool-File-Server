
function Import-AutoapplyQuotas ($DestinationPath)
{

        $importedAutoapplyQuotas =Import-Clixml  -Path ($DestinationPath +"c:\empty" +"\ExportAutoapplyQuotas.xml")
        foreach ($AutoapplyQuotas in $importedAutoapplyQuotas)
        {
        $AutoapplyQuotas
                try
                {
                    $FsrmQuotaObject = new-object -com FSRM.FsrmQuotaManager
                    $autoAplyQuota =$FsrmQuotaObject.CreateAutoApplyQuota($AutoapplyQuotas.SourceTemplateName,$AutoapplyQuotas.path)
                    $autoAplyQuota.Commit()
                    
                }
                catch 
                {
                    $output = "Unable to create the AutoApplyQuotas in the path $($AutoapplyQuotas.path)"
                }
        }


         

}


Export-ModuleMember -function "Import-AutoapplyQuotas"