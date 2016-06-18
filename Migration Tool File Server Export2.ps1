

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
    if ($folder) { $selectedDirectory = $folder.Self.Path } 
    else { $selectedDirectory = '' }
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($app) > $null
    return $selectedDirectory
}
 
$modulePath =Get-Script-Directory


$existentVolumes=@()
$logicalDiskInFileServer = get-wmiobject -class win32_logicalDisk | where-object {$_.DriveType -eq 3}
foreach($logicalDisk in $logicalDiskInFileServer){
    $logicalDiskLetter = $logicalDisk.DeviceID
    $existentVolumes += $logicalDiskLetter
<#    
   $shareFilter = "SELECT * FROM Win32_Share WHERE Name != 'ADMIN$' AND Name != 'IPC$' AND Description != 'Default share' AND Path LIKE '$logicalDiskLetter%'"
   $sharesInVolume = Get-WmiObject -query $shareFilter
        foreach ($ExistentInVolumen in $sharesInVolume){
           if ($ExistentInVolumen.type -ne 3221225472){
                $ExistentInVolumen.name
                $existentVolumes += $logicalDiskLetter
           }
       }
   #>
}
 
 
$global:checkedButtons = @()
#$global:ExportOptionsButtons = @()
$global:checkBoxNumbers = 0
 
$form = New-Object “System.Windows.Forms.Form”;
$form.Width = 440;
$form.Height = 560;
$Form.FormBorderStyle = 'FixedSingle'
$Form.MaximizeBox = $false
$form.Text = "File server Migration tool";
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;
$TabControl = New-object System.Windows.Forms.TabControl
$VolumePage = New-Object System.Windows.Forms.TabPage
$OptionsPage = New-Object System.Windows.Forms.TabPage
$groupBoxOptions = New-Object System.Windows.Forms.GroupBox
$groupBoxOptions1 = New-Object System.Windows.Forms.GroupBox
$groupBoxOptions2 = New-Object System.Windows.Forms.GroupBox

 ############################################## Start outputBox
$outputBox = New-Object System.Windows.Forms.RichTextBox 
$outputBox.Location = New-Object System.Drawing.Size(10,220) 
$outputBox.Size = New-Object System.Drawing.Size(370,200)
$outputBox.BackColor = "DarkBlue" 
$outputBox.ForeColor = "WHITE"
$outputBox.Text = "Bug V-3.0"
$outputBox.MultiLine = $true 
$outputBox.ScrollBars = "Vertical" 

#crea el boton para selecionar el la ubicacion de los archivos
 
############Define text box1 for input
$textBox1 = New-Object “System.Windows.Forms.TextBox”;
$textBox1.Left = 10;
$textBox1.Top = 40;
$textBox1.width = 250;
$textBox1.Text = "Select Folder"  

#############define select button
$Browsebutton = New-Object “System.Windows.Forms.Button”;
$Browsebutton.Left = 265;
$Browsebutton.Top = 39;
$Browsebutton.Width = 100;
$Browsebutton.Text = “Browse”; 
############# This defines the Browse button events

$Browsebutton.Add_Click({(Get-Variable -Name textBox1).Value.Text = Get-Folderlocation})



 
 

#validacion de los modulos a importar
try
{
   Import-Module -Name ($modulePath + "\ExportSharesInVolumes.psm1") -ErrorAction stop
}
catch 

{
    $outputBox.AppendText("`nEl modulo ExportSharesInVolumes.psm1 no se pudo encontrar en la ubicacion $modulePath");$outputBox.ScrollToCaret()
}


try
{
    Import-Module -Name ($modulePath + "\ExportAutoapplyQuotas.psm1") -ErrorAction stop
}
catch 
{
    $outputBox.AppendText("`nEl modulo ExportAutoapplyQuotas1.psm1 no se pudo encontrar en la ubicacion $modulePath");$outputBox.ScrollToCaret()
}


try
{
    Import-Module -Name ($modulePath + "\ExportFileScreens.psm1") -ErrorAction stop
}
catch 
{

    $outputBox.AppendText("`nEl modulo ExportFileScreen.psm1 no se pudo encontrar en la ubicacion $modulePath");$outputBox.ScrollToCaret()

}


