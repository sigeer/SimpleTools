# 博客园闪存刷星用

需要配置Cookie

```PowerShell
# 发送闪存
PostIng.ps1 -Content String
# 删除闪存
DelIng.ps1 -Id Number
# 判断有无星星
CheckStar.ps1 [Result: 0 = ok, -ne 0 = fail]
./刷星.ps1 -Count 5 -SkipDel $true
```
