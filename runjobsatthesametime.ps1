#Start jobs and run the functions at the sametime
#we count from 0 up to 100 or 200 and in 1 or 2 steps at a time.
$count=0
$countTwo=0
$countToThis = 100
$countToThisTwo = 200

function counter
{param($count, $countToThis)
   Write-Host "counter is:" $count "counttothis is " $countToThis

   while($count -lt $countToThis)
{
   $count ++ 
   Write-Host "count is:" +$count
}   
    #return result
    return $count
}

function counterTwo
{param($countTwo, $countToThisTwo)
   Write-Host "counter is:" $count "counttothis is " $countToThis
while($countTwo -lt $countToThisTwo)
{
   $countTwo += 2
   Write-Host "countTwo is:" +$countTwo
}   
    #return result
    return $countTwo
}

#Start jobs
$job1 = Start-Job -ScriptBlock ${Function:counter} -ArgumentList $count, $countToThis 
$job1Receive = $job1 | Get-Job |Receive-Job -Wait

$job2 = Start-Job -ScriptBlock ${Function:counterTwo} -ArgumentList $countTwo, $countToThisTwo 
$job2Receive = $job2 | Get-Job | Receive-Job -Wait

#Write out the results
Write-Host "Job1 is " $job1 "job1Receive" $job1Receive
Write-Host "Job2 is " $job2 "job2Receive" $job2Receive

#Remove Jobs
Remove-Job $job1
Remove-Job $job2


