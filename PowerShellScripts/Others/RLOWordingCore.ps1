param (
    [string]$Content
)

$wording = $Content
$stringInfo = New-Object System.Globalization.StringInfo $wording 
$wordingArray = for ($i = 0; $i -lt $stringInfo.LengthInTextElements; $i++) {
    $stringInfo.SubstringByTextElements($i, 1)
}

$reverse = ""
if ($wordingArray.Count -eq 1) {
    $reverse = $wordingArray
} else {
    for ($i = $wordingArray.Count - 1; $i -ge 0; $i--) {
        <# Action that will repeat until the condition is met #>
        $reverse += $wordingArray[$i]
    }
}

$result = [char]0x202e  + $reverse
# 正文（原区域）恢复顺序
$result += [char]0x202d
# 系统文本恢复顺序
$result += [char]0x202d
return $result