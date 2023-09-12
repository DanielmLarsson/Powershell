
function Find-AndReplace
{
Param([parameter(Mandatory=$true)] $text, 
    [parameter(Mandatory=$true)] $folder,
    [switch] $recurse,
    [parameter(Mandatory=$true)] $newtext)

$counter = 0

#Check for childfolders
$files = Get-childitem -Path $folder -Recurse:$recurse

#Use our found files and for each of them do a search
foreach($fileObject in $files)
{    
    
    #Check if this object holds our text    
    $checkText = Get-Content -Path $folder\$fileObject | Where-Object {$_ -like "*$text*"}      
   
    #If text returned is $text
    if($checkText -like "*$text*")
    {    
    
        Write-Host "Text can be found in: " $fileObject                         
        #Code for each hit of the word     

        #Save lineNumber data in variable
        $lineNumber = Get-Content -Path $folder\$fileObject | Select-String $text                       
                
        $tempLineNumber = $lineNumber.LineNumber 
        [array]$tempLineNumber = $tempLineNumber
               
        #Replace our text with new text
        

        #while counter less or equal to maxcounted lines
        do
        {
        #Write what line is the text in?
        Write-Host "Linenumber is:" $lineNumber[$counter].LineNumber        
       
        $finalText = $checkText[$counter]            
        #Split our text and write it out
        $finalText -split '\n' 
        #$finalText.ToString()      
        $counter++
       # Write-Host "Counter is:" $counter
        }while($counter -le $tempLineNumber.Count-1)

        #Since we outside whileloop, reset counter to 0
        $counter=0
        #Also input an empty line for better readability
        Write-Host " " `n

    }

    #Since we done with all the text, now save the file in a variable
    $fullFileText = Get-Content -Path $folder\$fileObject

    #Replace our text with newtext write that to the file
    $fullFileText -replace $text, $newtext | Set-Content -Path $folder\$fileObject
         
}
    Write-Host "All the found text" $text "Has been replaced with" $newtext

}

Find-AndReplace -text "Nisse" -folder "C:\temp" -recurse -newtext "Kalle"
