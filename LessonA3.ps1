
function Get-ExpiringCertificates
{
Param([parameter(Mandatory=$true)] $months)


#Calculate Months to days
#Current Month
$DaysInMonthOne = [datetime]::DaysInMonth((Get-Date).Year,(Get-Date).Month)
#NextMonth
$DaysInMonthTwo = [datetime]::DaysInMonth((Get-Date).Year,(Get-Date).AddMonths(1).Month)
#LastMonth
$DaysInMonthThree = [datetime]::DaysInMonth((Get-Date).Year,(Get-Date).AddMonths(2).Month)
#CombineDays
$DaysTotalInThreeMonths = $DaysInMonthOne+$DaysInMonthTwo+$DaysInMonthThree

Write-Host "DaysTotalInThreeMonths is " $DaysTotalInThreeMonths

#Check certificates that will expire in next X months
$AllLocalCertificates = Get-ChildItem Cert:\LocalMachine\ -Recurse -ExpiringInDays $DaysTotalInThreeMonths


Write-Host "Certificates that will expire in " $months "months, which is" $DaysTotalInThreeMonths "days"
foreach($Certificate in $AllLocalCertificates)
{
#Write out the certificates
Write-Host $Certificate | Select-Object FriendlyName, Subject

}

}

Get-ExpiringCertificates -months 3