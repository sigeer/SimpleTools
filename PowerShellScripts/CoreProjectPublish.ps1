$dir = Read-Host "dir"
$newDir = Read-Host "new dir"
$appOfflineHtml = Join-Path $dir "app_offline.html"
Set-Content -Path $appOfflineHtml -Value "waiting for 3s..."
Start-Sleep -Seconds 3
Copy-Item -Path "${newDir}\*" -Destination $dir -Recurse -Force
Remove-Item -Path $appOfflineHtml