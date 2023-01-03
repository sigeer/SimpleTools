param (
    [int]$Count,
    [string] $Content,
    [bool]$SkipDel
)
Write-Host "=======Begin======="
$NowCount = 0
$SuccessCount = 0
while ( $SuccessCount -lt $Count) {
    $NowCount++
    Write-Host ("第"+ $NowCount +"次")
    if (((Get-Date).Hour -eq 0) -and ($NowCount -gt 12 )) {
        $NowCount = 0
    }
    if ($Content -eq $null -or $Content -eq "") {
        if (Test-Path env:Content -eq $true) {
            $Content = (Get-Item env:Content).Value
        } else {
            $Content = "[搞事] 星来"
        }
    }
    if ($Count -eq $null -or $Count -eq 0) {
        if (Test-Path env:Count -eq $true) {
            $Count = (Get-Item env:Count).Value
        } else {
            $Count = 10
        }
    }
    $PostResult = ./PostIng.ps1 -Content $Content
    if ($PostResult -eq $true) {
        if ($SkipDel -eq $false) {
            $Id = ./CheckStar.ps1
            if ($Id -eq -1){
                Write-Error '请求失败，可能是Cookie过期或者被ban'
                break
            } elseif ($Id -eq 0) {
                $SuccessCount++ 
            } else {
                ./DelIng.ps1 -Id $Id
            }
        }
    } else {
        Write-Error '请求失败，可能是Cookie过期或者被ban'
        break
    }
    Write-Host "Waiting for 5 mins..."
    Start-Sleep -Seconds 305
}
