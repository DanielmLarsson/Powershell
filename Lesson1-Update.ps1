
#Enter a First name to search for
$NameToSearchFor = Read-Host "Please enter Given Name to search for"
#FetchAllADUsers
#$AllAdUsers = Get-ADUser -Filter * 
$AllAdUsers = Get-ADUser -Filter * 
#Writes all AD Users to console
#Write-Host $AllAdUsers
#Variable to save amount of matches in
$AmountOfMatches = 0;
#Variable to save the matches in
$FoundUsers = @()
#Loop through all users in AllADUsers
ForEach($user in $AllAdUsers)
{
    #Test
    #Write-Host "User.Name is : " $user.Name

    #Checksif FirstName is same
    if($user.GivenName -eq $NameToSearchFor)
    {    
        $AmountOfMatches++;
        $FoundUsers += $user
    }

}
#Writes amount of matches
if($AmountOfMatches -gt 10)
{
#Writes green background if it is above 10    
    Write-host $AmountOfMatches -BackgroundColor Green matches found with first name $NameToSearchFor ":"
    ForEach($user in $FoundUsers)
    {
       Write-Host $user.GivenName , $user.Surname
    }
}else{
    Write-host $AmountOfMatches matches found with first name $NameToSearchFor":"
    ForEach($user in $FoundUsers)
    {
       Write-Host $user.GivenName , $user.Surname
    }

}








