#!/bin/bash
content=$1
cookieStr=$(cat ./Cookie)
res= curl --url "https://ing.cnblogs.com/ajax/ing/Publish" -X POST \
--header "Content-Type:application/x-www-form-urlencoded" \
--header "accept:application/json, text/javascript, */*; q=0.01" \
--header "accept-language:zh-CN,zh;q=0.9" \
--header "accept-encoding:gzip, deflate, br" \
--header "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36" \
--data "Content=${content}&publicFlag=0" \
--cookie ".Cnblogs.AspNetCore.Cookies=$cookieStr" | iconv -f utf-8
echo $res
resReg='{"isSuccess":(\s)?(true|false)'
echo $resReg
[[ $res =~ $resReg ]] && echo true
echo ${BASH_REMATCH[2]}

# res='{"isSuccess":true,"responseText":"111"}'
# resReg='{"isSuccess":(\s)?(true|false)'
# [[ $res =~ $resReg ]] && echo true