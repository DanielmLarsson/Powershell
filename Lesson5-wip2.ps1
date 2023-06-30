<#
[relection.assembly]::loadwithpartialname("microsoft.visualbasic") | Out-Null

#Asking for input in our box
$ValueFromInputBox = [Microsoft.VisualBasic.Interaction]::InputBox("Enter Username to search for here","FindNestedADGroups tool", 0)
$UserWeLookedAfter = Get-FindADUser

#Find ADUser
function Get-FindADUser()
{  
#Get-ADUser -Filter {name -like '$ValueFromInputBox'} | Format-Table SamAccountName 

    try {
      Get-ADUser -Identity $ValueFromInputBox
      Write-Host User exists
      $UserExists = $true
      Write-Host We run NestedADGroups
      Get-NestedADGroups $ValueFromInputBox

    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityResolutionException] {
      Write-Host "User does not exist."
      $UserExists = $false
    }
}
#>

function Get-NestedADGroups()
{
Param([parameter(Mandatory=$true)] $searchString, 
    [parameter(Mandatory=$false)] $grouphash = @{})
$results=@()
#Find searchString
$searchStringGroup = Get-ADGroup -Identity $searchString
#Find Groups searchString is member of
$groupHash = Get-ADGroupMember -Identity $searchStringGroup  | Select-Object SamAccountName, ObjectClass

#Write-Host $grouphash
#For each group in groups found
ForEach($group in $groupHash)
{
#Write-Host within loop
    #If a user, do nothing
   if($group.objectClass -eq 'user')
   {   
   }else
   {   
    #If a group       
    $results += $group  
    Write-Host $results
      if($group -in $results){            
      #Find Groups in Group:
      $nestedGroups = Get-NestedADGroups $group.SamAccountName $groupHash
      $results += $nestedGroups          
    }  

   }
}
   
Write-Host $results
#Write out nested groups
#Write-Host $grouphash


}

Get-NestedADGroups TestGroup

#Get-NestedADGroups testad
#Get-FindADUser





