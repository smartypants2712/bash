#!/bin/bash

sudo yum install -y gcc zlib zlib-devel openssl openssl-devel
wget https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tgz
tar -xzvf Python-3.6.1.tgz
cd Python-3.6.1 && ./configure && make
sudo make install
sudo /usr/local/bin/pip3 install virtualenv

