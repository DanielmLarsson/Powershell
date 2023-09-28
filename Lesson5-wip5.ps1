#Next step 7. Haven't started yet.

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



while($askAboutUsername -eq $true)
{
#Input Box and form background
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

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
    Write-Host "We pressed cancel, so exit script"
    Exit
}

}

      
Write-Host We run NestedADGroups 
Get-NestedADGroups $UserWeLookedAfter

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

#Get-NestedADGroups TestGroup


#Get-NestedADGroups testad
#Get-FindADUser





