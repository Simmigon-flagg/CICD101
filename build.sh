#!/bin/bash

filename=$1
version=$2
packageName=$3
packageFolder=$4

tokenVersion="#{packageVersion}"
tokenName="#{packageName}"

# Replace the version token in the script.
sed -i s/$tokenVersion/$version/g ./$packageFolder/$filename

# Version and name the setup.py
sed -i s/$tokenVersion/$version/g ./setup.py
sed -i s/$tokenName/$packageFolder/g ./setup.py


# package the files
python setup.py sdist

# change file ownership on host filesystem so it can be cleaned up later
chmod -R 777 ./dist
ls -al ./dist

# Run unit tests
python ./$packageFolder/$filename -v
if [ $? -eq 0 ]
then
    echo "Unit tests passed"
else
    echo "Unit tests failed"
    exit 1
fi
