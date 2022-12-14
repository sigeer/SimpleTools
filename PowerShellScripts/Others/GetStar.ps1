param (
    [int]$Count = 0,
    [string]$Content = $null,
    [bool]$SkipDel = $false,
    [string]$IsPrivate = $null
)

if ([string]::IsNullOrEmpty($Content)) {
    if (Test-Path env:Content) {
        $Content = (Get-Item env:Content).Value
    }
}
if ($Count -eq $null -or $Count -eq 0) {
    if (Test-Path env:Count) {
        $Count = (Get-Item env:Count).Value -as [int]
    } else {
        $Count = 0
    }
}
if ([string]::IsNullOrEmpty($IsPrivate)) {
    if (Test-Path env:IsPrivate) {
        $IsPrivate = (Get-Item env:IsPrivate).Value
    } else {
        $IsPrivate = "false"
    }
}
$InitNowCount = 0
if (Test-Path env:InitNowCount) {
    $InitNowCount = (Get-Item env:InitNowCount).Value -as [int]
}
$InitSuccessCount = 0
if (Test-Path env:InitSuccessCount) {
    $InitSuccessCount = (Get-Item env:InitSuccessCount).Value -as [int]
}

$UseRandom = [string]::IsNullOrEmpty($Content)
function Get-PostContent {
    if ($UseRandom -and (Test-Path Wording.txt)) {
        $Content = $($(Get-Content ./Wording.txt) -split "\r\n") | Get-Random
    }
    if ([string]::IsNullOrEmpty($Content)) {
        $Content = "[搞事]"
    }
    return $Content.TrimStart()
}


Write-Host "=======Begin======="
Write-Host "[Target]: $Count"
$NowCount = $InitNowCount
$SuccessCount = $InitSuccessCount
$ToDay = (Get-Date).Day
while ($true) {
    if (((Get-Date).Hour -le 8) -or ((Get-Date).Hour -gt 18)) {
        Write-Host "下班时间降低频率。"
        Start-Sleep -Seconds 3600
        continue
    }
    if (((Get-Date).DayOfWeek -eq 6) -or ((Get-Date).DayOfWeek -eq 0)) {
        Write-Host "周末降低频率。"
        Start-Sleep -Seconds 3600
        continue
    }
    
    if ($ToDay -ne (Get-Date).Day) {
        $NowCount = 0
        $SuccessCount = 0
        $ToDay = (Get-Date).Day
    }

    if ($SuccessCount -lt $Count) {
        $NowCount++
        $IfRate = "$([Math]::Round($($SuccessCount + 1)/$NowCount, 4) * 100)%"

        Write-Host ("==========>No."+ $NowCount)
        
        $Content = Get-PostContent
        $PostContent = $Content -replace '\[SuccessCount\]', ($SuccessCount + 1)
        $PostContent = $PostContent -replace '\[NowCount\]', $NowCount
        $PostContent = $PostContent -replace '\[Rate\]', $IfRate

        if (($SuccessCount + 1) -eq $Count) {
            $PostContent = "[终结技] 最后再拿一颗"
        }

        $PostResult = ./PostIng.ps1 -Content $PostContent -IsPrivate $($IsPrivate -eq "true")
        if ($PostResult) {
            if (!$SkipDel) {
                $Id = ./CheckStar.ps1
                if ($Id -eq -1) {
                    Write-Error '请求失败，可能是Cookie过期或者被ban -1'
                    break
                } elseif ($Id -eq 0) {
                    $SuccessCount++ 
                } else {
                    ./DelIng.ps1 -Id $Id
                }
            }
        } else {
            Write-Error '请求失败，可能是Cookie过期或者被ban -2'
            break
        }
        $Rate = "$([Math]::Round($SuccessCount/$NowCount, 4) * 100)%"
        Write-Host "当前已尝试${NowCount}次，出现${SuccessCount}次，出现率${Rate}" -ForegroundColor Green
    }
    $WaitMins = Get-Random -Minimum 5 -Maximum 10
    $WaitSeconds = Get-Random -Minimum 5 -Maximum 20
    $TotalSeconds = (60 * $WaitMins + $WaitSeconds)
    Write-Host "Waiting for ${TotalSeconds}s..."
    Start-Sleep -Seconds $TotalSeconds
}