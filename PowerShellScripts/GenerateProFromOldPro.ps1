# 从一个项目以新的命名生成新的项目
param (
    [string]$Path,
    [string]$Destination,
    [string]$OldName,
    [string]$Name
)

if (!$(Test-Path $Path)) {
    Write-Error "Path: $Path Not Exsited"
    return
}
Copy-Item -Path $Path -Destination $Destination -Recurse -Force
./RenameProjectFunction -Directory $Destination -OriginStr $OldName -TargetStr $Name
