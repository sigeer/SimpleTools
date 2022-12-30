#./刷星.ps1 -Count 5
count=$1
skipDel=$2
echo "=======开始======="
nowCount = 0
successCount = 0
while [[ $successCount < $count]] 
do
    $nowCount++
    echo ("第"+ $nowCount +"次")
    postContent= "[搞事] 此处有星，禁止吐痰。"
    postResult = ./PostIng.sh $postContent
    if [[$postResult == $true]]; then
        if [[$skipDel == $false]]; then
            $Id = ./CheckStar.sh
            if [[$Id != 0]]; then
                ./DelIng.sh $Id
            else
                $successCount++ 
            fi
        fi
    fi
    echo "等待5分钟..."
    sleep 305s
done
