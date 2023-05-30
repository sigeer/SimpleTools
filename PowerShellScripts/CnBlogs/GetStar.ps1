﻿# 简化版

param (
    [int]$Count = -1,
    [string]$Content = $null,
    [string]$Tag = $null,
    [string]$Suffix = $null,
    [int]$LessThan = 0,
    [int]$From = 0
)


Write-Host "=======Begin======="
Write-Host "[Target]: $Count"
$NowCount = 0 + $From
$SuccessCount = 0 + $From
$ToDay = (Get-Date).Day
while ($true) {
    if ($ToDay -ne (Get-Date).Day) {
        $NowCount = 0
        $SuccessCount = 0
        $ToDay = (Get-Date).Day
    }

    if ($LessThan -gt 0) {
        $nowSecondStarCount = ./GetStarCountRank -Rank $LessThan
        Write-Host "当前第"$LessThan"名有"$nowSecondStarCount"颗星星"

        if ($SuccessCount + 1 -ge $nowSecondStarCount) {
            $WaitSeconds = Get-Random -Minimum 300 -Maximum 550
            Write-Host "下一次将在$((Get-Date).AddSeconds($WaitSeconds) | Get-Date -Format "HH:mm:ss")"
            Start-Sleep -Seconds $WaitSeconds
            continue
        }
    }

    if (($SuccessCount -lt $Count) -or ($Count -eq -1)) {
        $NowCount++
        $IfRate = "$([Math]::Round($($SuccessCount + 1)/$NowCount, 4) * 100)%"

        $PostContent = ./GetPostContent.ps1 -Content $Content -Tag $Tag -Suffix $Suffix
        $PostContent = $PostContent -replace '\[SuccessCount\]', ($SuccessCount + 1)
        $PostContent = $PostContent -replace '\[NowCount\]', $NowCount
        $PostContent = $PostContent -replace '\[Rate\]', $IfRate

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