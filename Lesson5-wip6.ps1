Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Get direct groups and use NestedADGroups to get all nested groups
function Get-NestedADGroupsUsingDirectGroup()
{

Write-Host "All Nested Groups:"$allNestedGroups
foreach($group in $GroupsDirectlyOnUser.Name)
{
 #   Write-Host "We check this group: " $group
    Get-NestedADGroups -searchString $group
    #Save results to $allNestedGroups for all groups
    $allNestedGroups += $results
    
}
$allNestedGroups = $allNestedGroups | Select-Object -Unique|Sort-Object -Property Name -Descending 
#Write-Host "All Nested Groups:"$allNestedGroups 

#Write output to box
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Find Nested AD Groups on User'
$form.Size = New-Object System.Drawing.Size(500,600)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,30)
$label.Size = New-Object System.Drawing.Size(400,400)
$label.Text = "All Nested Groups: $allNestedGroups "
$form.Controls.Add($label)

$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})
$resultTwo = $form.ShowDialog()

if ($resultTwo -eq [System.Windows.Forms.DialogResult]::OK)
{
    #We pressed OK
    Write-Host "We pressed OK"   
    Exit
}

}

#Gets all direct the groups on the given user
function Get-GroupsDirectlyOnUser()
{
Param([parameter(Mandatory=$true)] $user)


$GroupsDirectlyOnUser = Get-ADPrincipalGroupMembership -Identity $user | select Name
Write-Host "Groups Directly on User:" $GroupsDirectlyOnUser | Select Name
$allNestedGroups += $GroupsDirectlyOnUser
Get-NestedADGroupsUsingDirectGroup

}

#variable for while loop check
$askAboutUsername = $true

#Find ADUser
function Get-FindADUser()
{  
#Get-ADUser -Filter {name -like '$ValueFromInputBox'} | Format-Table SamAccountName 

    try {
      
      Get-ADUser -Identity $ValueFromInputBox
      Write-Host User exists
      $UserExists = $true
      $askAboutUsername = $false            
      Get-GroupsDirectlyOnUser -user $ValueFromInputBox      
   
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityResolutionException] {
      Write-Host "User does not exist."
      $UserExists = $false
      $askAboutUsername = $true      
    }
    catch 
    {
    Write-Host "Other error in Get-FindADUser"

    }

}


#While loop that shows the box/labels etc
while($askAboutUsername -eq $true)
{
#Input Box and form background, plus buttons

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Find Nested AD Groups on User'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please enter Username to search groups on:'
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox)

$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    #We pressed OK
    Write-Host "We pressed OK"
    #Set text 
    $ValueFromInputBox = $textBox.Text       
    #Try find user
    Get-FindADUser
    $UserWeLookedAfter = $ValueFromInputBox
    break
}

if ($result -eq [System.Windows.Forms.DialogResult]::Cancel)
{
    #We pressed Cancel
    Write-Host "We pressed cancel, so exit script"
    Exit
}

}

$UserRunningScript = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
#variable
$results = [System.Collections.ArrayList]::new()
#Gets all nested ad groups on a given group    
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
#Write-Output $results | Format-Table | Sort-Object -Property Name -Descending
#Write-Host "Results out of loop is" $results 

#Write to log that we have ran this script and little information about that
Write-Log -TextString "User running script $UserRunningScript is running script to find NestedADGroup on user: $UserWeLookedAfter" -eventID 1000 -eventlog "Write-LogTest"

}
      


#Get-NestedADGroups TestGroup


#Get-NestedADGroups testad
#Get-FindADUser





