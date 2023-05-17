# 简化版

param (
    [int]$Count = 1,
    [string]$Content = $null,
    [string]$Tag = $null,
    [string]$Suffix = $null,
    [bool]$ShowStar = $false
)


Write-Host "=======Begin======="
Write-Host "[Target]: $Count"
$NowCount = 0
$SuccessCount = 0
while ($true) {
    $nowSecondStarCount = ./GetStarCountRank
    Write-Host "当前第二名"$nowSecondStarCount"颗星星"
    if ($SuccessCount -lt $Count -and $SuccessCount -le $nowSecondStarCount) {
        $NowCount++
        $IfRate = "$([Math]::Round($($SuccessCount + 1)/$NowCount, 4) * 100)%"

        $PostContent = ./GetPostContent.ps1 -Content $Content -Tag $Tag -Suffix $Suffix -ShowStar $ShowStar
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
    }

    $WaitSeconds = Get-Random -Minimum 300 -Maximum 550
    Write-Host "下一次将在$((Get-Date).AddSeconds($WaitSeconds) | Get-Date -Format "HH:mm:ss")"
    Start-Sleep -Seconds $WaitSeconds
}