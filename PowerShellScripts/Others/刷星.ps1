#./ˢ��.ps1 -Count 5
param (
    [int]$Count,
    [bool]$SkipDel
)
Write-Host "=======��ʼ======="
$NowCount = 0
$SuccessCount = 0
while ( $SuccessCount -lt $Count) {
    $NowCount++
    Write-Host ("��"+ $NowCount +"��")
    $PostContent = "�������֣���������"
    $PostResult = ./PostIng.ps1 -Content $PostContent
    if ($PostResult -eq $true) {
        if ($SkipDel -eq $false) {
            $Id = ./CheckStar.ps1
            if ($Id -ne 0) {
                ./DelIng.ps1 -Id $Id
            } else {
                $SuccessCount++ 
            }
        }
    }
    Write-Host "�ȴ�5����..."
    Start-Sleep -Seconds 310
}
