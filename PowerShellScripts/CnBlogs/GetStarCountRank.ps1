param (
    [int]$Rank = 1
)

$Response = ./GetRequest.ps1 -Url "https://ing.cnblogs.com/ajax/ing/SideRight?_=$([System.DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds())"
if ($Response.StatusCode -eq 200) {
    $RegStr = '<span style="font-size:11px;color:gray;">([0-9]*)颗星</span>'
    $matchResult = [regex]::Matches($Response.Content, $RegStr)
    if ($matchResult.Count -lt $Rank) {
        Write-Host "人太少了，谨慎"
        Write-Host -1
    } else {
        Write-Output $matchResult[$Rank - 1].Groups[1].Value
    }
} else {
    Write-Host "请求失败"
    Write-Output -1
}