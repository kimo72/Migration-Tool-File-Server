Import-Module 'C:\Users\admin0987\Documents\GitHub\Migration-Tool-File-Server\Export quota function.psm1' -Force
Import-Module 'C:\Users\admin0987\Documents\GitHub\Migration-Tool-File-Server\Export File Screen function.psm1' -Force
import-module 'C:\Users\admin0987\Documents\GitHub\Migration-Tool-File-Server\ExportSharesInVolume.psm1' -force
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$MyDir = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
$volumeArrary = @()
$volumeArraryQuotas = @()
$volumeArraryFileScreens = @()
$volumeArraryFileScreenExceptions = @()
$volumeArraryAutoApplyQuotas = @()
$volumeArraryNtfs = @()
$selectedVolumenes = @()

function executeProcess ($aplication,$arguments,$path,$file)
{
                   $psi = New-object System.Diagnostics.ProcessStartInfo 
                   $psi.CreateNoWindow = $false 
                   $psi.UseShellExecute = $true 
                   $psi.RedirectStandardOutput = $false 
                   $psi.RedirectStandardError = $false 
                   $psi.FileName = "$aplication"
                   $psi.Arguments = "$arguments" + "$path" + "$file"
                   $process = New-Object System.Diagnostics.Process 
                   $process.StartInfo = $psi 
                   [void]$process.Start()
                   #$output = $process.StandardOutput.ReadToEnd()
                   $process.WaitForExit()               
                   return $psi.Arguments
}



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

