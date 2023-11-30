#Third iteration of this script
#Simple countdown from 50 min(3000 seconds)
#Can now also press buttons to start, pause or continue and reset script.
#Shows different fonts depending on the time.
#Now also plays a sound at breaktime.
#Now calls alarm at foodtime. Also says when next food alarm is.

$quit = $false

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$script:timeEnd = 10
do
{
$script:timerRunning = $false
#MainForm code
$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Text = 'HealthyAlarms'
$mainForm.Width = 600
$mainForm.Height = 400
$mainForm.AutoSize = $true

$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Alarm"
$Label.Location = New-Object System.Drawing.Point(300,0)
$Label.AutoSize = $true
$mainForm.Controls.Add($Label)

#timer status label
$LabelTimeStatus = New-Object System.Windows.Forms.Label
$LabelTimeStatus.Text = "Timer not started yet."
$LabelTimeStatus.Location = New-Object System.Drawing.Point(300,40)
$LabelTimeStatus.AutoSize = $true
$mainForm.Controls.Add($LabelTimeStatus)

#Actual timer label
$LabelTime = New-Object System.Windows.Forms.Label
$LabelTime.Text = "Press start to countdown from 50 minutes"
$LabelTime.Location = New-Object System.Drawing.Point(300,60)
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

$ButtonContinue = New-Object System.Windows.Forms.Button
$ButtonContinue.Location = New-Object System.Drawing.Size(300,100)
$ButtonContinue.Size = New-Object System.Drawing.Size(100,25)
$ButtonContinue.Text = "Continue"
$mainForm.Controls.Add($ButtonContinue)

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


function resetFont
{
  #Resets the font to countdown font
  $LabelTime.ForeColor = "Black"
  $fontsizeOne = 10
  $firstfont = New-Object System.Drawing.Font("Lucida",$fontsizeOne,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Regular))
  $LabelTime.Font = $firstfont
}

#Timercodestart
function timerStart
{
Write-Host "running timerstart, timeEnd = " $script:timeEnd

while ($script:timeEnd -gt 0 -and $script:timerRunning -eq $true)
{ 
  
  Write-Host "timeEnd is " $script:timeEnd 
  $LabelTime.Text = "Your break is in " +$script:timeEnd/60 +" minutes or " +$script:timeEnd +" seconds"
  $LabelTimeStatus.Text = "Timer running"    

  [System.Windows.Forms.Application]::DoEvents() 

  if($script:timeEnd -gt 5)
  {
        resetFont   
  }

  if ($script:timeEnd -lt 5)
  { 
     $LabelTime.ForeColor = "Red"
     $fontsize = 20-$timeEnd
     $warningfont = New-Object System.Drawing.Font("Arial",$fontsize,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold -bor [System.Drawing.FontStyle]::Underline))
     $LabelTime.Font = $warningfont

     if ($script:timeEnd -eq 0)
   { 
        [System.Media.SystemSounds]::Beep.Play()
   }

  }
  
   

 start-sleep 1
 $script:timeEnd -= 1 
 
}

if($script:timeEnd -le 0)
  {     
    Write-Host "We are less or equal to 0"
    
    $LabelTime.Text = "Your break is now!"
    $LabelTimeStatus.Text = "Press Reset to restart script."   
    
  }

}
#Timercodeend

#Button Event code
$ButtonStart.Add_Click(
{    
#This happen when we press Start
    $mainForm.Controls.Remove($ButtonStart)    
    Write-Host "We ran buttonstart" 
    $script:timerRunning = $true    
    #Start timer
    timerStart       
}
)

$ButtonPause.Add_Click(
{
#This happen when we press Pause
 $LabelTimeStatus.Text = "We paused at " +$script:timeEnd/60 +" minutes" +" or " +$script:timeEnd +" seconds."
 $LabelTime.Text = "Press continue to resume countdown"
 $script:timerRunning = $false
 #Remove pause button
 $mainForm.Controls.Remove($ButtonPause)
 #Remove start button
 $mainForm.Controls.Remove($ButtonStart)
 #Add continue button
 $mainForm.Controls.Add($ButtonContinue)
}
)