try
{
    Import-Module -Name ($modulePath + "\ExportQuota.psm1") -ErrorAction stop
}
catch 
{
    $outputBox.AppendText("`nEl modulo no se pudo encontrar en la ubicacion $modulePath");$outputBox.ScrollToCaret()
    
} 
 
#Tab Control
$tabControl.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 15
$System_Drawing_Point.Y = 15
$tabControl.Location = $System_Drawing_Point
$tabControl.Name = "tabControl"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 450
$System_Drawing_Size.Width = 400
$tabControl.Size = $System_Drawing_Size
 
$OptionsPage.DataBindings.DefaultDataSourceUpdateMode = 0
$OptionsPage.UseVisualStyleBackColor = $True
$OptionsPage.Name = "OptionsPage"
$OptionsPage.Text = "Exportar”
$tabControl.Controls.Add($OptionsPage)

$groupBoxOptions0 = New-Object System.Windows.Forms.groupBox
$groupBoxOptions0.Location = New-Object System.Drawing.Size(10,10)
$groupBoxOptions0.size = New-Object System.Drawing.Size(370,100)
$groupBoxOptions0.text = "Select The Folder where the files will be located"
 
$groupBoxOptions = New-Object System.Windows.Forms.groupBox
$groupBoxOptions.Location = New-Object System.Drawing.Size(10,120)
$groupBoxOptions.size = New-Object System.Drawing.Size(370,100)
$groupBoxOptions.text = "Select templates to Export"
 
$groupBoxOptions1 = New-Object System.Windows.Forms.groupBox
$groupBoxOptions1.Location = New-Object System.Drawing.Size(10,230)
$groupBoxOptions1.size = New-Object System.Drawing.Size(370,100)
$groupBoxOptions1.text = "Select the settings to be migrated"
 
$groupBoxOptions2 = New-Object System.Windows.Forms.groupBox
$groupBoxOptions2.Location = New-Object System.Drawing.Size(10,340)
$groupBoxOptions2.size = New-Object System.Drawing.Size(370,60)
$groupBoxOptions2.text = "Select Extended Parameters"
 
$ButtonOptionsChk = New-Object System.Windows.Forms.Button
$ButtonOptionsChk.Location = New-Object System.Drawing.Size(160,420)
$ButtonOptionsChk.Size = New-Object System.Drawing.Size(80,30)
$ButtonOptionsChk.Text = "Check Values"
 
$groupBoxOptions2.Controls.Add($ButtonOptionsChk)
$groupBoxOptions0.Controls.Add($Browsebutton)
$groupBoxOptions0.Controls.Add($textBox1)

$ButtonOptionsChk.Add_Click({
        $global:ExportOptionsButtons  = @()
        $OptionsPageGroupBox = $OptionsPage.Controls | where{$_.AccessibilityObject -match "System.Windows.Forms.GroupBox" }
        write-host $OptionsPageGroupBox.count
        foreach ($groupInOptionsPage in $OptionsPageGroupBox){
            $OptionsCheckBoxesInPage = $groupInOptionsPage.Controls | where{$_.AccessibilityObject -match "System.Windows.Forms.CheckBox" }
            foreach($OptionsCheckBoxes in $OptionsCheckBoxesInPage ){
                if ($OptionsCheckBoxes.checked){
                    $global:ExportOptionsButtons += $OptionsCheckBoxes.text
                }
            }
        }
        #$chk.name = "checkbox30"
       
    write-host "Checkbox selected: " $global:ExportOptionsButtons
})
 
$VolumePage.DataBindings.DefaultDataSourceUpdateMode = 0
$VolumePage.UseVisualStyleBackColor = $True
$VolumePage.Name = "VolumePage"
$VolumePage.Text = "Volumenes”
$tabControl.Controls.Add($VolumePage)
$VolumePage.Controls.Add($outputBox)

 
 
 
 
############################################## Start group boxes
 
$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Location = New-Object System.Drawing.Size(10,10)
$groupBox.size = New-Object System.Drawing.Size(370,200)
$groupBox.text = "Selecione los volumenes a exportar Informacion"
 
