FROM centos:7

RUN yum install wget -y
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN pip install setuptools


RUN mkdir /app
WORKDIR /app
ARG PACKAGENAME
ADD build.sh .
RUN chmod +x build.sh
RUN mkdir $PACKAGENAME
ADD /$PACKAGENAME/* ./$PACKAGENAME/
RUN ls -al $PACKAGENAME
ADD setup.py .
