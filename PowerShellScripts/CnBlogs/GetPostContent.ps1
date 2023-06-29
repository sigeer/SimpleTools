param (
    $Content = $null,
    $Suffix = $null,
    $Pool = "./wording_default.txt"
)
$text = $Content
$starOrder = "秋意星", "跳舞星", "文艺写码星", "摸鱼星", "VIP代言星", "得意星", "调皮星", "微笑星", "可爱星", "奋斗星"
if ([string]::IsNullOrEmpty($Content)) {
    if (![string]::IsNullOrEmpty($Pool) -and (Test-Path $Pool)) {
        $text = $($(Get-Content $Pool) -split "\r\n") | Get-Random
    } else {
        $text = "[标签]"
    }

}
if (![string]::IsNullOrEmpty($Suffix)) {
    $tmpSufix = ./RLOWordingCore.ps1 -Content $Suffix
    $text = $text + " " + $tmpSufix + " "
} else {
    $matchSufixReg = '(((?!\[\-).|\n)*)(\[\-([^\]]*)\])(.*)'
    $matchResult = [regex]::Match($text, $matchSufixReg)
    if ($matchResult.Success) {
        $Suffix = $text -replace $matchSufixReg, $matchResult.Groups[4].Value
        $tmpSufix = ./RLOWordingCore.ps1 -Content $Suffix
        $text = $matchResult.Groups[4].Value + $matchResult.Groups[5].Value + " " + $tmpSufix + " "
    }
}
if ($text.Contains("[Star]")) {
    $recentlyStar = ./GetRecentlyStar.ps1
    $nextStar = ./GetNextFromArray -Array $starOrder -Item $recentlyStar
    if ($nextStar -ne "Unknown") {
        $text = $text -replace '\[Star\]', $nextStar  #这里实际上是正则替换，所以不能直接用[Star]
    }
}
return $text.TrimStart()