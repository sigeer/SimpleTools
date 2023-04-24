Write-Host "Input..."
$wording = Read-Host
$wordingArray = $wording -split ""
$result = ''
for ($i = 0; $i -lt $wordingArray.Count; $i++) {
    <# Action that will repeat until the condition is met #>
    $result = $result + $wordingArray[$i] + [char]0x202e
}
Write-Host $wordingArray.Count
Set-Clipboard -Value $result
Write-Host "Copied"