while ($true) {
    Write-Host "Input..."
    $wording = Read-Host
    $wordingArray = $wording -split ""
    $result = ''
    for ($i = $wordingArray.Count - 1; $i -gt 0; $i--) {
        <# Action that will repeat until the condition is met #>
        $result = $result + $wordingArray[$i] + [char]0x202e
    }
    $result += [char]0x202d
    $result += [char]0x202d
    Set-Clipboard -Value $result
    Write-Host "Copied"
}
