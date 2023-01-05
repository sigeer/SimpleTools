#博客园删闪存
Param(
    [string]$Id
)

$PostBody = @{
    ingId = $Id
}
$PostParameters = @{
    Uri       = "https://ing.cnblogs.com/ajax/ing/del"
    Method    = 'POST'
    Body      = $PostBody
    Headers   = @{
        "accept"          = "application/json, text/javascript, */*; q=0.01"
        "accept-language" = "zh-CN,zh;q=0.9"
        "accept-encoding" = "gzip, deflate, br"
        "Content-Type"    = "application/x-www-form-urlencoded"
    }
    UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36"

}
$WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$CookieStr = Get-Content ./Cookie
$AuthCookie = New-Object System.Net.Cookie(".Cnblogs.AspNetCore.Cookies", $CookieStr, "/", "cnblogs.com")
$WebSession.Cookies.Add($AuthCookie)
$Response = Invoke-WebRequest @PostParameters -WebSession $WebSession
if ($Response.StatusCode -eq 200) {
    Write-Host ($(Get-Date).ToString() + ": Id=" + $Id + " " + $Response.Content)
}
else {
    Write-Host $Response.StatusCode
}

