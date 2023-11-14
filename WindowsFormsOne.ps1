#Script that lets a user choose a file to copy content.
#Then choose a second file to paste the content to the second file
#User may also reset or exit the program by pressing on those buttons

Add-Type -AssemblyName System.Windows.Forms

#variables
$script:takeFileInfo

#All the Form code.
$Form = New-Object System.Windows.Forms.Form
$ButtonChooseFile = New-Object System.Windows.Forms.Button
$ButtonChooseFile.Location = New-Object System.Drawing.Size(35,35)
$ButtonChooseFile.Size = New-Object System.Drawing.Size(180,25)
$ButtonChooseFile.Text = "Choose File to take content"
$ButtonChooseFile.Add_Click($function:ChooseFile)
$ButtonChooseFile.Visible = $true
$Form.Controls.Add($ButtonChooseFile)

$ButtonChooseSave = New-Object System.Windows.Forms.Button
$ButtonChooseSave.Location = New-Object System.Drawing.Size(35,35)
$ButtonChooseSave.Size = New-Object System.Drawing.Size(180,25)
$ButtonChooseSave.Text = "Choose File to save content in"
$ButtonChooseSave.Add_Click($function:ChooseFileToSaveIn)
$ButtonChooseSave.Visible = $true
$Form.Controls.Add($ButtonChooseSave)

$LabelDone = New-Object System.Windows.Forms.Label
$LabelDone.Location = New-Object System.Drawing.Size(35,70)
$LabelDone.Size = New-Object System.Drawing.Size(180,25)
$LabelDone.Text = "We saved content into the file!"
$LabelDone.Visible = $false
$Form.Controls.Add($LabelDone)

$ButtonChooseRestart = New-Object System.Windows.Forms.Button
$ButtonChooseRestart.Location = New-Object System.Drawing.Size(120,200)
$ButtonChooseRestart.Size = New-Object System.Drawing.Size(160,25)
$ButtonChooseRestart.Text = "Restart Script"
$ButtonChooseRestart.Add_Click($function:ChooseRestart)
$ButtonChooseRestart.Visible = $true
$Form.Controls.Add($ButtonChooseRestart)

$ButtonChooseExit = New-Object System.Windows.Forms.Button
$ButtonChooseExit.Location = New-Object System.Drawing.Size(35,200)
$ButtonChooseExit.Size = New-Object System.Drawing.Size(80,25)
$ButtonChooseExit.Text = "Exit Script"
$ButtonChooseExit.Add_Click($function:ChooseExit)
$ButtonChooseExit.Visible = $true
$Form.Controls.Add($ButtonChooseExit)

$Form.ShowDialog()





#Functions to use in script
function ChooseFile()
{
$fileBrowser = New-Object System.Windows.Forms.OpenFileDialog
$fileBrowser.InitialDirectory =[Environment]::GetFolderPath('Desktop') 
$fileBrowser.Filter = 'Text files (*.txt)|*.txt'
 
$fileBrowserDialog = $fileBrowser.ShowDialog()

if($fileBrowserDialog -eq [System.Windows.Forms.DialogResult]::Cancel)
{
#User pressed cancel
Write-Host "ChooseFile: User pressed Cancel"

}else
{
    #1 take content of file
    $script:takeFileInfo = Get-Content $fileBrowser.FileName -Raw

    $ClickedButtonOne = $true
   # Write-Host "ClickedButtonOne is " $ClickedButtonOne

    #ButtonVisibleCode
    if($ClickedButtonOne = $false)
    {
    #Since we haven´t clicked button, set visible to true.
    $ButtonChooseFile.Visible = $true
    #Write-Host "buttonchoosefile is visible"
    }else{
    #Else we clicked button so set it to false
    $ButtonChooseFile.Visible = $false
   # Write-Host "buttonchoosefile is not visible"
    }

}

}



function ChooseFileToSaveIn()
{
#2 choose second file
$chooseSaveSpot = New-Object System.Windows.Forms.OpenFileDialog
$chooseSaveSpot.InitialDirectory =[Environment]::GetFolderPath('Desktop') 
$chooseSaveSpot.Filter = 'Text files (*.txt)|*.txt'

$chooseSaveSpotDialog = $chooseSaveSpot.ShowDialog()

if($chooseSaveSpotDialog -eq [System.Windows.Forms.DialogResult]::Cancel)
{
#User pressed cancel
Write-Host "ChooseFileToSaveIn: User pressed Cancel"

}else
{
    $ClickedButtonTwo = $true
    #Write-Host "ClickedButtonTwo is " $ClickedButtonTwo

    #ButtonVisibleCode
    if($ClickedButtonTwo = $false)
    {
    #Since we haven´t clicked button, set visible to true.
    $ButtonChooseSave.Visible = $true
   # Write-Host "buttonchoosesave is visible"
    }else{
    #Else we clicked button so set it to false
    $ButtonChooseSave.Visible = $false
   # Write-Host "buttonchoosesave is not visible"
    }

    #Call to save file function
    Save-File
}
}

function Save-File()
{
#3 save path in variable
$pathOfSaveSpot = $chooseSaveSpot.FileName
Write-Host "Path of saveSpot is:" $pathOfSaveSpot
Write-Host "Info of takeFileInfo is:" $takeFileInfo
#4 save content in the second file
$script:takeFileInfo | Set-Content -Path $pathOfSaveSpot

$LabelDone.Visible = $true
}

function ChooseExit()
{
$Form.Close()

}

function ChooseRestart()
{
#If we pressed the restartButton
#Reset all variables to default
Write-Host "We reset all variables"
$script:takeFileInfo = "reset"
$ButtonChooseFile.Visible = $true
$ButtonChooseSave.Visible = $true
$LabelDone.Visible = $false
$Form.Refresh()
}


