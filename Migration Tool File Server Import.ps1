

function get-Folderlocation([string]$Message, [string]$InitialDirectory, [switch]$NoNewFolderButton)
{
    $browseForFolderOptions = 0
    if ($NoNewFolderButton) { $browseForFolderOptions += 512 }
 
    $app = New-Object -ComObject Shell.Application
    $folder = $app.BrowseForFolder(0, $Message, $browseForFolderOptions, $InitialDirectory)
    if ($folder) { $selectedDirectory = $folder.Self.Path } else { $selectedDirectory = '' }
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($app) > $null
    return $selectedDirectory
}

function createProcess ($aplication,$arguments,$path,$file)
{
                   $psi = New-object System.Diagnostics.ProcessStartInfo 
                   $psi.CreateNoWindow = $true 
                   $psi.UseShellExecute = $false 
                   $psi.RedirectStandardOutput = $true 
                   $psi.RedirectStandardError = $true 
                   $psi.FileName = "$aplication"
                   $psi.Arguments = "$arguments" + "$path" + "$file"
                   $process = New-Object System.Diagnostics.Process 
                   $process.StartInfo = $psi 
                   [void]$process.Start()
                   $output = $process.StandardOutput.ReadToEnd()
                   $process.WaitForExit()               
                   return   $output
}




function Set-QuotaTemplates ($selectedPath,$textBox1)
{

if (test-path ($selectedPath + "\ExportQuotaTemplates.xml")){
$importQuotaLog = createProcess -aplication "dirquota" -arguments "Template Import /File:" -path $selectedPath -file "\ExportQuotaTemplates.xml"
$outputBox.AppendText($importQuotaLog);$outputBox.ScrollToCaret()
}
else
{$outputBox.AppendText("`nThe file ""ExportQuotaTemplates.xml"" couldnt be found, the Quotas templates will not be imported");$outputBox.ScrollToCaret()}

    
}


function Set-FileScreenTemplates ($selectedPath,$textBox1)
{
 
if (test-path ($selectedPath + "\ExportFileScreenTemplates.xml")){
$importQuotaLog = createProcess -aplication "Filescrn" -arguments "Template Import /File:" -path $selectedPath -file "\ExportFileScreenTemplates.xml"
$outputBox.AppendText($importQuotaLog);$outputBox.ScrollToCaret()
}
else
{$outputBox.AppendText("`nThe file ""ExportFileScreenTemplates.xml"" couldnt be found, the File Screen Templates will not be imported");$outputBox.ScrollToCaret()}       
    
}


function Set-FileGroups ($selectedPath,$textBox1)
{
  
if (test-path ($selectedPath + "\ExportFileGroups.xml")){
$importQuotaLog = createProcess -aplication "Filescrn" -arguments "Filegroup Import /File:" -path $selectedPath -file "\ExportFileGroups.xml"
$outputBox.AppendText($importQuotaLog);$outputBox.ScrollToCaret()
}
else
{$outputBox.AppendText("`nThe file ""ExportFileGroups.xml"" couldnt be found, the File Groups will not be imported");$outputBox.ScrollToCaret()}        
    
}



$createAddGroupSting = @()
$FileScreensExceptionsLog = @()
function Set-FileScreensExceptions ($createAddGroupSting,$FileScreensExceptionsLog,$selectedPath )
{

if (test-path ($selectedPath + "\FileScreensExceptions.xml")){

$importedFileScreensExceptions = Import-Clixml -Path ($selectedPath + "\FileScreensExceptions.xml")
foreach ($1 in $importedFileScreensExceptions)
{

        foreach ($2 in $1.AllowedFileGroups)
        {
        if([string]::IsNullOrEmpty($2) -eq $true){}else{$createAddGroupSting += " /Add-Filegroup:" + """$2"""}
        
        }
        
$444 = $1.Path  
if([string]::IsNullOrEmpty($444) -eq $true){}else{$FileScreensExceptionsLog += createProcess -aplication "Filescrn" -arguments "Exception Add /Path:" -path """$444"""  -file ($createAddGroupSting)}

}        
$outputBox.AppendText($FileScreensExceptionsLog)
$createAddGroupSting = @()

}

else
{$outputBox.AppendText("`nThe file ""FileScreensExceptions.xml"" couldnt be found, the File Screens Exceptions will not be imported");$outputBox.ScrollToCaret()}     

   
}


