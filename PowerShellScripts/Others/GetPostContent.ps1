param (
    $Tag = $null,
    $Content = $null,
    $Suffix = $null
)
$text = $Content
if ([string]::IsNullOrEmpty($Content) -and (Test-Path Wording.txt)) {
    $text = $($(Get-Content ./Wording.txt) -split "\r\n") | Get-Random
}
if (![string]::IsNullOrEmpty($Tag)) {
    $text = "[" + $Tag + "]" + " " + $text.TrimStart()
}
if ([string]::IsNullOrEmpty($Content)) {
    $text = "[标签]"
}
if (![string]::IsNullOrEmpty($Suffix)) {
    $tmpSufix = ./RLOWordingCore.ps1 -Content $Suffix
    $text = $text + " " + $tmpSufix + " "
}

return $text.TrimStart()