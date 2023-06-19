Param(
    [string]$Content,
    [bool]$IsPrivate = $false
)

$PostBody = @{
    Content    = $Content
    publicFlag = $(if($IsPrivate){0}else{1})
}
$Response = ./PostRequest.ps1 -Url "https://ing.cnblogs.com/ajax/ing/Publish" -PostBody $PostBody
$Res = $Response.Content | ConvertFrom-Json
Write-Host "PostResult: " $Response.Content
if ($Response.StatusCode -eq 200 -and $Res.isSuccess -eq $true) {
    Write-Output $true
} else {
    Write-Output $false
}

