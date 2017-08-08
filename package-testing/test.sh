#!/bin/bash

packagepath=$1
filename=$2

/usr/bin/aws s3 cp s3://$packagepath$filename .

pip install $filename

python test.py
