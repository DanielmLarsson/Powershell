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

#Next is step 5, haven't started.

$UserWeLookedAfter = "Nisse"
$UserRunningScript = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
#variable
$results = [System.Collections.ArrayList]::new()
    
function Get-NestedADGroups()
{
Param([parameter(Mandatory=$true)] $searchString,  
    [parameter(Mandatory=$false)] $user)

#Find group from name
$findGroup = Get-ADGroup -Identity $searchString -Properties CN | Select-Object -ExpandProperty CN
#Write-Host $findGroup

#Find groups that one is a member of
$groupsInFindGroup = Get-ADGroupMember -Identity $findGroup |?{$_.objectClass -eq "Group"}| Get-ADGroup | Select-Object -ExpandProperty Name
#Write-Host $groupsInFindGroup 

    #We check through each object in $groupsInFindGroup
    Foreach($group in $groupsInFindGroup)
    {
        #Write-Host "Recursive check Group is:" $group
       
        #If the $group already is in results
        if($results -contains $group)
        {
             
        }else
        {
        #we add group to results since it wasn't there
        [void]$results.Add($group)
        
        #Write-Host "Results in loop is" $results     

        #We call the Get-NestedADGroups recursive to go through each group level
        $nestedGroups = Get-NestedADGroups $group
        }

        
    }


#Write out the results
Write-Output $results | Format-Table | Sort-Object -Property Name -Descending
#Write-Host "Results out of loop is" $results 

Write-Log -TextString "User running script $UserRunningScript is running script to find NestedADGroup on user: $UserWeLookedAfter" -eventID 1000 -eventlog "Write-LogTest"

}

Get-NestedADGroups TestGroup


#Get-NestedADGroups testad
#Get-FindADUser