$ButtonReset.Add_Click(
{
#This happen when we press Reset
$script:timerRunning = $false
$script:timeEnd =  10;
resetFont
$LabelTimeStatus.Text = "We reset time and timeEnd is " +$script:timeEnd +"(50 minutes)"
$LabelTime.Text = "Press start to countdown from 50 minutes"
#Add start button
$mainForm.Controls.Add($ButtonStart)
#Add pause button
$mainForm.Controls.Add($ButtonPause)
#remove continue button
$mainForm.Controls.Remove($ButtonContinue)
}
)

$ButtonContinue.Add_Click(
{
#This happen when we press Continue
$script:timerRunning = $true
$LabelTimeStatus.Text = "We started countdown again"
#Add pause button
$mainForm.Controls.Add($ButtonPause)
#remove continue button
$mainForm.Controls.Remove($ButtonContinue)
#start timer again
timerStart
}
)

$ButtonQuit.Add_Click(
{
#This happen when we press Quit
#exits since we pressed quit
 $quit = $true
 #Close application since we pressed quit
 [System.Environment]::Exit(0) 
}
)

#Food Alarm code start
#Food status label
$LabelFoodStatus = New-Object System.Windows.Forms.Label
$LabelFoodStatus.Text = "Next food at:"
$LabelFoodStatus.Location = New-Object System.Drawing.Point(120,40)
$LabelFoodStatus.AutoSize = $true
$mainForm.Controls.Add($LabelFoodStatus)

#Food Time label
$LabelFoodTime = New-Object System.Windows.Forms.Label
$LabelFoodTime.Text = $nextAlarm
$LabelFoodTime.Location = New-Object System.Drawing.Point(120,60)
$LabelFoodTime.AutoSize = $true
$mainForm.Controls.Add($LabelFoodTime)

#Label above alarmsinfo
$LabelFoodAbove = New-Object System.Windows.Forms.Label
$LabelFoodAbove.Text = "Alarms call at times:"
$LabelFoodAbove.Location = New-Object System.Drawing.Point(0,30)
$LabelFoodAbove.AutoSize = $true
$mainForm.Controls.Add($LabelFoodAbove)

#All Food Alarm times
$LabelFoodAlarmsInfo = New-Object System.Windows.Forms.ListBox
$LabelFoodAlarmsInfo.Location = New-Object System.Drawing.Point(0,60)
$LabelFoodAlarmsInfo.AutoSize = $true
$LabelFoodAlarmsInfo.Height = 100

[void] $LabelFoodAlarmsInfo.Items.Add(11)
[void] $LabelFoodAlarmsInfo.Items.Add(13)
[void] $LabelFoodAlarmsInfo.Items.Add(16)
[void] $LabelFoodAlarmsInfo.Items.Add(18)
[void] $LabelFoodAlarmsInfo.Items.Add(21)

$mainForm.Controls.Add($LabelFoodAlarmsInfo)



function FoodTimer
{

Write-Host "Current hour is: " (Get-Date).Hour
#If less then 11
if((Get-Date).Hour -lt 11)
{
$nextAlarm = 11
#Do nothing
Write-Host "Time before 11, do nothing."
}
#If less then 22, check for alarms
if((Get-Date).Hour -lt 22 -and (Get-Date).Hour -ge 11)
{

If((Get-Date).Hour -ge 11 -and (Get-Date).Hour -lt 13)
{
[System.Media.SystemSounds]::Asterisk.Play()
$nextAlarm = 13
Write-Host "Time is 11 and we set next alarm to 13"
}

If((Get-Date).Hour -eq 13  -and (Get-Date).Hour -lt 16)
{
[System.Media.SystemSounds]::Asterisk.Play()
$nextAlarm = 16
}

If((Get-Date).Hour -eq 16 -and (Get-Date).Hour -lt 18)
{
[System.Media.SystemSounds]::Asterisk.Play()
nextAlarm = 18
}

If((Get-Date).Hour -eq 18 -and (Get-Date).Hour -lt 21)
{
[System.Media.SystemSounds]::Asterisk.Play()
$nextAlarm = 21
}

If((Get-Date).Hour -eq 21 -and (Get-Date).Hour -lt 24)
{
[System.Media.SystemSounds]::Asterisk.Play()
$nextAlarm = 11
}

}

#Update label at end
$LabelFoodTime.Text = $nextAlarm

}
#Food Alarm code end    


#Call FoodTimer code
FoodTimer
Write-Host "We running ShowDialog"
$mainform.ShowDialog()
   

}while($quit -eq $false)





