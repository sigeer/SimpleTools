# 博客园闪存刷星用

需要在`GetStar.ps1`同级目录下配置`Cookie`文件，内容为网站Cookie

```PowerShell
# 发送闪存
PostIng.ps1 -Content String -IsPrivate [default: false, 是否私有]
# 删除闪存
DelIng.ps1 -Id Number
# 判断有无星星
CheckStar.ps1 [Result: 0 = ok, -ne 0 = fail]

#获取最近出的星星，第一页没有则unknown
GetRecentlyStar.ps1 

GetStar1 -Count [default: 1, 数量] 
         -Tag [int, 标签] 
         -Content [string, default: 读取Wording.txt随机行] 
         -ShowStar [defalut: false, 显示当前星星，另外还需要在Content中增加[Star]用于替换]
         -Suffix [string, 通过RLO字符，将内容移到末尾] 
         -LessThan[default: -1, 控制星星小于等于排名榜第n名，-1时不启用]

./GetStar.ps1 -Content（文本） -Count （刷多少颗星，默认10） -SkipDel （true => 没有星的闪存将不会被删除， 默认false）
./GetStar.ps1
```
