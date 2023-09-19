

function Get-FileSizes
{
Param([parameter(Mandatory=$true)] $folder,
[switch] $recurse)

$AllFoldersAndFiles = Get-ChildItem -Path $folder -Recurse | Sort-Object -Property Length -Descending

foreach($fileorfolder in $AllFoldersAndFiles)
{
#if a folder
if($fileorfolder.Attributes -contains "Directory")
{
$Length = (Get-ChildItem $FileOrFolder.FullName -Recurse | Where-Object {$_.Attributes -notcontains "Directory"} | Measure-Object -Sum -Property Length).Sum
$fileorfolder | Select-Object Name, @{Name="Length"; Expression={$Length}}

}else{
#Its a file
$fileorfolder | Select-Object Name, Length
}

}



}
Get-FileSizes -folder "C:\temp" -recurse
