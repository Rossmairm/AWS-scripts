#!/bin/bash

echo "" > public.txt

for i in $(cat envs); do
    echo "" > $i.txt
done

for j in $(cat envs);do
    aws ec2 describe-network-interfaces --profile $j | jq '.NetworkInterfaces | .[] | .PrivateIpAddresses | .[] | .PrivateIpAddress' | cut -d'"' -f2 >> $j.txt
    aws ec2 describe-network-interfaces --profile $j | jq '.NetworkInterfaces | .[] | .PrivateIpAddresses | .[] | .Association.PublicIp'| cut -d'"' -f2 | grep -v null >> public.txt
    python ~/Dev/Nessus-Scripts/asset_upload.py $j
done

python ~/Dev/Nessus-Scripts/asset_upload.py public
