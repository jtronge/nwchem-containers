#!/bin/sh

# Install Charliecloud
CWD=`pwd`
cd /tmp
curl -O -L https://github.com/hpc/charliecloud/releases/download/v0.25/charliecloud-0.25.tar.gz
tar -xvf charliecloud-0.25.tar.gz
cd charliecloud-0.25
./configure --prefix=$HOME || exit 1
make || exit 1
make install || exit 1
export PATH=$HOME/bin:$PATH

cd $CWD
./build-all.sh
