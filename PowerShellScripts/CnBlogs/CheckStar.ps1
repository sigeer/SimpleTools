$Response = ./GetRequest.ps1 -Url "https://ing.cnblogs.com/ajax/ing/GetIngList?IngListType=my&PageIndex=1&PageSize=10&Tag=&_=$([System.DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds())"
if ($Response.StatusCode -eq 200) {
    $FirstMath = $Response.Content -match '<span class="ing_body" id="ing_body_(\d+)">'
    $NowId = $Matches[1]
    #Write-Host $Response.Content
    $RegStr = '<div class="feed_body" id="feed_content_'+$NowId+'">(((?!删除).|\n)*)\<img(\s)*alt=((?!\]).|\n)*星\]'
    $IsMatched = $Response.Content -match $RegStr
    if ($IsMatched) {
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