#First iteration of this script
#Simple countdown from 50 min(3000 seconds)

$quit = $false

do
{

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$script:timeEnd = 3000

$script:runTimer
#MainForm code
$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Text = 'HealthyAlarms'
$mainForm.Width = 600
$mainForm.Height = 400
$mainForm.AutoSize = $true
$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Alarm"
$Label.Location = New-Object System.Drawing.Point(300,10)
$Label.AutoSize = $true
$mainForm.Controls.Add($Label)

$LabelTimeName = New-Object System.Windows.Forms.Label
$LabelTimeName.Text = "Time"
$LabelTimeName.Location = New-Object System.Drawing.Point(300,30)
$LabelTimeName.AutoSize = $true
$mainForm.Controls.Add($LabelTimeName)

$LabelTime = New-Object System.Windows.Forms.Label
$LabelTime.Text = "Timer not started yet"
$LabelTime.Location = New-Object System.Drawing.Point(300,50)
$LabelTime.AutoSize = $true
$mainForm.Controls.Add($LabelTime)

$ButtonStart = New-Object System.Windows.Forms.Button
$ButtonStart.Location = New-Object System.Drawing.Size(200,100)
$ButtonStart.Size = New-Object System.Drawing.Size(100,25)
$ButtonStart.Text = "Start"
$mainForm.Controls.Add($ButtonStart)

$ButtonPause = New-Object System.Windows.Forms.Button
$ButtonPause.Location = New-Object System.Drawing.Size(300,100)
$ButtonPause.Size = New-Object System.Drawing.Size(100,25)
$ButtonPause.Text = "Pause"
$mainForm.Controls.Add($ButtonPause)

$ButtonReset = New-Object System.Windows.Forms.Button
$ButtonReset.Location = New-Object System.Drawing.Size(400,100)
$ButtonReset.Size = New-Object System.Drawing.Size(100,25)
$ButtonReset.Text = "Reset"
$mainForm.Controls.Add($ButtonReset)

$ButtonQuit = New-Object System.Windows.Forms.Button
$ButtonQuit.Location = New-Object System.Drawing.Size(500,300)
$ButtonQuit.Size = New-Object System.Drawing.Size(100,25)
$ButtonQuit.Text = "Quit"
$mainForm.Controls.Add($ButtonQuit)


$ButtonStart.Add_Click(
{
    $script:runTimer = $true
    $mainForm.Controls.Remove($ButtonStart)
    $mainForm.Controls.Remove($ButtonPause)
    $mainForm.Controls.Remove($ButtonReset) 
    $mainForm.Visible = $false   
    Write-Host "We ran buttonstart"  
}
)

$ButtonPause.Add_Click(
{
$script:runTimer = $false
$LabelTime.Text = "We paused at " +$script:timeEnd/60 +" minutes" +" or " +$script:timeEnd +" seconds."
}
)

$ButtonReset.Add_Click(
{
$script:runTimer = $false
$script:timeEnd =  3000;
$LabelTime.Text = "We reset time and timeEnd is " +$script:timeEnd

}
)

$ButtonQuit.Add_Click(
{
#exits since we pressed quit
 $quit = $true
 #Close application since we pressed quit
 [System.Environment]::Exit(0) 
}
)

   Write-Host "We running ShowDialog"
  $mainform.ShowDialog()  

Write-Host "runTimer is " +$script:runTimer
while ($script:timeEnd -ge 0 -and $script:runTimer -eq $true)
{ 
  $mainForm.Visible = $false    
  $mainform.Show()
 
  Write-Host "timeEnd is " $script:timeEnd 
  $LabelTime.Text = "Your break is in " +$script:timeEnd/60 +" minutes or " +$script:timeEnd +" seconds"
  
  if ($script:timeEnd -lt 5)
  { 
     $LabelTime.ForeColor = "Red"
     $fontsize = 20-$timeEnd
     $warningfont = New-Object System.Drawing.Font("Times New Roman",$fontsize,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold -bor [System.Drawing.FontStyle]::Underline))
     $LabelTime.Font = $warningfont
  }
  
 start-sleep 1
 $script:timeEnd -= 1 

}

if($script:timeEnd -le 0)
  { 
    $mainForm.Visible = $false        
    $mainForm.Controls.Add($ButtonStart)
    $mainForm.Controls.Add($ButtonPause)
    $mainForm.Controls.Add($ButtonReset)      
    Write-Host "We are less or equal to 0"
  }
  
}while($quit -eq $false)





