$PostParameters = @{
    Uri             = "https://ing.cnblogs.com/ajax/ing/GetIngList?IngListType=All&PageIndex=1&PageSize=10&Tag=&_=$([System.DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds())"
    Method          = 'GET'
    Headers         = @{
        "accept"       = "text/plain, */*; q=0.01"
        "accept-language" = "zh-CN,zh;q=0.9"
        "accept-encoding" = "gzip, deflate, br"
        "content-type" = "application/json; charset=utf-8"
        "referer"       = "https://ing.cnblogs.com/"
        "x-requested-with" = "XMLHttpRequest"
    }
    UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36"
}
$WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$CookieStr = Get-Content ./Cookie
$AuthCookie = New-Object System.Net.Cookie(".Cnblogs.AspNetCore.Cookies", $CookieStr, "/", "cnblogs.com")
$WebSession.Cookies.Add($AuthCookie)
$Response = Invoke-WebRequest @PostParameters -WebSession $WebSession
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