#$existentVolumes = (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27)
$checkboxNumber = 0
$column = 0
$allVolumensPainted = $false
    for($y=1; $y -le 4; $y++){
       
        $column = $column + 40
        if ($allVolumensPainted -eq $true){break}
        #$checkboxNumber++
        $row = 0
        for($x=1; $x -le 7; $x++){
                if ($checkboxNumber -eq $existentVolumes.count){
                    $allVolumensPainted = $true
                    break
               
                }
               
                $variableNames = "checkbox" + $checkboxNumber
                $row = $row + 45
                write-output "Valor columna: " $column " Linea: " $row " Numero de items: " $checkboxNumber "Variable: " $variableNames
                $exportQuotaBox = New-Object System.Windows.Forms.checkbox
                $exportQuotaBox.Location = New-Object System.Drawing.Size($row,$column)
                $exportQuotaBox.Size = New-Object System.Drawing.Size(40,20)
                $exportQuotaBox.Text = $existentVolumes[$checkboxNumber]
                $exportQuotaBox.Name = $variableNames
                $VolumePage.Controls.Add($exportQuotaBox)
                $checkboxNumber++
                #$groupBox.Controls.Add($exportQuotaBox)
            }
 
 
    }
   
$checkboxNumber = 0
$column = 0
$allVolumensPainted = $false
$ArrayValuesMigrationTemplates = ('Quota Templates','FileScreen Templates','FileGroups','None')
    for($y=1; $y -le 2; $y++){
       
        $column = $column + 20
        #if ($allVolumensPainted -eq $true){break}
        #$checkboxNumber++
        $row = 0
        for($x=1; $x -le 2;$x++){
                #if ($checkboxNumber -eq $existentVolumes.count){
                #    $allVolumensPainted = $true
                #    break
               
                #}
                if ($x -eq 1) { $row = 40 }
                $variableNames = "OptionschkBox" + $checkboxNumber
                
                write-output "Valor columna: " $column " Linea: " $row " Numero de items: " $checkboxNumber "Variable: " $variableNames
                $exportQuotaBox = New-Object System.Windows.Forms.checkbox
                $exportQuotaBox.Location = New-Object System.Drawing.Size($row,$column)
                $exportQuotaBox.Size = New-Object System.Drawing.Size(140,20)
                $exportQuotaBox.Text = $ArrayValuesMigrationTemplates[$checkboxNumber]
                $exportQuotaBox.Name = $variableNames
                $groupBoxOptions.Controls.Add($exportQuotaBox)
                $checkboxNumber++
                $row = $row + 140
                #$groupBox.Controls.Add($exportQuotaBox)
            }
 
 
    }
   
$checkboxNumber = 0
$column = 0
$allVolumensPainted = $false
$ArrayValuesMigrationTemplates = ('Quotas','Auto Apply Quotas','FileScreen' , 'FileScreen Exceptions')
    for($y=1; $y -le 2; $y++){
       
        $column = $column + 20
        #if ($allVolumensPainted -eq $true){break}
        #$checkboxNumber++
        $row = 0
        for($x=1; $x -le 2; $x++){
                #if ($checkboxNumber -eq $existentVolumes.count){
                #    $allVolumensPainted = $true
                #    break
               
                
                if ($x-eq 1) { $row = 40 }
               
                $variableNames = "OptionschkBox" + $checkboxNumber
               
                write-output "Valor columna: " $column " Linea: " $row " Numero de items: " $checkboxNumber "Variable: " $variableNames
                $exportQuotaBox = New-Object System.Windows.Forms.checkbox
                $exportQuotaBox.Location = New-Object System.Drawing.Size($row,$column)
                $exportQuotaBox.Size = New-Object System.Drawing.Size(140,20)
                $exportQuotaBox.Text = $ArrayValuesMigrationTemplates[$checkboxNumber]
                $exportQuotaBox.Name = $variableNames
                $groupBoxOptions1.Controls.Add($exportQuotaBox)
                $checkboxNumber++
                #}
                $row = $row + 140
                #$groupBox.Controls.Add($exportQuotaBox)
            }
 
 
    }
   
