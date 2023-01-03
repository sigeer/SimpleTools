param (
    [int]$Count = 10,
    [string]$Content = $null,
    [bool]$SkipDel = $false
)
if ($Content -eq $null -or $Content -eq "") {
    if ((Test-Path env:Content) -eq $true) {
        $Content = (Get-Item env:Content).Value
    } else {
        $Content = "[搞事] 星来"
    }
}
if ($Count -eq $null -or $Count -eq 0) {
    if ((Test-Path env:Count) -eq $true) {
        $Count = (Get-Item env:Count).Value
    }
}
Write-Host "=======Begin======="
$NowCount = 0
$SuccessCount = 0
while ($true) {
    if ($SuccessCount -lt $Count) {
        if (((Get-Date).Hour -eq 0) -and ($NowCount -gt 13)) {
            $NowCount = 0
            $SuccessCount = 0
        }
        $NowCount++
        Write-Host ("No."+ $NowCount)
        $PostResult = ./PostIng.ps1 -Content $Content
        if ($PostResult -eq $true) {
            if ($SkipDel -eq $false) {
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
    }
    Write-Host "Waiting for 5 mins..."
    Start-Sleep -Seconds 305
}
