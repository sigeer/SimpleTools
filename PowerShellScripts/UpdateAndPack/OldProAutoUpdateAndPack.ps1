Param(
    [string]$ProjectDir,
    [String]$GitWorker,
    [String]$GitMainBranch = "master",
    [String]$NugetServerPath,
    [String]$CompilerDir
)

if ([string]::IsNullOrEmpty($NugetServerPath)) {
    Write-Error "NugetServer 不能为空"
    return
}

if ([string]::IsNullOrEmpty($ProjectDir)){
    Write-Error "ProjectDir 不能为空"
    return
}

if ([string]::IsNullOrEmpty($GitWorker)) {
    Write-Error "GitWorker 不能为空"
    return
}

$OriginPwd = $PWD

Write-Host "==========" + $ProjectDir + "==========="
Set-Location $ProjectDir

Write-Host "===>Step1. Check csproj" -ForegroundColor Green
if ((Get-ChildItem '*.csproj').Length -eq 0) {
    Write-Error ".csproj not found"
    return
}

Write-Host "===>Step2.1. Git Switch Branch | Command: git checkout $GitMainBranch" -ForegroundColor Green
git checkout $GitMainBranch

Write-Host "===>Step2. Git Pull | Command: git pull" -ForegroundColor Green
bash $GitWorker

$BuildCommand = "msbuild"
Write-Host "===>Step3. Build | Command: $BuildCommand" -ForegroundColor Green
if (![string]::IsNullOrEmpty($CompilerDir)) {
    $BuildCommand = Join-Path $CompilerDir "msbuild"
}
& $BuildCommand

$PackCommand = "nuget pack"
Write-Host "===>Step4. Pack | Command: $PackCommand" -ForegroundColor Green
Invoke-Expression $PackCommand

#找到目录下生成的所有包
$PackResult = Get-ChildItem '*.nupkg' -Recurse | Sort-Object -Property LastWriteTime -Descending
if ($PackResult.Length -gt 0) {
    #找到最新的包
    $PackageFileObj = $PackResult[0]

    if (!$NugetServerPath.StartsWith("http") -and (Test-Path "${NugetServerPath}\$($PackageFileObj.Name)")) {
        Write-Error "Package $PackageFileObj Exited"
    } else {
        $PushCommand = "nuget push ${PackageFileObj} -Src $NugetServerPath -SkipDuplicate"
        Write-Host "===>Step5. Push | Command: $PushCommand" -ForegroundColor Green
        Invoke-Expression $PushCommand
    }
    
    Remove-Item -Path $PackageFileObj
    Set-Location = $OriginPwd
} else {
    Write-Error "===>Pack Failed!!"
}
