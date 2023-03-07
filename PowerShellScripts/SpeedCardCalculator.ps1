param (
    [double]$BaseSpeed = 1100,
    [double]$TakticalBuff = 0.15,
    [double]$SpeedCardBuff = 0.08,
    [double]$AgileCardBuff = 0.1
)

$SpeedCard = ($BaseSpeed * $SpeedCardBuff) * (1 + $TakticalBuff)+ $BaseSpeed * (1 + $TakticalBuff);
$AgileCard = ($BaseSpeed * $AgileCardBuff) + $BaseSpeed  * (1 + $TakticalBuff);
$ComparedResult = $SpeedCard - $AgileCard

Write-Host "SpeedCard Value is $SpeedCard"
Write-Host "AgileCard Value is $AgileCard"
Write-Host $([Math]::Round($ComparedResult, 2))
