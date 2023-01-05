$PostParameters = @{
    Uri             = "https://ing.cnblogs.com/ajax/ing/GetIngList?IngListType=my&PageIndex=1&PageSize=1&Tag=&_=1672192314675"
    Method          = 'GET'
    Headers         = @{
        "accept"       = "text/plain, */*; q=0.01"
        "accept-language" = "zh-CN,zh;q=0.9"
        "accept-encoding" = "gzip, deflate, br"
        "content-type" = "application/json; charset=utf-8"
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
    $FirstMath = $Response.Content -match '<span class="ing_body" id="ing_body_(\d+)">'
    $NowId = $Matches[1]
    $RegStr = '<bdo><span class="ing_body" id="ing_body_'+$NowId+'">(((?!(img)).|\n)*)</bdo>(((?!\>).|\n)*)\<img alt="\[((?!\]).|\n)*星\]"'
    $IsMatched = $Response.Content -match $RegStr
    if ($IsMatched -eq $true) {
        Write-Host $(Get-Date)"~~~有星星" -ForegroundColor Green
        Write-Output 0
    }
    else {
        Write-Host $(Get-Date)"---没星星" -ForegroundColor Red
        Write-Output $NowId
    }
} else {
    Write-Host $Response.StatusCode
    Write-Output -1
}