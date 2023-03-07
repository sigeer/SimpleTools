# 统计代码行数
### 统计在 [Directory Path] 内 [File] 共有多少行
function Get-Code-Lines {
    $DirPath = Read-Host "Directory Path"
    $Files = Read-Host "File (e.g. *.cs, *.js  separated by commas)"

    if ($Files -ne "") {
        (Get-ChildItem -Path $DirPath -Recurse -Include $Files | Select-String .).Count
    }
    else {
        (Get-ChildItem -Path $DirPath -Recurse | Select-String .).Count
    }
}
Get-Code-Lines