$checkboxNumber = 0
$column = 0
$allVolumensPainted = $false
$ArrayValuesMigrationTemplates = ('NTFS Permissions','Shares Permissions')
    for($y=1; $y -le 1; $y++){
       
        $column = $column + 20
        #if ($allVolumensPainted -eq $true){break}
        #$checkboxNumber++
        $row = 0
        for($x=1; $x -le 2; $x++){
                #if ($checkboxNumber -eq $existentVolumes.count){
                #    $allVolumensPainted = $true
                #    break
               
                
                if ($x-eq 1) { $row = 40 }
               
                $variableNames = "OptionschkBox" + $checkboxNumber
               
                write-output "Valor columna: " $column " Linea: " $row " Numero de items: " $checkboxNumber "Variable: " $variableNames
                $exportQuotaBox = New-Object System.Windows.Forms.checkbox
                $exportQuotaBox.Location = New-Object System.Drawing.Size($row,$column)
                $exportQuotaBox.Size = New-Object System.Drawing.Size(140,20)
                $exportQuotaBox.Text = $ArrayValuesMigrationTemplates[$checkboxNumber]
                $exportQuotaBox.Name = $variableNames
                $groupBoxOptions2.Controls.Add($exportQuotaBox)
                $checkboxNumber++
                #}
                $row = $row + 140
                #$groupBox.Controls.Add($exportQuotaBox)
            }
 
 
    }
 
$global:checkBoxNumbers = $checkboxNumber
 
 
$ButtonExport = New-Object System.Windows.Forms.Button
$ButtonExport.Location = New-Object System.Drawing.Size(15,470)
$ButtonExport.Size = New-Object System.Drawing.Size(400,50)
$ButtonExport.Text = "Export Configuration Files"   
$ButtonExport.Add_Click({




        $global:ExportVolumenes  = @()
        $VolumenPageGroupBox = $OptionsPage.Controls #| where{$_.AccessibilityObject -match "System.Windows.Forms.GroupBox" }
        write-host $VolumenPageGroupBox.count
        foreach ($groupInVolumenPage in $VolumenPageGroupBox){
            $VolumenCheckBoxesInPage = $groupInVolumenPage.Controls | where{$_.AccessibilityObject -match "System.Windows.Forms.CheckBox" }
            foreach($VolumenCheckBoxes in $VolumenCheckBoxesInPage ){
                if ($VolumenCheckBoxes.checked){
                    $global:ExportVolumenes += $VolumenCheckBoxes.text
                }
            }
        }
        #$chk.name = "checkbox30"
       
    write-host "Checkbox selected: " $global:ExportOptionsButtons




    if (!$textBox1.Text) 
    {
        $outputBox.AppendText("`nPlease select a folder, where the configuration files will be located");$outputBox.ScrollToCaret()
    }
    else
    {


        if((Test-Path $($textBox1.Text)) -eq $true )
        {



            foreach ($item in $global:ExportOptionsButtons)
            {
        
                    switch ($item)
                    {
     
     
                        'Quota Templates' {$outputBox.AppendText($(Export-QuotaTemplates -Destinationfolder "c:\empty"));$outputBox.ScrollToCaret()}
                        'FileScreen Templates' {$outputBox.AppendText($(Export-FileScreenTemplates -Destinationfolder "c:\empty"));$outputBox.ScrollToCaret()}
                        'FileGroups' {$outputBox.AppendText($(Export-FileGroupsTemplates -Destinationfolder "c:\empty"));$outputBox.ScrollToCaret()}
                        'Auto Apply Quotas' {}
                        'FileScreen' {}
                        'Exceptions' {}
                        'NTFS Permissions' {}
                        'Shares Permissions' {Export-sharesToFile -FileRepositoryPath -volumens }
     
                    }
            }

        }
        else 
        {
            $outputBox.AppendText("`nPlease select a existing folder location");$outputBox.ScrollToCaret()
        }
      }
}) 




$Form.Controls.Add($ButtonExport)
$OptionsPage.Controls.Add($groupBoxOptions0)
$OptionsPage.Controls.Add($groupBoxOptions)
$OptionsPage.Controls.Add($groupBoxOptions1)
$OptionsPage.Controls.Add($groupBoxOptions2)
$OptionsPage.Controls.Add($ButtonOptionsChk)
$VolumePage.Controls.Add($groupBox)
$form.Controls.Add($tabControl)
 
$form.ShowDialog();
write-host "Checkbox Seleccionados: " $global:checkedButtons "Numeros de checkbuttons: " $global:checkBoxNumbers "ExportOptions: " $global:ExportOptionsButtons
#>

