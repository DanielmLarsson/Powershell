function Start-ScheduledTaskCert
{
Param([parameter(Mandatory=$false)] $time)

#Task variables
$certTrigger = New-ScheduledTaskTrigger -Daily -At 0am
$certSettings = New-ScheduledTaskSettingsSet
$certAction = New-ScheduledTaskAction -Execute 'powershell.exe' -WorkingDirectory "C:\temp" -Argument '-NonInteractive -NoLogo -NoProfile -Command " .\LessonA3ForTask.ps1' 
$certTask = New-ScheduledTask -Action $certAction -Trigger $certTrigger -Settings $certSettings

#create the task
Register-ScheduledTask -TaskName 'Cert Check Daily Run' -InputObject $certTask

}

Start-ScheduledTaskCert 