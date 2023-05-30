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

GetStar1 -Count [default: 10, 数量] 
         -Tag [string, 标签] 
         -Content [string, default: 读取Wording.txt随机行] 
         -Suffix [string, 通过RLO字符，将内容移到末尾] 
         -LessThan[default: 0, 控制星星小于等于排名榜第n名，0时不启用]
         -From[default: 0,已经获取了n颗，计数中断后使用]
         # 关键词
         #[Star]：当前将触发的星星 
         #[SuccessCount]：已获取的星星数（包括当前发送的这条） 
         #[NowCount]：累计发送了多少条 
         #[Rate]：触发几率
```
