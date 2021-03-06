function Import-QuotaTemplates ($DestinationPath)
{

    if([System.IO.Directory]::Exists([string]$DestinationPath + '\ExportQuotaTemplates.xml'))
    {
        $output = "`nThe file ""ExportQuotaTemplates.xml"" couldnt be found, The Quotas templates will not be imported."
        return $output
    }
    else
    {
    
        try
        {
            $FsrmQuotaTemplateManagerObject = new-object -com FSRM.FsrmExportImport
            $QuotaTemplates =$FsrmQuotaTemplateManagerObject.ImportQuotaTemplates($DestinationPath + "\ExportQuotaTemplates.xml")
            $QuotaTemplates|% {$_.Commit()}
         
            $output = "`nThe importation of the file ""ExportQuotaTemplates.xml"" was successful"
        }
        catch 
        { 
            $_ | Out-File ($DestinationPath + "\logs\ExportQuotaTemplates.log") -Append
            $output = "`nThere was an error while trying to import the file ""ExportQuotaTemplates.xml"" , for more information, please refer to the log folder."
        }
    
    }
            
        
        
    Return $output
}

function Import-FileScreenTemplates ($DestinationPath)
{
 $warning = [System.Windows.Forms.MessageBox]::Show($FrmMain, "In order to import the ExportFileScreenTemplates, you must  ensure that the file groups are already created in the FSRM console. Or the file ""ExportFileGroups.xml"" is along the ""ExportFileScreenTemplates.xml"" `n`n¡Are you shure you want to continue?", "Migration Tool File Server Export",1,48) 
 
    if($warning -eq "OK")
    {
 
        if([System.IO.Directory]::Exists([string]$DestinationPath+  '\ExportFileScreenTemplates.xml'))
        {
            $output = "`nThe file ""ExportFileScreenTemplates.xml"" couldnt be found, The  fileScreen templates will not be imported."
            Return $output
        }
        else
        {
            try
            {
                $FsrmFileScreenTemplateManagerObject = new-object -com FSRM.FsrmExportImport
                $FileScreenTemplates = $FsrmFileScreenTemplateManagerObject.ImportFileScreenTemplates($DestinationPath + "\ExportFileScreenTemplates.xml")
                $FileScreenTemplates|% {$_.Commit()}
                $output = "`nThe importation of the file ""ExportFileScreenTemplates.xml"" was successful"
            }
            catch 
            {   
                $_ | Out-File ($DestinationPath + "\logs\ExportFileScreenTemplates.log") -Append
                $output = "`nThere was an error while trying to import the file ""ExportFileScreenTemplates.xml"" , for more information, please refer to the log folder."
            }
         
        }
    }
           
    Return $output
}


function Import-FileGroups ($DestinationPath)
{

    if([System.IO.Directory]::Exists([string]$DestinationPath+ '\ExportFileGroups.xml'))
    {
        $output = "`nThe file ""ExportFileGroups.xml"" couldnt be found, The File Groups will not be imported."
        Return $output
    }
    else
    {
        try
        {
            $FsrmFileGroupManagerObject = new-object -com FSRM.FsrmExportImport
            $FileGroups = $FsrmFileGroupManagerObject.ImportFileGroups($DestinationPath + "\ExportFileGroups.xml")
            $FileGroups|% {$_.Commit()}
            $output = "`nThe importation of the file ""ExportFileGroups.xml"" was successful"
        }
        catch 
        {
            $_ | Out-File ($DestinationPath + "\logs\ExportFileGroups.log") -Append
            $output = "`nThere was an error while trying to import the file ""ExportFileGroups.xml"" , for more information, please refer to the log folder."
        }
    
    }
    
    Return $output
}

Export-ModuleMember -function Import-QuotaTemplates,Import-FileScreenTemplates,Import-FileGroups 