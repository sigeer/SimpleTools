# 博客园闪存刷星用

需要在`刷星.ps1`同级目录下配置`Cookie`文件，内容为最新Cookie

```PowerShell
# 发送闪存
PostIng.ps1 -Content String
# 删除闪存
DelIng.ps1 -Id Number
# 判断有无星星
CheckStar.ps1 [Result: 0 = ok, -ne 0 = fail]

./GetStar.ps1 -Content（文本） -Count （刷多少颗星，默认10） -SkipDel （true => 没有星的闪存将不会被删除， 默认false）
./GetStar.ps1
```
