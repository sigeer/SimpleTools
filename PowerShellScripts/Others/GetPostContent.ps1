param (
    $Tag = $null,
    $Content = $null,
    $Suffix = $null,
    $ShowStar = $false
)
$text = $Content
$starOrder = "秋意星", "跳舞星", "文艺写码星", "摸鱼星", "VIP代言星", "得意星", "调皮星", "微笑星", "可爱星", "奋斗星"
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
if ($ShowStar) {
    $recentlyStar = ./GetRecentlyStar.ps1
    $nextStar = ./GetNextFromArray -Array $starOrder -Item $recentlyStar
    if ($nextStar -ne "Unknown") {
        $text = $text -replace '\[Star\]', $nextStar
    }
}
return $text.TrimStart()