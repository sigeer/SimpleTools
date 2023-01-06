param (
    [int]$Count = 10,
    [string]$Content = $null,
    [bool]$SkipDel = $false,
    [string]$IsPrivate = $null
)
if ($Content -eq $null -or $Content -eq "") {
    if ((Test-Path env:Content) -eq $true) {
        $Content = (Get-Item env:Content).Value
    } else {
        $Content = "[搞事] 当前第[NowCount]次，出现[SuccessCount]次，出现率[Rate]"
    }
}
if ($Count -eq $null -or $Count -eq 0) {
    if ((Test-Path env:Count) -eq $true) {
        $Count = (Get-Item env:Count).Value
    }
}
if ($IsPrivate -eq $null -or $IsPrivate -eq "") {
    if ((Test-Path env:IsPrivate) -eq $true) {
        $IsPrivate = (Get-Item env:IsPrivate).Value
    } else {
        $IsPrivate = "false"
    }
}
Write-Host "=======Begin======="
$NowCount = 0
$SuccessCount = 0
while ($true) {
    if (((Get-Date).Hour -eq 0) -and ($NowCount -gt 13)) {
        $NowCount = 0
        $SuccessCount = 0
    }
    if (((Get-Date).DayOfWeek -eq 6) -or ((Get-Date).DayOfWeek -eq 7)) {
        Write-Host "周末降低频率。"
        Start-Sleep -Seconds 7200
    }
    if ($SuccessCount -lt $Count) {
        $NowCount++
        $Rate = "$([Math]::Round($($SuccessCount + 1)/$NowCount, 4) * 100)%"
        Write-Host ("==========>No."+ $NowCount)

        $PostContent = $Content -replace '\[SuccessCount\]', ($SuccessCount + 1)
        $PostContent = $PostContent -replace '\[NowCount\]', $NowCount
        $PostContent = $PostContent -replace '\[Rate\]', $Rate

        $PostResult = ./PostIng.ps1 -Content $PostContent -IsPrivate $($IsPrivate -eq "true")
        if ($PostResult) {
            if (!$SkipDel) {
                $Id = ./CheckStar.ps1
                if ($Id -eq -1) {
                    Write-Error '请求失败，可能是Cookie过期或者被ban -1'
                    break
                } elseif ($Id -eq 0) {
                    $SuccessCount++ 
                    Write-Host "当前第${NowCount}次，出现${SuccessCount}次，出现率${Rate}" -ForegroundColor Green
                } else {
                    ./DelIng.ps1 -Id $Id
                }
            }
        } else {
            Write-Error '请求失败，可能是Cookie过期或者被ban -2'
            break
        }
    }
    Write-Host "Waiting for 5 mins..."
    Start-Sleep -Seconds 301
}
