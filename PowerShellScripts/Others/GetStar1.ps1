# 简化版

param (
    [int]$Count = 1,
    [string]$Tag = $null
)

function Get-PostContent {
    param (
        $TagValue = $null,
        $Value = $null
    )
    $UseRandom = [string]::IsNullOrEmpty($Value)
    if ($UseRandom -and (Test-Path Wording.txt)) {
        $Value = $($(Get-Content ./Wording.txt) -split "\r\n") | Get-Random
    }
    if (![string]::IsNullOrEmpty($TagValue)) {
        $Value = "[" + $TagValue + "]" + " " + $Value.TrimStart()
    }
    if ([string]::IsNullOrEmpty($Value)) {
        $Value = "[标签]"
    }
    return $Value.TrimStart()
}


Write-Host "=======Begin======="
Write-Host "[Target]: $Count"
$NowCount = 0
$SuccessCount = 0
while ($true) {
    if ($SuccessCount -lt $Count) {
        $NowCount++
        $IfRate = "$([Math]::Round($($SuccessCount + 1)/$NowCount, 4) * 100)%"

        Write-Host ("==========>No." + $NowCount + "==Enter：")
        $fromInput = Read-Host
        $Content = Get-PostContent -Value $fromInput -TagValue $Tag
        $PostContent = $Content -replace '\[SuccessCount\]', ($SuccessCount + 1)
        $PostContent = $PostContent -replace '\[NowCount\]', $NowCount
        $PostContent = $PostContent -replace '\[Rate\]', $IfRate

        if (($SuccessCount + 1) -eq $Count) {
            $PostContent = "算了算了，最后再拿一颗收工"
        }

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
    $WaitMins = Get-Random -Minimum 5 -Maximum 10
    $WaitSeconds = Get-Random -Minimum 5 -Maximum 20
    $TotalSeconds = (60 * $WaitMins + $WaitSeconds)
    Write-Host "Waiting for ${TotalSeconds}s..."
    Start-Sleep -Seconds $TotalSeconds
}