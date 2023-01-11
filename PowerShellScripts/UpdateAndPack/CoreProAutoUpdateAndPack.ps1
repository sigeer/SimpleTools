Param(
    [string]$ProjectDir,
    [String]$GitWorker,
    [String]$NugetServerPath
)

if ([string]::IsNullOrEmpty($ProjectDir)){
    $ProjectDir = (Get-Location).Path
}

if ([string]::IsNullOrEmpty($GitWorker)) {
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

    if ([string]::IsNullOrEmpty($NugetServerPath)) {
        Write-Warning "===>Nupkg has success generated on $PackageFileObj, but [NugetServerPath] is NullOrEmpty."
    } else {
        Write-Host "${NugetServerPath}\$($PackageFileObj.Name)"
        if (Test-Path "${NugetServerPath}\$($PackageFileObj.Name)") {
            Write-Warning "Package Exited"
        } else {
            Write-Host "dotnet nuget push ${PackageFileObj} -s $NugetServerPath --skip-duplicate"
            Invoke-Expression "dotnet nuget push ${PackageFileObj} -s $NugetServerPath --skip-duplicate"
        }

    }

    Remove-Item -Path $PackageFileObj
} else {
    Write-Error "===>Pack Failed!!"
}