Param(
    [string]$ProjectDir,
    [String]$GitWorker,
    [String]$NugetServerPath
)

if (($ProjectDir -eq $null) -or ($ProjectDir -eq '')){
    $ProjectDir = (Get-Location).Path
}

if (($GitWorker -eq $null) -or ($GitWorker -eq '')) {
    $GitWorker = (Get-ChildItem -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) 'GitPull.sh').FullName
}

Write-Host "==========" + $ProjectDir + "==========="
Set-Location $ProjectDir

if ((Get-ChildItem '*.csproj').Length -eq 0) {
    Write-Error ".csproj not found"
    return
}

bash $GitWorker
dotnet build

dotnet pack
#找到目录下生成的所有包
$PackResult = Get-ChildItem '*.nupkg' -Recurse | Sort-Object -Property LastWriteTime -Descending
if ($PackResult.Length -gt 0) {
    #找到最新的包
    $PackageFileObj = $PackResult[0]

    if (($NugetServerPath -eq $null) -or ($NugetServerPath -eq '')) {
        Write-Warning "===>Nupkg has success generated on $PackageFileObj, but [NugetServerPath] is NullOrEmpty."
    } else {
        Invoke-Expression "dotnet nuget push $PackageFileObj.FullName -s $NugetServerPath --skip-duplicate"
    }

    Remove-Item -Path $PackageFileObj
} else {
    Write-Error "===>Pack Failed!!"
}