# 文件名，文件内容替换
param (
    [string]$Directory,
    [string]$OriginStr,
    [string]$TargetStr,
    [string]$IncludeTypes
)
function Update-Dir {
    param (
        [string]$Directory,
        [string]$OriginStr,
        [string]$TargetStr,
        [string]$IncludeTypes
    )
    Rename-Dir -DirPath $Directory -OriginStr $OriginStr -TargetStr $TargetStr

    $files = Get-ChildItem -Path $Directory -File -Recurse -Include *.cs, *.csproj, *.txt, *.md, *.js, *.json, *.config, *.ini, *.bat, *.ps1, *.cshtml, *.sln, *.bat, *.sh, *.yml, *.cmd
    foreach ($file in $files) {
        #先处理文件内容
        $Content = Get-Content -Path $file.FullName
        Clear-Content -Path $file.FullName
        foreach ($line in $content) {
            $line = $line.Replace($OriginStr, $TargetStr)
            Add-Content -Path $file.FullName -Value $line
        }

        #修改文件名
        $NewFileName = $file.Name.Replace($OriginStr, $TargetStr)
        if ($file.Name -ne $NewFileName) {
            Rename-Item -Path $file.FullName -NewName $NewFileName
        }
    }
    
    $dirs = Get-ChildItem -Path $Directory -Directory -Recurse
    foreach ($dir in $dirs) {
        Rename-Dir -DirPath $dir.FullName -OriginStr $OriginStr -TargetStr $TargetStr
    }

    Write-Output "Success!!"
}

<#
    .Description
    修改文件夹名
#>
function Rename-Dir {
    param(
        [string]$DirPath,
        [string]$OriginStr,
        [string]$TargetStr
    )
    if (Test-Path $DirPath) {
        $DirModel = Get-Item -Path $DirPath
        #修改文件夹名
        $NewDirName = $DirModel.Name.Replace($OriginStr, $TargetStr)
        if ($DirModel.Name -ne $NewDirName) {
            Rename-Item -Path $DirModel.FullName -NewName $NewDirName
        }
    }

}


Update-Dir -Directory $Directory -OriginStr $OriginStr -TargetStr $TargetStr -IncludeTypes $includeTypes


