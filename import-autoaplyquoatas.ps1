$importedAutoapplyCuotas =Import-Clixml  -Path "C:\empty\AutoApplyQuotas.xml"
$importedAutoapplyCuotas|%{
        $FsrmQuotaObject = new-object -com FSRM.FsrmQuotaManager
        $autoAplyQuota =$FsrmQuotaObject.CreateAutoApplyQuota($_.SourceTemplateName,$_.path)
        $autoAplyQuota.Commit()
         

}