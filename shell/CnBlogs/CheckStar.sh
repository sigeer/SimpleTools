#!/bin/bash
id=$1
cookieStr=$(cat ./Cookie)
res= curl --url "https://ing.cnblogs.com/ajax/ing/GetIngList?IngListType=my&PageIndex=1&PageSize=1&Tag=&_=1672192314675" -X GET \
--header "Content-Type:application/json; charset=utf-8" \
--header "accept:text/plain, */*; q=0.01" \
--header "accept-language:zh-CN,zh;q=0.9" \
--header "accept-encoding:gzip, deflate, br" \
--header "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36" \
--header "x-requested-with:XMLHttpRequest" \
--cookie ".Cnblogs.AspNetCore.Cookies=$cookieStr" | iconv -f "UTF-8"

idReg='<span class="ing_body" id="ing_body_([0-9]+)">'
[[ $res =~ $idReg ]]
nowId= ${BASH_REMATCH[1]}
checkReg='<bdo><span class="ing_body" id="ing_body_'$nowId'">(((?!(img)).|\n)*)</bdo>(((?!\>).|\n)*)\<img'
if [[ $res =~ $checkReg ]]; then
echo -e "\e[32m ~~~有星星 \e[0m"
echo 0
else
echo -e "\e[31m ---没星星 \e[0m"
echo $nowId
fi