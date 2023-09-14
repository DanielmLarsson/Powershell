
function Get-ExpiringCertificates
{
Param([parameter(Mandatory=$true)] $months)



#Calculate Months to days
$MonthsChecked = 0;
$DaysInMonthAddedTogether = 0

while($MonthsChecked -le $months)
{


#if check is zero
if($MonthsChecked -eq 0){
    #Current Month
    $DaysInMonth = [datetime]::DaysInMonth((Get-Date).Year,(Get-Date).Month)
    #Add to check
    $MonthsChecked++
}

#If check is less or equal to
if($MonthsChecked -le $months)
{
$NextDaysInMonth = [datetime]::DaysInMonth((Get-Date).Year,(Get-Date).AddMonths($MonthsChecked).Month)
#Add days to total count
$DaysInMonthAddedTogether +=$NextDaysInMonth
#Add to check
$MonthsChecked++
}
}


#Write-Host "DaysTotalCombined is " $DaysInMonthAddedTogether

#Check certificates that will expire in next X months
$AllLocalCertificates = Get-ChildItem Cert:\LocalMachine\ -Recurse -ExpiringInDays $DaysInMonthAddedTogether | Format-Table -AutoSize | Out-String



Write-Host "Certificates that will expire in " $months "months, which is" $DaysInMonthAddedTogether "days"


foreach($Certificate in $AllLocalCertificates)
{
#Write out the certificates
Write-Host $Certificate | Select-Object FriendlyName, Subject

}

}

#Get-ExpiringCertificates -months 200
Get-ExpiringCertificates -months 200 *> c:\temp\TaskLog.txt