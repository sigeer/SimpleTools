#博客园删闪存
Param(
    [string]$Id
)

$PostBody = @{
    ingId = $Id
}
$Response = ./PostRequest.ps1 -Url "https://ing.cnblogs.com/ajax/ing/del" -PostBody $PostBody
if ($Response.StatusCode -eq 200) {
    Write-Host ($(Get-Date).ToString() + " Id=" + $Id + " " + $Response.Content)
}
else {
    Write-Host $Response.StatusCode
}

