[reflection.assembly]::LoadWithPartialName("System.Windows.Forms")|Out-Null

$basicForm = New-Object System.Windows.Forms.Form
$basicForm.Size = '350,250'
#$basicForm.BackColor = '0,0,0'
$basicForm.Text = 'SLS GCode Conversion Tool'




$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    Multiselect = $false
	Filter = 'Gcode Files (*.gcode, *.gco)|*.gcode;*.gco'
}

$introText =  New-Object System.Windows.Forms.Label
$introText.Text = 'Use this tool to convert a standard gcode file into something that works on the SLS machine'
$introText.Location = '20,10'
$introText.Size = '310,30'
$basicForm.Controls.Add($introText)

$powerText = New-Object System.Windows.Forms.TextBox
$powerText.Location = '23,45'
$powerText.Size = '150,23'
$basicForm.Controls.Add($powerText)

$powerLabel = New-Object System.Windows.Forms.Label
$powerLabel.Text = 'Enter laser power(0-255)'
$powerLabel.Location = '190,45'
$powerLabel.Size = '100,40'
$basicForm.Controls.Add($powerLabel)

$pathTectBox = New-Object System.Windows.Forms.TextBox
$pathTectBox.ReadOnly = $true
$basicForm.Controls.Add($pathTectBox)
$pathTectBox.Location = '23,85'
$pathTectBox.Size = '150,23'

$SelectFile = New-Object System.Windows.Forms.Button
$SelectFile.Text = 'Select GCode File'
$SelectFile.Size = '120,23'
$SelectFile.Add_click({
    $FileBrowser.ShowDialog()
    $pathTectBox.Text = $FileBrowser.FileName


})
$SelectFile.Location = '190,85'
$basicForm.Controls.Add($SelectFile)

$noteText = New-Object System.Windows.Forms.Label
$noteText.Text = 'Note: This window will close when complete'
$noteText.Location = '90,150'
$noteText.Size = '100,40'
$basicForm.Controls.Add($noteText)

$applyButton = New-Object System.Windows.Forms.Button
$applyButton.location = '200,150'
$applyButton.Text = 'Apply'
$applyButton.Add_Click({
$Power= $powerText.Text
$gcode= $pathTectBox.Text
$pathTectBox.Text
$powerText.Text


(Get-Content $gcode).replace('E-', '
M107 P0;') | Set-Content $gcode

(Get-Content $gcode).replace('E', '
M42 P4 S###;') | Set-Content $gcode

(Get-Content $gcode).replace('###', $Power) | Set-Content $gcode

(Get-Content $gcode).replace('QQQQ', '
G28 Y0
G91
M280 P0 S70
G0 Y170 E1200 F3600
M400
M280 P0 S0
G90
') | Set-Content $gcode

})
$basicForm.Controls.Add($applyButton)

$basicForm.CancelButton = $applyButton
$basicForm.ShowDialog()