function Get-ConfigurationXmls {
$fsrmExportObject = New-Object -Com FSrm.FsrmExportImport
$fsrmQuotaObject = New-Object -Com FSrm.FsrmQuotaManager
$fsrmScreensObject = New-Object -Com Fsrm.FsrmFileScreenManager

try {

if ($volumeA.Checked -eq $true) {$selectedVolumenes += "A:\\"}
if ($volumeB.Checked -eq $true) {$selectedVolumenes += "B:\\"}
if ($volumeC.Checked -eq $true) {$selectedVolumenes += "C:\\"}
if ($volumeD.Checked -eq $true) {$selectedVolumenes += "D:\\"}
if ($volumeE.Checked -eq $true) {$selectedVolumenes += "E:\\"}
if ($volumeF.Checked -eq $true) {$selectedVolumenes += "F:\\"}
if ($volumeG.Checked -eq $true) {$selectedVolumenes += "G:\\"}
if ($volumeH.Checked -eq $true) {$selectedVolumenes += "H:\\"}
if ($volumeI.Checked -eq $true) {$selectedVolumenes += "I:\\"}
if ($volumeJ.Checked -eq $true) {$selectedVolumenes += "J:\\"}
if ($volumeK.Checked -eq $true) {$selectedVolumenes += "K:\\"}
if ($volumeL.Checked -eq $true) {$selectedVolumenes += "L:\\"}
if ($volumeM.Checked -eq $true) {$selectedVolumenes += "M:\\"}
if ($volumeN.Checked -eq $true) {$selectedVolumenes += "N:\\"}
if ($volumeO.Checked -eq $true) {$selectedVolumenes += "O:\\"}
if ($volumeP.Checked -eq $true) {$selectedVolumenes += "P:\\"}
if ($volumeQ.Checked -eq $true) {$selectedVolumenes += "Q:\\"}
if ($volumeR.Checked -eq $true) {$selectedVolumenes += "R:\\"}
if ($volumeS.Checked -eq $true) {$selectedVolumenes += "R:\\"}
if ($volumeT.Checked -eq $true) {$selectedVolumenes += "T:\\"}
if ($volumeU.Checked -eq $true) {$selectedVolumenes += "U:\\"}
if ($volumeV.Checked -eq $true) {$selectedVolumenes += "V:\\"}
if ($volumeW.Checked -eq $true) {$selectedVolumenes += "W:\\"}
if ($volumeX.Checked -eq $true) {$selectedVolumenes += "X:\\"}
if ($volumeY.Checked -eq $true) {$selectedVolumenes += "Y:\\"}
if ($volumeZ.Checked -eq $true) {$selectedVolumenes += "Z:\\"}

foreach ($volumeMatch in $selectedVolumenes)
{
#$volumeArraryQuotas += $fsrmQuotaObject.EnumQuotas()| where {$_.path -match $volumeMatch} 
$volumeArraryFileScreens +=$fsrmScreensObject.EnumFileScreens() | where {$_.path -match $volumeMatch} 
$volumeArraryFileScreenExceptions +=$fsrmScreensObject.EnumFileScreenExceptions() | where {$_.path -match $volumeMatch} 
$volumeArraryAutoApplyQuotas +=$fsrmQuotaObject.EnumAutoApplyQuotas() | where {$_.path -match $volumeMatch} 

 }
# create a xml with the selected cuotas
if ($exportQuotaBox.Checked -eq $true) {

#volumeArraryQuotas |Export-Clixml -Path ($textBox1.Text + "\Quotas.xml")
#Write-Host  Get-QuotaConfig -selectedVolumenes $selectedVolumenes -DestinationPath ($textBox1.Text) 
Get-QuotaConfig -selectedVolumenes $selectedVolumenes -DestinationPath ($textBox1.Text) 
$outputBox.AppendText("`nThe exportation of the file ""Quotas.xml"" was successful");$outputBox.ScrollToCaret()

}

# create a xml with the selected File Screens
if ($exportFileScreensBox.Checked -eq $true) {
#$volumeArraryFileScreens |Export-Clixml -Path ($textBox1.Text + "\FileScreens.xml")
Get-FileScreenConfig -selectedVolumenes $selectedVolumenes -DestinationPath ($textBox1.Text) 
$outputBox.AppendText("`nThe exportation of the file ""FileScreens.xml"" was successful");$outputBox.ScrollToCaret()}

# create a xml with the selected FileScreens Exceptions
if ($exportFileScreensExceptionsBox.Checked -eq $true) {
$volumeArraryFileScreenExceptions |Export-Clixml -Path ($textBox1.Text + "\FileScreensExceptions.xml")

$outputBox.AppendText("`nThe exportation of the file ""FileScreensExceptions.xml"" was successful");$outputBox.ScrollToCaret()
}

# create a xml with the selected AutoApply Quotas
if ($exportAutoApplyQuotasBox.Checked -eq $true) {$volumeArraryAutoApplyQuotas |Export-Clixml -Path ($textBox1.Text + "\AutoApplyQuotas.xml")
$volumeArraryAutoApplyQuotas |Export-Clixml -Path ($textBox1.Text + "\AutoApplyQuotas.xml")

$outputBox.AppendText("`nThe exportation of the file ""AutoApplyQuotas.xml"" was successful");$outputBox.ScrollToCaret()
}



 #Export Quota Templates
          if ($exportQuotaTemplateBox.Checked -eq $true) {
          
          try { $Error.Clear()
$fsrmExportObject.ExportQuotaTemplates($textBox1.Text + "\ExportQuotaTemplates.xml")
 $outputBox.AppendText("`nThe exportation of the file ""ExportQuotaTemplates.xml"" was successful");$outputBox.ScrollToCaret()
}
catch 
{
if("$error.Exception" -like "*The file exists. (Exception from HRESULT: 0x80070050)*" ){$outputBox.AppendText("`nA file called ""ExportQuotaTemplates.xml"" already exist in the specified location");$outputBox.ScrollToCaret(); $Error.Clear()}else{ $outputBox.AppendText("`nholy.... something wrong happened Exporting Quota Templates ");$outputBox.ScrollToCaret()}
 $Error.Clear()
}

                                                                 

 }
 #Export File groups Templates
if ($exportFilegroupsTemplateBox.Checked -eq $true) {
          try { $Error.Clear()
$fsrmExportObject.ExportFileGroups($textBox1.Text + "\ExportFileGroups.xml")
 $outputBox.AppendText("`nThe exportation of the file ""ExportFileGroups.xml"" was successful");$outputBox.ScrollToCaret()
}
catch 
{
if("$error.Exception" -like "*The file exists. (Exception from HRESULT: 0x80070050)*" ){ $outputBox.AppendText("`nA file called ""ExportFileGroups.xml"" already exist in the specified location");$outputBox.ScrollToCaret(); $Error.Clear()}else{ $outputBox.AppendText("`nholy.... something wrong happened Exporting File Groups");$outputBox.ScrollToCaret()}
 $Error.Clear()
}  
 
}
 #Export Files Screen Templates
if ($exportFilesScreensTemplateBox.Checked -eq $true) {
       try { $Error.Clear()
$fsrmExportObject.ExportFileScreenTemplates($textBox1.Text + "\ExportFileScreenTemplates.xml")
 $outputBox.AppendText("`nThe exportation of the file ""ExportFileScreenTemplates.xml"" was successful");$outputBox.ScrollToCaret()
}
catch 
{
if("$error.Exception" -like "*The file exists. (Exception from HRESULT: 0x80070050)*" ){$outputBox.AppendText("`nA file called ""shares.reg"" already exist in the specified location");$outputBox.ScrollToCaret(); $Error.Clear()}else{  $outputBox.AppendText("`nholy.... something wrong happened Exporting File Screen Templates");$outputBox.ScrollToCaret()}

}
}
 #Export shares configurations
if ($sharesRegistry.Checked -eq $true) {
if ((Test-Path -Path ($textBox1.Text + "\sharePermission.csv")) -eq $true) {$outputBox.AppendText("`nA file called ""shares.reg"" already exist in the specified location");$outputBox.ScrollToCaret()} else{
Export-shares-To-File -FileRepositoryPath ($textBox1.Text) -volumens $selectedVolumenes 
#reg export HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Shares ($textBox1.Text + "\shares.reg")
; $outputBox.AppendText("`nThe configurations of the shares was successfully exported in the file ""Shares.reg""");$outputBox.ScrollToCaret()}

}



 #Export NTFS configurations
if ($ntfsPermissions.Checked -eq $true) {


               if ((Test-Path($textBox1.Text + "\Ntfs-Permisions")) -eq $true) {}else{new-item -Path ($textBox1.Text + "\Ntfs-Permisions")  -Force -ItemType Directory}
               if ((Test-Path($textBox1.Text + "\Logs")) -eq $true) {}else{new-item -Path ($textBox1.Text + "\Logs")  -Force -ItemType Directory}
               if ((Test-Path($textBox1.Text + "\Logs\Ntfs-errors")) -eq $true) {}else{new-item -Path ($textBox1.Text + "\Logs\Ntfs-Errors\")  -Force -ItemType Directory}
               if ((Test-Path($textBox1.Text + "\Logs\Ntfs-succesful")) -eq $true) {}else{new-item -Path ($textBox1.Text + "\Logs\Ntfs-Succesful\")  -Force -ItemType Directory}
               
            
               
               

                foreach ($item in $selectedVolumenes)
                {
                    $fileName = $item.Replace(":\\","") 
                 #$volumeArraryNtfs += executeProcess -aplication "icacls" -arguments ($fileName +":\* /save " +$textBox1.Text + "" + "Ntfs-Permisions\"+ "$fileName"+ ".txt" + " /t /c")


$volumeArraryNtfs += executeProcess -aplication "cmd" -arguments ("/k icacls " + $fileName +":\* /save " +$textBox1.Text  + "Ntfs-Permisions\"+ $fileName+ ".txt" + " /t /c > "+ $textBox1.Text + "Logs\Ntfs-succesful\" + $fileName+ ".log 2> " + $textBox1.Text + "Logs\Ntfs-Errors\" + $fileName+ ".log" )

                }
          
               
                $outputBox.AppendText("`n$volumeArraryNtfs")
              
}

}

catch {$outputBox.AppendText("`nOperation could not be completed");$outputBox.ScrollToCaret()}

                           }


###################Load Assembly for creating form & button######

[void][System.Reflection.Assembly]::LoadWithPartialName( “System.Windows.Forms”)
[void][System.Reflection.Assembly]::LoadWithPartialName( “Microsoft.VisualBasic”)

#####Define the form size & placement

$form = New-Object “System.Windows.Forms.Form”;
$form.Width = 550;
$form.Height = 700;
$Form.FormBorderStyle = 'FixedSingle'
$Form.MaximizeBox = $false
$form.Text = "File server Migration tool";
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;

############################################## Start group boxes

$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Location = New-Object System.Drawing.Size(20,20) 
$groupBox.size = New-Object System.Drawing.Size(500,100) 
$groupBox.text = "Select The Folder where the files will be located"

$groupBox2 = New-Object System.Windows.Forms.GroupBox
$groupBox2.Location = New-Object System.Drawing.Size(20,125) 
$groupBox2.size = New-Object System.Drawing.Size(500,55) 
$groupBox2.text = "Select The templates to export"

$groupBox3 = New-Object System.Windows.Forms.GroupBox
$groupBox3.Location = New-Object System.Drawing.Size(20,185) 
$groupBox3.size = New-Object System.Drawing.Size(500,55) 
$groupBox3.text = "Select Configurations that will be migrated"

$groupBox4 = New-Object System.Windows.Forms.GroupBox
$groupBox4.Location = New-Object System.Drawing.Size(20,245) 
$groupBox4.size = New-Object System.Drawing.Size(500,115) 
$groupBox4.text = "Select volumes that will be migrated"

$groupBox5 = New-Object System.Windows.Forms.GroupBox
$groupBox5.Location = New-Object System.Drawing.Size(20,365) 
$groupBox5.size = New-Object System.Drawing.Size(500,55) 
$groupBox5.text = "Select permisions or shares config"

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

#############define chekboxes templates
$exportQuotaTemplateBox = New-Object System.Windows.Forms.checkbox
$exportQuotaTemplateBox.Location = New-Object System.Drawing.Size(20,20)
$exportQuotaTemplateBox.Size = New-Object System.Drawing.Size(120,20)
$exportQuotaTemplateBox.Text = "Quota templates"


$exportFilesScreensTemplateBox = New-Object System.Windows.Forms.checkbox
$exportFilesScreensTemplateBox.Location = New-Object System.Drawing.Size(180,20)
$exportFilesScreensTemplateBox.Size = New-Object System.Drawing.Size(150,20)
$exportFilesScreensTemplateBox.Text = "Files Screens Templates"

$exportFilegroupsTemplateBox = New-Object System.Windows.Forms.checkbox
$exportFilegroupsTemplateBox.Location = New-Object System.Drawing.size(360,20)
$exportFilegroupsTemplateBox.Size = New-Object System.Drawing.Size(100,20)
$exportFilegroupsTemplateBox.Text = "File groups"


#############define chekboxes configurations
$exportQuotaBox = New-Object System.Windows.Forms.checkbox
$exportQuotaBox.Location = New-Object System.Drawing.Size(20,20)
$exportQuotaBox.Size = New-Object System.Drawing.Size(80,20)
$exportQuotaBox.Text = "Quotas"

$exportAutoApplyQuotasBox = New-Object System.Windows.Forms.checkbox
$exportAutoApplyQuotasBox.Location = New-Object System.Drawing.Size(110,20)
$exportAutoApplyQuotasBox.Size = New-Object System.Drawing.Size(115,20)
$exportAutoApplyQuotasBox.Text = "AutoApply Quotas"

$exportFileScreensBox = New-Object System.Windows.Forms.checkbox
$exportFileScreensBox.Location = New-Object System.Drawing.size(245,20)
$exportFileScreensBox.Size = New-Object System.Drawing.Size(100,20)
$exportFileScreensBox.Text = "Files Screens"

$exportFileScreensExceptionsBox = New-Object System.Windows.Forms.checkbox
$exportFileScreensExceptionsBox.Location = New-Object System.Drawing.size(355,20)
$exportFileScreensExceptionsBox.Size = New-Object System.Drawing.Size(139,20)
$exportFileScreensExceptionsBox.Text = "File Screen Exceptions"

#############define volumes templates
$volumeA = New-Object System.Windows.Forms.checkbox
$volumeA.Location = New-Object System.Drawing.size(20,20)
$volumeA.Size = New-Object System.Drawing.Size(35,20)
$volumeA.Checked = $false
$volumeA.Enabled =if ((test-path "A:")){$false}
$volumeA.Text = "A:"

$volumeB = New-Object System.Windows.Forms.checkbox
$volumeB.Location = New-Object System.Drawing.size(60,20)
$volumeB.Size = New-Object System.Drawing.Size(35,20)
$volumeB.Checked = $false
$volumeB.Enabled =if ((test-path "B:")){$true}
$volumeB.Text = "B:"

$volumeC = New-Object System.Windows.Forms.checkbox
$volumeC.Location = New-Object System.Drawing.size(100,20)
$volumeC.Size = New-Object System.Drawing.Size(35,20)
$volumeC.Checked = $false
$volumeC.Enabled = if ((test-path "C:")){$true}
$volumeC.Text = "C:"

$volumeD = New-Object System.Windows.Forms.checkbox
$volumeD.Location = New-Object System.Drawing.size(140,20)
$volumeD.Size = New-Object System.Drawing.Size(35,20)
$volumeD.Checked = $false
$volumeD.Enabled =if (test-path "D:"){$true}
$volumeD.Text = "D:"

$volumeE = New-Object System.Windows.Forms.checkbox
$volumeE.Location = New-Object System.Drawing.size(180,20)
$volumeE.Size = New-Object System.Drawing.Size(35,20)
$volumeE.Checked = $false
$volumeE.Enabled =if ((test-path "E:")){$true}
$volumeE.Text = "E:"

$volumeF = New-Object System.Windows.Forms.checkbox
$volumeF.Location = New-Object System.Drawing.size(220,20)
$volumeF.Size = New-Object System.Drawing.Size(35,20)
$volumeF.Checked = $false
$volumeF.Enabled =if ((test-path "F:")){$true}
$volumeF.Text = "F:"

$volumeG = New-Object System.Windows.Forms.checkbox
$volumeG.Location = New-Object System.Drawing.size(260,20)
$volumeG.Size = New-Object System.Drawing.Size(35,20)
$volumeG.Checked = $false
$volumeG.Enabled =if ((test-path "G:")){$true}
$volumeG.Text = "G:"

$volumeH = New-Object System.Windows.Forms.checkbox
$volumeH.Location = New-Object System.Drawing.size(300,20)
$volumeH.Size = New-Object System.Drawing.Size(35,20)
$volumeH.Checked = $false
$volumeH.Enabled =if ((test-path "H:")){$true}
$volumeH.Text = "H:"

$volumeI = New-Object System.Windows.Forms.checkbox
$volumeI.Location = New-Object System.Drawing.size(340,20)
$volumeI.Size = New-Object System.Drawing.Size(35,20)
$volumeI.Checked = $false
$volumeI.Enabled =if ((test-path "I:")){$true}
$volumeI.Text = "I:"

$volumeJ = New-Object System.Windows.Forms.checkbox
$volumeJ.Location = New-Object System.Drawing.size(380,20)
$volumeJ.Size = New-Object System.Drawing.Size(35,20)
$volumeJ.Checked = $false
$volumeJ.Enabled =if ((test-path "J:")){$true}
$volumeJ.Text = "J:"

$volumeK = New-Object System.Windows.Forms.checkbox
$volumeK.Location = New-Object System.Drawing.size(420,20)
$volumeK.Size = New-Object System.Drawing.Size(35,20)
$volumeK.Checked = $false
$volumeK.Enabled =if ((test-path "K:")){$true}
$volumeK.Text = "K:"

$volumeL = New-Object System.Windows.Forms.checkbox
$volumeL.Location = New-Object System.Drawing.size(20,50)
$volumeL.Size = New-Object System.Drawing.Size(35,20)
$volumel.Checked = $false
$volumel.Enabled =if ((test-path "K:")){$true}
$volumeL.Text = "L:"

$volumeM = New-Object System.Windows.Forms.checkbox
$volumeM.Location = New-Object System.Drawing.size(60,50)
$volumeM.Size = New-Object System.Drawing.Size(36,20)
$volumeM.Checked = $false
$volumeM.Enabled =if ((test-path "M:")){$true}
$volumeM.Text = "M:"

$volumeN = New-Object System.Windows.Forms.checkbox
$volumeN.Location = New-Object System.Drawing.size(100,50)
$volumeN.Size = New-Object System.Drawing.Size(35,20)
$volumeN.Checked = $false
$volumeN.Enabled =if ((test-path "N:")){$true}
$volumeN.Text = "N:"

$volumeO = New-Object System.Windows.Forms.checkbox
$volumeO.Location = New-Object System.Drawing.size(140,50)
$volumeO.Size = New-Object System.Drawing.Size(35,20)
$volumeO.Checked = $false
$volumeO.Enabled =if ((test-path "O:")){$true}
$volumeO.Text = "O:"

$volumeP = New-Object System.Windows.Forms.checkbox
$volumeP.Location = New-Object System.Drawing.size(180,50)
$volumeP.Size = New-Object System.Drawing.Size(35,20)
$volumeP.Checked = $false
$volumeP.Enabled =if ((test-path "O:")){$true}
$volumeP.Text = "P:"

$volumeQ = New-Object System.Windows.Forms.checkbox
$volumeQ.Location = New-Object System.Drawing.size(220,50)
$volumeQ.Size = New-Object System.Drawing.Size(35,20)
$volumeQ.Checked = $false
$volumeQ.Enabled =if ((test-path "Q:")){$true}
$volumeQ.Text = "Q:"

$volumeR = New-Object System.Windows.Forms.checkbox
$volumeR.Location = New-Object System.Drawing.size(260,50)
$volumeR.Size = New-Object System.Drawing.Size(35,20)
$volumeR.Checked = $false
$volumeR.Enabled =if ((test-path "R:")){$true}
$volumeR.Text = "R:"

$volumeS = New-Object System.Windows.Forms.checkbox
$volumeS.Location = New-Object System.Drawing.size(300,50)
$volumeS.Size = New-Object System.Drawing.Size(35,20)
$volumeS.Checked = $false
$volumeS.Enabled =if ((test-path "S:")){$true}
$volumeS.Text = "S:"

$volumeT = New-Object System.Windows.Forms.checkbox
$volumeT.Location = New-Object System.Drawing.size(340,50)
$volumeT.Size = New-Object System.Drawing.Size(35,20)
$volumeT.Checked = $false
$volumeT.Enabled =if ((test-path "T:")){$true}
$volumeT.Text = "T:"

$volumeU = New-Object System.Windows.Forms.checkbox
$volumeU.Location = New-Object System.Drawing.size(380,50)
$volumeU.Size = New-Object System.Drawing.Size(35,20)
$volumeU.Checked = $false
$volumeU.Enabled =if ((test-path "U:")){$true}
$volumeU.Text = "U:"

$volumeV = New-Object System.Windows.Forms.checkbox
$volumeV.Location = New-Object System.Drawing.size(420,50)
$volumeV.Size = New-Object System.Drawing.Size(35,20)
$volumeV.Checked = $false
$volumeV.Enabled =if ((test-path "V:")){$true}
$volumeV.Text = "V:"

$volumeW = New-Object System.Windows.Forms.checkbox
$volumeW.Location = New-Object System.Drawing.size(20,80)
$volumeW.Size = New-Object System.Drawing.Size(37,20)
$volumeW.Checked = $false
$volumeW.Enabled =if ((test-path "W:")){$true}
$volumeW.Text = "W:"

$volumeX = New-Object System.Windows.Forms.checkbox
$volumeX.Location = New-Object System.Drawing.size(60,80)
$volumeX.Size = New-Object System.Drawing.Size(35,20)
$volumeX.Checked = $false
$volumeX.Enabled =if ((test-path "X:")){$true}
$volumeX.Text = "X:"

$volumeY = New-Object System.Windows.Forms.checkbox
$volumeY.Location = New-Object System.Drawing.size(100,80)
$volumeY.Size = New-Object System.Drawing.Size(35,20)
$volumeY.Checked = $false
$volumeY.Enabled =if ((test-path "Y:")){$true}
$volumeY.Text = "Y:"

$volumeZ = New-Object System.Windows.Forms.checkbox
$volumeZ.Location = New-Object System.Drawing.size(140,80)
$volumeZ.Size = New-Object System.Drawing.Size(35,20)
$volumeZ.Checked = $false
$volumeZ.Enabled =if ((test-path "Z:")){$true}
$volumeZ.Text = "Z:"
############# Defines the shares config an ntfs permisions

$sharesRegistry = New-Object System.Windows.Forms.checkbox
$sharesRegistry.Location = New-Object System.Drawing.size(300,20)
$sharesRegistry.Size = New-Object System.Drawing.Size(150,20)
$sharesRegistry.Text = "Shares Configuration"

$ntfsPermissions = New-Object System.Windows.Forms.checkbox
$ntfsPermissions.Location = New-Object System.Drawing.size(20,20)
$ntfsPermissions.Size = New-Object System.Drawing.Size(150,20)
$ntfsPermissions.Text = "NTFS Permissions"

############# Defines the ouput window
$outputBox = New-Object System.Windows.Forms.RichTextBox 
$outputBox.Location = New-Object System.Drawing.Size(20,425) 
$outputBox.Size = New-Object System.Drawing.Size(500,170)
$outputBox.BackColor = "DarkBlue"
$outputBox.ForeColor = "WHITE"
$outputBox.Text = "Bug V-2.0"
$outputBox.MultiLine = $true 
$outputBox.ScrollBars = "Vertical" 



############# This defines export button


$ButtonExport = New-Object System.Windows.Forms.Button 
$ButtonExport.Location = New-Object System.Drawing.Size(20,600) 
$ButtonExport.Size = New-Object System.Drawing.Size(500,50) 
$ButtonExport.Text = "Get File Server Configuration Info" 
$ButtonExport.Add_Click({

if (!$textBox1.Text) {$outputBox.AppendText("`nPlease select a folder, where the configuration files will be located");$outputBox.ScrollToCaret()}else{




if((Test-Path $textBox1.Text) -eq $true ){Get-ConfigurationXmls}else {$outputBox.AppendText("`nPlease select a existing folder location");$outputBox.ScrollToCaret()}}}) 



############# This defines the Browse button events

$button.Add_Click({(Get-Variable -Name textBox1).Value.Text = Get-Folderlocation})
#############Add controls to all the above objects defined

$Form.Controls.Add($groupBox)
$Form.Controls.Add($groupBox2)
$Form.Controls.Add($groupBox3)
$Form.Controls.Add($groupBox4)
$Form.Controls.Add($groupBox5)
$Form.Controls.Add($outputBox)
$Form.Controls.Add($ButtonExport)  
$groupBox.Controls.Add($button);
$groupBox.Controls.Add($textBox1);
$groupBox2.Controls.Add($exportQuotaTemplateBox)
$groupBox2.Controls.Add($exportFilesScreensTemplateBox)
$groupBox2.Controls.Add($exportFilegroupsTemplateBox)
$groupBox3.Controls.Add($exportQuotaBox)
$groupBox3.Controls.Add($exportAutoApplyQuotasBox)
$groupBox3.Controls.Add($exportFileScreensBox)
$groupBox3.Controls.Add($exportAutoApplyQuotasBox)
$groupBox3.Controls.Add($exportFileScreensExceptionsBox)

$groupBox4.Controls.Add($volumeA)
$groupBox4.Controls.Add($volumeB)
$groupBox4.Controls.Add($volumeC)
$groupBox4.Controls.Add($volumeD)
$groupBox4.Controls.Add($volumeE)
$groupBox4.Controls.Add($volumeF)
$groupBox4.Controls.Add($volumeG)
$groupBox4.Controls.Add($volumeH)
$groupBox4.Controls.Add($volumeI)
$groupBox4.Controls.Add($volumeJ)
$groupBox4.Controls.Add($volumeK)
$groupBox4.Controls.Add($volumeL)
$groupBox4.Controls.Add($volumeM)
$groupBox4.Controls.Add($volumeN)
$groupBox4.Controls.Add($volumeO)
$groupBox4.Controls.Add($volumeP)
$groupBox4.Controls.Add($volumeQ)
$groupBox4.Controls.Add($volumeR)
$groupBox4.Controls.Add($volumeS)
$groupBox4.Controls.Add($volumeT)
$groupBox4.Controls.Add($volumeU)
$groupBox4.Controls.Add($volumeV)
$groupBox4.Controls.Add($volumeW)
$groupBox4.Controls.Add($volumeX)
$groupBox4.Controls.Add($volumeY)
$groupBox4.Controls.Add($volumeZ)
$groupBox5.Controls.Add($sharesRegistry)
$groupBox5.Controls.Add($ntfsPermissions)



$form.ShowDialog();


