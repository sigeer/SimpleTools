#!/bin/bash
id=$1
cookieStr=$(cat ./Cookie)
res= curl --url "https://ing.cnblogs.com/ajax/ing/del" -X POST \
--header "Content-Type:application/x-www-form-urlencoded" \
--header "accept:application/json, text/javascript, */*; q=0.01" \
--header "accept-language:zh-CN,zh;q=0.9" \
--header "accept-encoding:gzip, deflate, br" \
--header "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36" \
--data "ingId=${id}" \
--cookie ".Cnblogs.AspNetCore.Cookies=$cookieStr" | iconv -f utf-8
echo "Id="$id" Delete."