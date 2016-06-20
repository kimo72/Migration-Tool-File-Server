
function Set-TextColor($Verbose)
{
   if ($Verbose -match "successful" -or $Verbose -match "NTFS") 
   {
        $outputBox.SelectionColor = "White"
        $outputBox.AppendText("`n$Verbose");$outputBox.ScrollToCaret() 
   }
   else
   {
        $outputBox.SelectionColor = "Red"
        $outputBox.AppendText("`n$Verbose");$outputBox.ScrollToCaret()  
   }
   
}

function Get-Script-Directory
{
        $scriptInvocation = (Get-Variable MyInvocation -Scope 1).Value
        return Split-Path $scriptInvocation.MyCommand.Path
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



#validacion de los modulos a importar
try
{
   Import-Module -Name ($modulePath + "\ImportQuotas.psm1") -ErrorAction stop
}
catch 

{
    $outputBox.AppendText("`nEl modulo ImportQuotas.psm1 no se pudo encontrar en la ubicacion $modulePath");$outputBox.ScrollToCaret()
}

try
{
   Import-Module -Name ($modulePath + "\ImportAutoaplyQuotas.psm1") -ErrorAction stop
}
catch 

{
    $outputBox.AppendText("`nEl modulo ImportAutoaplyQuotas.psm1 no se pudo encontrar en la ubicacion $modulePath");$outputBox.ScrollToCaret()
}


try
{
   Import-Module -Name ($modulePath + "\ImportFilescreens.psm1") -ErrorAction stop
}
catch 

{
    $outputBox.AppendText("`nEl modulo ImportFilescreens.psm1 no se pudo encontrar en la ubicacion $modulePath");$outputBox.ScrollToCaret()
}

try
{
   Import-Module -Name ($modulePath + "\Import-FileScreenException.psm1") -ErrorAction stop
}
catch 

{
    $outputBox.AppendText("`nEl modulo Import-FileScreenException.psm1 no se pudo encontrar en la ubicacion $modulePath");$outputBox.ScrollToCaret()
}

try
{
   Import-Module -Name ($modulePath + "\RemoveAndCreateShares.psm1") -ErrorAction stop
}
catch 

{
    $outputBox.AppendText("`nEl modulo RemoveAndCreateShares.psm1 no se pudo encontrar en la ubicacion $modulePath");$outputBox.ScrollToCaret()
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
    if (!$textBox1.Text)
     {
        $outputBox.AppendText("`nPlease select a folder, where the configuration files will be located");$outputBox.ScrollToCaret()
     }
     else
     {
            
            if((Test-Path $textBox1.Text) -eq $true )
            {
                $selectedPath = $textBox1.Text.Replace(":\",":") 
                Set-NtfsPermisions -selectedPath $selectedPath
            }
            else
            {
                $outputBox.AppendText("`nPlease select a existing folder location");$outputBox.ScrollToCaret()
            }
    }
}) 

#############Add controls to all the above objects defined

$Form.Controls.Add($groupBox)
$Form.Controls.Add($outputBox)
$Form.Controls.Add($ButtonExport)
$groupBox.Controls.Add($textBox1)
$groupBox.Controls.Add($button)


$form.ShowDialog();