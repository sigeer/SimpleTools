Param(
    [string]$ProjectDir,
    [String]$GitWorker,
    [String]$NugetServerPath
)

$NowLocation = $MyInvocation.MyCommand.Definition
Write-Host "NowLocation: $NowLocation" -ForegroundColor Green

if ([string]::IsNullOrEmpty($ProjectDir)){
    $ProjectDir = (Get-Location).Path
}

if ([string]::IsNullOrEmpty($GitWorker)) {
    $GitWorker = (Get-ChildItem -Path $NowLocation 'GitPull.sh').FullName
}

Write-Host "==========" + $ProjectDir + "==========="
Set-Location $ProjectDir

Write-Host "Step1. Check csproj" -ForegroundColor Green
if ((Get-ChildItem '*.csproj').Length -eq 0) {
    Write-Error ".csproj not found"
    return
}

Write-Host "Step2. Git Pull" -ForegroundColor Green
bash $GitWorker

Write-Host "Step3. build | Command: dotnet build" -ForegroundColor Green
dotnet build

$DotnetPackCommand = "dotnet pack"
Write-Host "Step4. dotnet pack | Command: $DotnetPackCommand" -ForegroundColor Green
& $DotnetPackCommand

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
            $PushCommand = "dotnet nuget push ${PackageFileObj} -s $NugetServerPath --skip-duplicate"
            Write-Host "Step5. nuget push | Command: $PushCommand" -ForegroundColor Green
            & $PushCommand
        }
    }

    Remove-Item -Path $PackageFileObj
    Set-Location = $NowLocation
} else {
    Write-Error "===>Pack Failed!!"
}
