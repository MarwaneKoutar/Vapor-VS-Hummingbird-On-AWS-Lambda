FROM swift:amazonlinux2

RUN yum -y install openssl-devel zip

COPY . /tmp/VaporApp