$FileScreensLogArray = @()
function set-FileScreens ($selectedPath,$FileScreensLog)
{

if (test-path ($selectedPath + "\FileScreens.xml")){


$importedFileScreens = Import-Clixml -Path ($selectedPath + "\FileScreens.xml")
$createFileScreensSting = @()

foreach ($screen in $importedFileScreens)
{
if([string]::IsNullOrEmpty($screen) -eq $true){}else{


        foreach ($2 in $screen.BlockedFileGroups)
                {
                $createFileScreensSting += " /Add-Filegroup:" + """$2""" 
                }

        foreach ($screenVal in $screen.FileScreenFlags)
                {

                        if ($screenVal -eq 1) { 
                              $screenType =   " /Type:Active"
                            }
                      elseif($screenVal -eq 0) { 
                               $screenType =  " /Type:Passive"
                            }
                 }      

$3 = $screen.SourceTemplateName 
$SourceTemplate = " /SourceTemplate:" + """$3"""    
  
$scpath = $screen.Path

$FileScreensLog += createProcess -aplication "Filescrn" -arguments ("screen Add /Path:" ) -path """$scpath""" + " " -file ("$screenType"+ $SourceTemplate + $createFileScreensSting)
$createFileScreensSting = @()



}
 }
 



}else
{$outputBox.AppendText("`nThe file ""FileScreens.xml"" couldnt be found, the File Screens will not be imported");$outputBox.ScrollToCaret()}     


 $FileScreensLog
 $outputBox.AppendText($FileScreensLog)
}


$AutoApplyQuotasLogVar = @()
function Set-AutoApplyQuotas ($AutoApplyQuotasLog,$selectedPath){


if (test-path ($selectedPath + "\AutoApplyQuotas.xml")){
$importedAutoApplyQuotas= Import-Clixml -Path ($selectedPath + "\AutoApplyQuotas.xml")

foreach ($1 in $importedAutoApplyQuotas)
{       
$2 = $1.SourceTemplateName 
$SourceTemplate = " /SourceTemplate:" + """$2"""    
$scpath = $1.Path
$AutoApplyQuotasLog += createProcess -aplication "Dirquota" -arguments "Autoquota Add /Path:" -path """$scpath""" -file "$SourceTemplate"
}        
$outputBox.AppendText($AutoApplyQuotasLog);$outputBox.ScrollToCaret()   




}else{
$outputBox.AppendText("`nThe file ""AutoApplyQuotas.xml"" couldnt be found, the Auto Apply Quotas will not be imported")
}


 
}


function Set-Quotas ($selectedPath)
{
if (test-path ($selectedPath + "\Quotas.xml")){

$importedQuotas = Import-Clixml -Path ($selectedPath + "\Quotas.xml")
$importedQuotas
$QuotasLog = @()
foreach ($1 in $importedQuotas)
{


 
if([string]::IsNullOrEmpty($1) -eq $true){ $1}else{      
$2 = $1.SourceTemplateName 
$SourceTemplate = "/SourceTemplate:" + """$2"""    
$scpath = $1.Path
$QuotasLog += createProcess -aplication "Dirquota" -arguments "Quota Add /Path:" -path """$scpath""" -file " $SourceTemplate"
}        
}


}else{
$outputBox.AppendText("`nThe file ""Quotas.xml"" couldnt be found, the Quotas will not be imported")
}

$outputBox.AppendText($QuotasLog);$outputBox.ScrollToCaret()       
}


