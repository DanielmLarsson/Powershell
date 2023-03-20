
#Get all users with given name
function Get-UsersWithName()
{
#Parameters for Name and ShowDetails
param (    
        [Parameter(Mandatory=$false)]    
        [String]$Name,
        [parameter(parametersetname="ShowDetails")]
        [switch]$ShowDetails,
        [parameter(parametersetname="ExportCSV")]
        [String]$ExportCSV
        
      )

#Store all AD Users in a variable    
    $FilteredAdUsers = Get-ADUser -Filter {GivenName -eq $Name}
    #Amount of found users
    $UserCount = 0
     #Variable to check counted users with
    $Counter = 0
    #Variable array to store info in
    $UserArray =@()
    #Save Found Users in array variable
    $FoundUsers = @()

    #Check for our users
    if([string]::IsNullOrEmpty($FilteredAdUsers))
    {
    Write-Host User $Name does not exist.
    }
    #If ShowDetails is selected
    if($ShowDetails)
    {    
    $FilteredAdUsers | Select-Object -Property "GivenName", "Surname", "SamAccountName","Mail" | Sort-Object -Property @{Expression = "Surname"; Descending = $true}| Write-Host
    } 

    #If ExportCSV is selected
    if($ExportCSV)
    {
        $FilteredAdUsers | Select-Object -Property "GivenName", "Surname", "SamAccountName","Mail" | Sort-Object -Property @{Expression = "Surname"; Descending = $true}| Export-csv -Path $ExportCSV -Append -NoTypeInformation
    }

    #Counts our found users. 
    $UserCount = $FilteredAdUsers | Select-Object | measure
    $UserCount = $UserCount.Count
    Write-Host Users with name is $UserCount 
}

#Call Function code

Get-UsersWithName -Name "Adam" -ShowDetails
#Get-UsersWithName -Name "Adam" -ExportCSV "C:\temp\ADNamn.csv"
