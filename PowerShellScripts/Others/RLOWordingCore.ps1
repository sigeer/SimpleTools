param (
    [string]$Content
)

$wording = $Content
$wordingArray = $wording -split ""
$result = [char]0x202e 
for ($i = $wordingArray.Count - 1; $i -gt 0; $i--) {
    <# Action that will repeat until the condition is met #>
    $result += $wordingArray[$i]
}
# 正文（原区域）恢复顺序
$result += [char]0x202d
# 系统文本恢复顺序
$result += [char]0x202d
return $result
