
#Get all users with given name
function Get-UsersWithName()
{
#Parameter for Name
param ([String]$Name)

#Store all AD Users in a variable
    $AllADUsers = Get-ADUser -Filter *
    #Counted users
    $UserCount 

    #Save Found Users in array variable
    $FoundUsers = @()
    #Loop through all users
    ForEach($user in $AllADUsers)
    {
    
    #Check if given name is the same
        if($user.GivenName -eq $Name)
        {
            #Save user in variable
            $FoundUsers+=$user
            $UserCount+=1                                 
        }     
        
        
    }
    #After for loop ends, write number
    Write-Host Users with name is $UserCount
    #Sort found users in ascending order of Surname
    $SortedUsers = $FoundUsers | Sort-Object -Property @{Expression = "Surname"; Descending = $true}    
    #Loop through Sorted Users
    ForEach($user in $SortedUsers)
    {
          #Write out user
          Write-Host $user.GivenName, $user.Surname 
    }

     

}
Get-UsersWithName -Name "Adam" 