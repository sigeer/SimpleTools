param (
    [array]$Array,
    [System.Object]$Item
)

$index = $Array.IndexOf($Item)
if ($index -eq $Array.Count - 1) {
    return $Array[0]
}
return $Array[$index + 1]