function Set-NtfsPermisions ($selectedPath)
{
if (test-path ($selectedPath + "\Ntfs-Permisions.xml")){}else{
$outputBox.AppendText("`nThe file ""AutoApplyQuotas.xml"" couldnt be found, the Auto Apply Quotas will not be imported")}
$ntfslog = Get-ChildItem -Path ($selectedPath + "\Ntfs-Permisions") |% {createProcess -aplication "icacls" -arguments ($_.BaseName + ":\ /restore "+ $selectedPath +"\Ntfs-Permisions\"+ $_.BaseName  +".txt" ) } 

$outputBox.AppendText("`n$ntfslog");$outputBox.ScrollToCaret()       


    
}




###################Load Assembly for creating form & button######
[void][System.Reflection.Assembly]::LoadWithPartialName( “System.Windows.Forms”)
[void][System.Reflection.Assembly]::LoadWithPartialName( “Microsoft.VisualBasic”)
#####Define the form size & placement
$form = New-Object “System.Windows.Forms.Form”;
$form.Width = 550;
$form.Height = 500;
$form.Text = "File server Migration tool";
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;

############################################## Start group boxes

$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Location = New-Object System.Drawing.Size(20,20) 
$groupBox.size = New-Object System.Drawing.Size(500,100) 
$groupBox.text = "Select The Folder where the Exported files are located"

############Define text box1 for input
$textBox1 = New-Object “System.Windows.Forms.TextBox”;
$textBox1.Left = 20;
$textBox1.Top = 40;
$textBox1.width = 250;
$textBox1.Text = "Select Folder"  

#############define select button
$button = New-Object “System.Windows.Forms.Button”;
$button.Left = 360;
$button.Top = 40;
$button.Width = 100;
$button.Text = “Browse”;


############# Defines the ouput window
$outputBox = New-Object System.Windows.Forms.RichTextBox 
$outputBox.Location = New-Object System.Drawing.Size(20,125) 
$outputBox.Size = New-Object System.Drawing.Size(500,170)
$outputBox.BackColor = "DarkBlue"
$outputBox.ForeColor = "WHITE"
$outputBox.Text = "1.0"
$outputBox.MultiLine = $true 
$outputBox.ScrollBars = "Vertical" 

############# This defines the Browse button events


$button.Add_Click({(Get-Variable -Name textBox1).Value.Text = Get-Folderlocation})
############# This defines export button


$ButtonExport = New-Object System.Windows.Forms.Button 
$ButtonExport.Location = New-Object System.Drawing.Size(20,300) 
$ButtonExport.Size = New-Object System.Drawing.Size(500,50) 
$ButtonExport.Text = "Get File Server Configuration Info" 
$ButtonExport.Add_Click({
if (!$textBox1.Text) {$outputBox.AppendText("`nPlease select a folder, where the configuration files will be located");$outputBox.ScrollToCaret()}else{
if((Test-Path $textBox1.Text) -eq $true ){

$selectedPath = $textBox1.Text.Replace(":\",":") 
#Set-QuotaTemplates -selectedPath $selectedPath -outputBox $outputBox
#Set-FileGroups -selectedPath $selectedPath -outputBox $outputBox
Set-FileScreenTemplates -selectedPath $selectedPath -outputBox $outputBox
Set-FileScreensExceptions -selectedPath $selectedPath
#set-FileScreens -selectedPath $selectedPath -FileScreensLog $FileScreensLogArray
#Set-Quotas -selectedPath $selectedPath
#Set-AutoApplyQuotas -AutoApplyQuotasLog $AutoApplyQuotasLogVar -selectedPath $selectedPath

Set-NtfsPermisions -selectedPath $selectedPath

}else {$outputBox.AppendText("`nPlease select a existing folder location");$outputBox.ScrollToCaret()}}}



) 

#############Add controls to all the above objects defined

$Form.Controls.Add($groupBox)
$Form.Controls.Add($outputBox)
$Form.Controls.Add($ButtonExport)

$groupBox.Controls.Add($textBox1)
$groupBox.Controls.Add($button)


$form.ShowDialog();