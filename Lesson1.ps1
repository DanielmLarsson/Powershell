
#Enter a First name to search for
$NameToSearchFor = Read-Host "Please enter Name and Lastname to search for:"
#FetchAllADUsers
#$AllAdUsers = Get-ADUser -Filter * 
$AllAdUsers = Get-ADUser -Filter * 
#Writes all AD Users to console
#Write-Host $AllAdUsers
#Variable to save amount of matches in
$AmountOfMatches = 0;
#Loop through all users in AllADUsers
ForEach($user in $AllAdUsers)
{
    #Test
    #Write-Host "User.Name is : " $user.Name

    #Checksif FirstName is same
    if($user.GivenName -eq $NameToSearchFor)
    {    
        $AmountOfMatches++;
    }

}
#Writes amount of matches
if($AmountOfMatches -gt 10)
{
#Writes green background if it is above 10
    Write-host $AmountOfMatches -BackgroundColor Green
}else{
    Write-host $AmountOfMatches
}








