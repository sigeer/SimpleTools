param (
    [string]$Path
)

function Remove-Core {
    param (
        [string]$Dir
    )
    
    $items = "bin", "obj", "logs", "node_modules";
    foreach ($item in $items) {
        $final = Join-Path -Path $Dir -ChildPath $item
        if (Test-Path $final -PathType Container) {
            Remove-Item $final -Recurse
            Write-Information "Delete Success: $final"
        }
    }

    $dirList = Get-Childitem $Dir | Where-Object { Test-Path -Path $_ -PathType Container }
    foreach ($dir in $dirList) {
        Remove-Core -Dir $dir
    }
}
if (!$(Test-Path $Path)) {
    Write-Error "Path: $Path Not Exsited"
    return
}
Remove-Core -Dir $Path
