

#Find ADUser

function Get-FindADUser()
{  

    
    
    
   # $userName = 
    #Get-ADUser -Filter {name -like 'testad'} | Format-Table SamAccountName
   

    
}



function Get-NestedADGroups()
{
#Get user
$username = Get-ADUser -Identity testad | Select-Object SamAccountName
Write-Host $userName.SamAccountName

#Find Groups user is member of
#$groupsOfADGroups = Get-ADPrincipalGroupMembership -Identity $userName.SamAccountName | select name,groupscope
$groupsOfADGroups = Get-ADPrincipalGroupMembership -Identity $userName.SamAccountName | Select-Object Name

 #Write out first found groups   
    $tempString = $groupsOfADGroups | Out-String
    Write-Host $tempString

#For each name in groups found
ForEach($name in $groupsOfADGroups)
{
    Write-Host name is $name
    #Find Groups in Group:
    Get-ADGroupMember -Identity $name | where-object {$_.objectClass -eq 'group'} | Select-Object Name

  
        
}

}

#Get-FindADUser
Get-NestedADGroups TestGroup



