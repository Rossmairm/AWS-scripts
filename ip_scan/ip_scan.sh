#!/bin/bash

echo "" > public.txt
if [ "$#" -gt  2 ];then
    echo ""
    echo "Usage: ./ip_scan.sh {path-to-region-list} {OPTIONAL Path-to-asset_upload.py}"
    echo ""
    echo "Region file path can be replaced with the word 'default' to use AWS conf defaults"
    echo ""
    exit
fi



if [ -z $2 ];then
    path=~/Dev/Nessus-Scripts/asset_upload.py
    echo "Path set to " $path
else
    path=$2
fi


for i in $(cat envs); do
    echo "" > $i.txt
done

for j in $(cat envs);do
    if [ -z $1 ] || [ "$1" == "default"  ]; then
        aws ec2 describe-network-interfaces --profile $j | jq '.NetworkInterfaces | .[] | .PrivateIpAddresses | .[] | .PrivateIpAddress' | cut -d'"' -f2 >> $j.txt
        aws ec2 describe-network-interfaces --profile $j | jq '.NetworkInterfaces | .[] | .PrivateIpAddresses | .[] | .Association.PublicIp'| cut -d'"' -f2 | grep -v null >> public.txt
    else
        for r in $(cat $1);do
            aws ec2 describe-network-interfaces --region $r --profile $j | jq '.NetworkInterfaces | .[] | .PrivateIpAddresses | .[] | .PrivateIpAddress' | cut -d'"' -f2 >> $j.txt
            aws ec2 describe-network-interfaces --region $r --profile $j | jq '.NetworkInterfaces | .[] | .PrivateIpAddresses | .[] | .Association.PublicIp'| cut -d'"' -f2 | grep -v null >> public.txt
        done
    fi
python $path $j
done
python $path public
