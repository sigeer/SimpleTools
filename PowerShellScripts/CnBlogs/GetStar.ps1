# 简化版

param (
    [int]$Count = -1,
    [string]$Content = $null,
    [string]$Suffix = $null,
    [string]$Pool = "./wording_default.txt",
    [int]$LessThan = 0,
    [int]$MoreThan = 0
)

$CachePath = './success_cache'

Write-Host "=======Begin======="
Write-Host "[Target]: $Count"
$NowCount = 0
$SuccessCount = 0
$ToDay = (Get-Date).ToString("yyyyMMdd")
if (Test-Path $CachePath) {
    $CacheStr = Get-Content -Path $CachePath
    if ($ToDay -eq (Get-Item $CachePath).LastWriteTime.ToString("yyyyMMdd")) {
        $SuccessCount = [int]::Parse($CacheStr)
    }
}

while ($true) {
    if ($ToDay -ne (Get-Date).ToString("yyyyMMdd")) {
        $NowCount = 0
        $SuccessCount = 0
        $ToDay = (Get-Date).ToString("yyyyMMdd")
    }

    if ($LessThan -gt 0) {
        $nowSelectStarCount = ./GetStarCountRank -Rank $LessThan
        Write-Host "当前第"$LessThan"名有"$nowSelectStarCount"颗星星"

        if (($SuccessCount + 1) -ge $nowSelectStarCount) {
            $WaitSeconds = Get-Random -Minimum 300 -Maximum 550
            Write-Host "下一次将在$((Get-Date).AddSeconds($WaitSeconds) | Get-Date -Format "HH:mm:ss")"
            Start-Sleep -Seconds $WaitSeconds
            continue
        }
    } else {
        if ($MoreThan -gt 0) {
            $nowSelectStarCount = ./GetStarCountRank -Rank $MoreThan
            Write-Host "当前第"$MoreThan"名有"$nowSelectStarCount"颗星星"
    
            if (($SuccessCount + 1) -gt $nowSelectStarCount) {
                $WaitSeconds = Get-Random -Minimum 300 -Maximum 550
                Write-Host "下一次将在$((Get-Date).AddSeconds($WaitSeconds) | Get-Date -Format "HH:mm:ss")"
                Start-Sleep -Seconds $WaitSeconds
                continue
            }
        }
    }

    if (($SuccessCount -lt $Count) -or ($Count -eq -1)) {
        $NowCount++
        $IfRate = "$([Math]::Round($($SuccessCount + 1)/$NowCount, 4) * 100)%"

        $PostContent = ./GetPostContent.ps1 -Content $Content -Suffix $Suffix -Pool $Pool
        $PostContent = $PostContent -replace '\[SuccessCount\]', ($SuccessCount + 1)
        $PostContent = $PostContent -replace '\[NowCount\]', $NowCount
        $PostContent = $PostContent -replace '\[Rate\]', $IfRate

        Write-Host $PostContent
        $PostResult = ./PostIng.ps1 -Content $PostContent
        if ($PostResult) {
            if (!$SkipDel) {
                $Id = ./CheckStar.ps1
                if ($Id -eq -1) {
                    Write-Error '请求失败，可能是Cookie过期或者被ban -1'
                    break
                }
                elseif ($Id -eq 0) {
                    $SuccessCount++ 
                    Set-Content -Path './success_cache' -Value $SuccessCount
                }
                else {
                    ./DelIng.ps1 -Id $Id
                }
            }
        }
        else {
            Write-Error '请求失败，可能是Cookie过期或者被ban -2'
            break
        }
        $Rate = "$([Math]::Round($SuccessCount/$NowCount, 4) * 100)%"
        Write-Host "当前已尝试${NowCount}次，出现${SuccessCount}次，出现率${Rate}" -ForegroundColor Green
    } else {
        Write-Error '任务完成'
        break
    }

    $WaitSeconds = Get-Random -Minimum 300 -Maximum 550
    Write-Host "下一次将在$((Get-Date).AddSeconds($WaitSeconds) | Get-Date -Format "HH:mm:ss")"
    Start-Sleep -Seconds $WaitSeconds
}