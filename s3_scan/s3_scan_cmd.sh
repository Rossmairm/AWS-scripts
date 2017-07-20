#!/bin/bash
buckets=$(aws s3api list-buckets --profile $1 |jq '.Buckets |.[].Name' | cut -d'"' -f2)
for s3 in $buckets ; do
    objects=$(aws s3api list-objects --bucket $s3  --profile $1 | jq '.Contents|.[] | .Key'| cut -d '"' -f2)
    for ob in $objects;do
        if [ -n "$(aws s3api get-object-acl --bucket $s3 --key $ob  --profile $1  | grep AllUsers)" ]; then
            echo "$s3 $ob"
    fi
    done
done
