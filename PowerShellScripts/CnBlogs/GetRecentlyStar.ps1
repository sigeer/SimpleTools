$Response = ./GetRequest.ps1 -Url "https://ing.cnblogs.com/ajax/ing/GetIngList?IngListType=All&PageIndex=1&PageSize=10&Tag=&_=$([System.DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds())"
if ($Response.StatusCode -eq 200) {
    $RegStr = '\<img(((?!img).|\n)*)title="([^\"]*星)'
    $IsMatched = $Response.Content -match $RegStr
    if ($IsMatched) {
        Write-Output $Matches[3]
    }
    else {
        Write-Host "没匹配到"
        Write-Output "Unknown"
    }
} else {
    Write-Host "请求失败"
    Write-Output "Unknown"
}