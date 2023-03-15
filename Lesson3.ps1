
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
    $AllADUsers = Get-ADUser -Filter *
    #Amount of found users
    $UserCount
     #Variable to check counted users with
    $Counter 
    #Variable array to store info in
    $UserArray =@()
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
        $counter+=1
        if($user.GivenName -notlike $Name -and $Counter -eq $AllADUsers.Length)
        {
            Write-Host "No users named " $Name "were found."
        }
                 
    }
    #After for loop ends, write number
    Write-Host Users with name is $UserCount
    #Sort found users in ascending order of Surname
    $SortedUsers = $FoundUsers | Sort-Object -Property @{Expression = "Surname"; Descending = $true}    
    #Loop through Sorted Users
    ForEach($user in $SortedUsers)
    {
        #Write-Host "Debug ForEach"
            if($ShowDetails -eq $true)
            {
            #Do ShowDetails output
       
            
            #write out user 
            Write-Host $user.GivenName, $user.Surname, $user.SamAccountName, $user.Mail  
             
            }
            if($ExportCSV -notlike 'empty')
            {            
            #Export CSV to location            
            #Saves users name, surname, account name and mail in a variable
            $UserCompact = -join($user.GivenName +","+$user.Surname+"," +$user.SamAccountName+","+ $user.Mail) 
            
            #Saves variable in an array with Select-Object
            #Write-Host UserCompactBeforeArray= $UserCompact
            $UserArray = $UserCompact | Select-Object @{Name='Name';Expression={$_}}
            
            #Write-Host UserArray= $UserArray          
            #Append that arrayrow to our csv file
            $UserArray | Export-csv -Path $ExportCSV -Append -NoTypeInformation
            }

    }

     

}
#Get-UsersWithName -Name "Adam" -ShowDetails
Get-UsersWithName -Name "Adam" -ExportCSV "C:\temp\ADNamn.csv"
