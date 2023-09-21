
function SearchAccess($folder)
{
    try {
        Get-ChildItem -Path $folder -Directory -ErrorAction Stop| foreach {
            SearchAccess $_.FullName
        }         
         
       # Write-Host "Folder we can access:" $folder
    }
    catch{
       # "Unable to access $folder"
        $foldersWeCantAccess += $folder
    }   

    Write-Host "We can't access these folders: "
    Write-Host $foldersWeCantAccess
        
}



function Get-FileSizes
{
Param([parameter(Mandatory=$true)] $folder,
[switch] $recurse)

#Start Variables
$AllFoldersAndFiles=@()
$AllFoldersAndFiles += Get-ChildItem -Path $folder -Recurse | Sort-Object -Property Length -Descending
$foldersWeCantAccess

foreach($fileorfolder in $AllFoldersAndFiles)
{

#If a folder
if($fileorfolder.Attributes -contains "Directory")
{    

    $size = (Get-ChildItem -Path $fileorfolder.FullName -Recurse | Measure-Object -Property Length -Sum).Sum    
    $sizeInKB = [Math]::Round($size/1KB, 2)  
    $sizeInMB = [Math]::Round($size/1MB, 2) 
    $sizeInGB = [Math]::Round($size/1GB, 2)  
    #Write-Host $fileorfolder.Name "Size is: " $size
    #Write-Host $fileorfolder.Name "Size in KB is: " $sizeInKB    
   # Write-Host $fileorfolder.Name "Size in MB is: " $sizeInMB  
   # Write-Host $fileorfolder.Name "Size in GB is: " $sizeInGB      

    
#Write out for folders
$fileorfolder | Select-Object -Property Name ,@{Label='Size(KB)'; Expression={[Math]::Round($sizeInKB, 2)}},@{Label='Size(MB)'; Expression={[Math]::Round($sizeInMB, 2)}},@{Label='Size(GB)'; Expression={[Math]::Round($sizeInGB, 2)}}


}else{
#Write out for files
$fileorfolder | Select-Object -Property Name ,@{Label='Size(KB)'; Expression={[Math]::Round($_.Length/1KB, 2)}},@{Label='Size(MB)'; Expression={[Math]::Round($_.Length/1MB, 2)}},@{Label='Size(GB)'; Expression={[Math]::Round($_.Length/1GB, 2)}}

}



}
#CheckAccess
$checkAccess = SearchAccess($folder)

}



Get-FileSizes -folder "C:\temp" -recurse
