<#
.Synopsis
   Short description
   Write Log information to a default or existing logfile.
.DESCRIPTION
   Long description
   Write Log information to a default or existing logfile.
   With different parameters used and different results depending on what is given.
.EXAMPLE
   Example of how to use this cmdlet
   Write-Log "Hej"
.EXAMPLE
   Another example of how to use this cmdlet
   Write-Log -Text "Hej" -File "C:\temp\Nisse.log"
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
   Write Log information to a default or existing logfile.
#>
function Write-Log
{
    
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  SupportsShouldProcess,                   
                  PositionalBinding=$false,
                  HelpUri = 'http://www.google.com',
                  ConfirmImpact='Medium')]
    [Alias()]
    [OutputType([String])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,                     
                   position = 0,                        
                   #Use Parameters together by using the same name on them in ParameterSetName.                              
                   ParameterSetName='Log')]
        [Parameter(Mandatory=$true,                   
                   position = 0,     
                   #Second ParameterSetName for use with event also                             
                   ParameterSetName='Event')]               
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]        
        [String]       
        $TextString,
        # Param2 help description
          [Parameter(Mandatory=$false,                                     
                   position = 1,
                   ParameterSetName='Log')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]             
        [String]$FilePath,

        #Param help description
        [Parameter(Mandatory=$false,                    
                   position = 1,                                                                                          
                   ParameterSetName='Event')]       
        [int]
        $eventid,
        #Param help description
        [Parameter(Mandatory=$false,                    
                   position = 2,                                                                       
                   ParameterSetName='Event')]       
        [String]
        $eventlog,
           #Param help description
        [Parameter(Mandatory=$false,                                       
                   ValueFromPipeline=$true,
                   position = 0)
                    ]       
        [String]
        $pipelineInput
        
        #Param6 help description
        #[Parameter(ParameterSetName='para5')]        
        #[String]
        #$para3

        #Parameter Checks and other
        #ValueFromRemainingArguments=$false,
        # ValueFromPipelineByPropertyName=$true,  
        #[ValidatePattern("[a-z]*")]
        #[ValidateLength(0,15)]
        # [AllowEmptyString()]
        # [ValidateScript({$true})]
        # [ValidateRange(0,5)]
        # [AllowNull()]
        # [int]
        #[ValidateCount(0,5)]
        #[ValidateSet("sun", "moon", "earth")]
        # [Alias("p1")] 
        #[AllowEmptyCollection()]  
        #[String]
        #position

    )

    Begin
    {     
    # Write-Host We begin.
        if($TextString -and $eventid -and $eventlog -ne "Write-LogTest")
        {
            Write-EventLog -Source Application -EventId $eventid -LogName $eventlog -EntryType Information -Message $TextString     
        }

        elseif($TextString -and $eventid -and $eventlog -eq "Write-LogTest")
        {
         #   Write-Host We are in event code.
            #Write-EventLog -Source "ESENT" -EventId $eventid -LogName $eventlog -EntryType Information -Message $TextString               
            if(Test-Path -path C:\temp\Write-log.dll -PathType Leaf -IsValid){
            
            }else{
                New-EventLog -Source Write-Log -LogName Write-LogTest -MessageResourceFile C:\temp\Write-log.dll
            }

            Write-EventLog -Source Write-Log -EventId $eventid -LogName $eventlog -EntryType Information -Message $TextString     
             
        }elseif($TextString -and $FilePath)
        {
          #  Write-Host We are in filepath code.          
            #$TextString | Select-Object @{Name='String';Expression={$_}} | Export-Csv -Path $FilePath -Append -NoTypeInformation
           $TextString | Out-File -FilePath $FilePath -Append
          
        }elseif($TextString)
        {      
          # Write-Host We are in TextString code           
          # $TextString | Select-Object @{Name='String';Expression={$_}} | Export-Csv -Path c:\temp\log.log -Append -NoTypeInformation
            $TextString | Out-File -FilePath c:\temp\log.log -Append -Force
        }   

    }
    Process
    {
        #if ($pscmdlet.ShouldProcess(('Target')), ('Operation'))                       
       if ($pscmdlet.ShouldProcess('Target', 'Operation'))               
        {

        }
            
        #pipeline
        ForEach ($input in $pipelineInput)
        {   
            #Date and text
            $DateAndTimeString = Get-Date -Format "yyyy/MM/dd HH:mm" 
            $CombinedString = $DateAndTimeString+" "+$TextString
            # Write-Host We are in filepath pipeline code
           #If Filepath
            if($FilePath)
            {
              #Append the data to given filePath
             # $CombinedString | Select-Object @{Name='String';Expression={$_}} | Export-Csv -Path $FilePath -Append -NoTypeInformation
                $CombinedString |  Out-File -FilePath $FilePath -Append
            }
            elseif($TextString)
            {
             #Append combined string to default location
             #$CombinedString | Select-Object @{Name='String';Expression={$_}} |  Export-Csv -Path c:\temp\log.log -Append -NoTypeInformation
                $CombinedString | Out-File -FilePath c:\temp\log.log -Append
            }
        }

         
    }
    End
    {
    }
}

#Calls to function

#Write-Log "Hej"
#Write-Log -Text "Hej" -File "C:\temp\Nisse.log"
Write-Log -Text "Hej" -eventid 1000 -eventlog "Application"
#"Hej" | Write-Log -file "C:\temp\nisse.log"
# "Hej" | Write-Log
#Write-Log "Hej" -WhatIf
#Write-Log -Text "Hej" -eventid 1000 -eventlog "Write-LogTest"
