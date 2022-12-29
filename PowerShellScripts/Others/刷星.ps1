#./刷星.ps1 -Count 5
param (
    [int]$Count,
    [bool]$SkipDel
)
Write-Host "=======开始======="
$NowCount = 0
$SuccessCount = 0
while ( $SuccessCount -lt $Count) {
    $NowCount++
    Write-Host ("第"+ $NowCount +"次")
    $PostContent = "神器在手，星星我有"
    $PostResult = ./PostIng.ps1 -Content $PostContent
    if ($PostResult -eq $true) {
        if ($SkipDel -eq $false) {
            $Id = ./CheckStar.ps1
            if ($Id -ne 0) {
                ./DelIng.ps1 -Id $Id
            } else {
                $SuccessCount++ 
            }
        }
    }
    Write-Host "等待5分钟..."
    Start-Sleep -Seconds 310
}
