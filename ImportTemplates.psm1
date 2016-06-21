function Import-QuotaTemplates ($DestinationPath)
{
    try
    {
        $FsrmQuotaTemplateManagerObject = new-object -com FSRM.FsrmExportImport
        $FsrmQuotaTemplateManagerObject.ImportQuotaTemplates($DestinationPath + "\ExportQuotaTemplates.xml") 
        $output = "`nThe importation of the file ""ExportQuotaTemplates.xml"" was successful"
    }
    catch 
    { 
        $_ | Out-File ($DestinationPath + "\logs\ExportQuotaTemplates.log") -Append
        $output = "`nThere was an error while trying to import the file ""ExportQuotaTemplates.xml"" , for more information, please refer to the log folder."
    }
    
    Return $output
}

function Import-FileScreenTemplates ($DestinationPath)
{
    try
    {
        $FsrmFileScreenTemplateManagerObject = new-object -com FSRM.FsrmExportImport
        $FsrmFileScreenTemplateManagerObject.ImportFileScreenTemplates($DestinationPath + "\ExportFileScreenTemplates.xml")
        $output = "`nThe importation of the file ""ExportFileScreenTemplates.xml"" was successful"
    }
    catch 
    {   
        $_ | Out-File ($DestinationPath + "\logs\ExportFileScreenTemplates.log") -Append
        $output = "`nThere was an error while trying to import the file ""ExportFileScreenTemplates.xml"" , for more information, please refer to the log folder."
    }
    
    Return $output
}


function Import-FileGroups ($DestinationPath)
{
    try
    {
        $FsrmFileGroupManagerObject = new-object -com FSRM.FsrmExportImport
        $FsrmFileGroupManagerObject.ImportFileGroups($DestinationPath + "\ExportFileGroups.xml")
        $output = "`nThe importation of the file ""ExportFileGroups.xml"" was successful"
    }
    catch 
    {
        $_ | Out-File ($DestinationPath + "\logs\ExportFileGroups.log") -Append
        $output = "`nThere was an error while trying to import the file ""ExportFileGroups.xml"" , for more information, please refer to the log folder."
    }
    
    Return $output
}

Export-ModuleMember -function Import-QuotaTemplates,Import-FileScreenTemplates,Import-FileGroups 