

function Find-Text
{
Param([parameter(Mandatory=$true)] $text, 
    [parameter(Mandatory=$true)] $folder)
$foundText = New-Object System.Collections.ArrayList(1)
#Select-string -Pattern $text -Path $path
#Write-Host "Path is" $folder
$files = Get-childitem -Path $folder -Recurse
#Write-Host $files
#Use our found files and for each of them do a search
foreach($fileObject in $files)
{    
    #Check if this object holds our text    
    $checkText = Get-Content -Path $folder\$fileObject | Where-Object {$_ -like $text}
    #If text returned is $text
    if($checkText -eq $text)
    {
       # Write-Host "Found Nisse"
        #Save this file to our array
        [void] $foundText.Add($fileObject)       
    }
}

#$foundTextFinal = $foundText | Select-Object Name | Out-String

$foundTextFinal = $foundText
#If foundTextFinal not null
if($foundTextFinal -ne $null)
{

Write-Host "Text" $text "can be found in:"
    foreach($foundTextName in $foundTextFinal)
    {
        Write-Host $foundTextName | Select-Object -ExpandProperty Name
    }
         
}

}

Find-Text -text "Nisse" -folder "C:\temp"