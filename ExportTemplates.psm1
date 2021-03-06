function Export-QuotaTemplates ($Destinationfolder)
{
    try
    {
       $fsrmExportObject = New-Object -Com FSrm.FsrmExportImport
       $fsrmExportObject.ExportQuotaTemplates($Destinationfolder + "\ExportQuotaTemplates.xml")
       $output = "`nThe exportation of the file ""ExportQuotaTemplates.xml"" was successful"
    }
    catch
    {
        $output = "`nA file called ""ExportQuotaTemplates.xml"" already exist in the specified location"
    }
   
   return $output
}

function Export-FileScreenTemplates ($Destinationfolder)
{
    try
    {
        $fsrmExportObject = New-Object -Com FSrm.FsrmExportImport
        $fsrmExportObject.ExportFileScreenTemplates($Destinationfolder + "\ExportFileScreenTemplates.xml")
        $output = "`nThe exportation of the file ""ExportFileScreenTemplates.xml"" was successful"
    }
    catch 
    {
        $_
        $output = "`nA file called ""ExportFileScreenTemplates.xml"" already exist in the specified location"
    }
   
   return $output
}


function Export-FileGroupsTemplates ($Destinationfolder)
{
    try
    {
        $fsrmExportObject = New-Object -Com FSrm.FsrmExportImport
        $fsrmExportObject.ExportFileGroups($Destinationfolder + "\ExportFileGroups.xml")
        $output = "`nThe exportation of the file ""ExportFileGroups.xml"" was successful"
    }
    catch 
    {
        $output = "`nA file called ""ExportFileGroups.xml"" already exist in the specified location"
    }
    
   return $output 
                                       
}

Export-ModuleMember -function Export-QuotaTemplates,Export-FileScreenTemplates,Export-FileGroupsTemplates