while ($true) {
    Write-Host "Input..."
    $wording = Read-Host
    $result = ./RLOWordingCore.ps1 -Content $wording
    Set-Clipboard -Value $result
    Write-Host "Copied"
}
