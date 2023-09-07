function Find-Text
{
Param([parameter(Mandatory=$true)] $text, 
    [parameter(Mandatory=$true)] $folder)

$counter = 0

#Check for childfolders
$files = Get-childitem -Path $folder -Recurse

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
       
        #while counter less or equal to maxcounted lines
        do
        {
        #Write what line is the text in?
        Write-Host "Linenumber is:" $lineNumber[$counter].LineNumber        
       
        $finalText = $checkText[$counter]            
        #Split our text 
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

    
}

}

Find-Text -text "Nisse" -folder "C:\temp"
