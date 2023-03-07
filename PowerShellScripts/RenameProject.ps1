$dir = Read-Host "Work Dir"
$originStr = Read-Host "Origin String"
$targetStr = Read-Host "Target String"
$includeTypes = Read-Host "Include Types"

./RenameProjectFunction -Directory $dir -OriginStr $originStr -TargetStr $targetStr -IncludeTypes $includeTypes


