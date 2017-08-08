FROM centos:7

RUN yum install wget -y
RUN wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN pip install awscli

ADD test.sh .
RUN chmod +x test.sh
ADD test.py .
