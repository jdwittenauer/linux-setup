#!/bin/bash

# WSL commands:
# list: wsl -l -v
# install: wsl --install -d Ubuntu-22.04
# uninstall: wsl --unregister Ubuntu-22.04

# run this script with "sudo bash setup_wsl.sh"

# allow automated installations
export DEBIAN_FRONTEND=noninteractive

# initial setup
sudo apt -y update
sudo apt -y upgrade
sudo apt -y install build-essential
git config --global user.name "John Wittenauer"
git config --global user.email jdwittenauer@gmail.com

# install MySQL
sudo apt -y install mysql-server

# install node.js
sudo apt -y install nodejs
sudo apt -y install npm

# install CUDA
sudo apt-key del 7fa2af80
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.1.1/local_installers/cuda-repo-wsl-ubuntu-12-1-local_12.1.1-1_amd64.deb
sudo dpkg -i cuda-repo-wsl-ubuntu-12-1-local_12.1.1-1_amd64.deb
sudo cp /var/cuda-repo-wsl-ubuntu-12-1-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt -y update
sudo apt -y install cuda
sudo rm cuda-repo-wsl-ubuntu-12-1-local_12.1.1-1_amd64.deb

# clean up old packages
sudo apt -y autoremove

# initial setup
cd ~
mkdir source
mkdir data

# install Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda
rm Miniconda3-latest-Linux-x86_64.sh
conda init bash

# download additional git repos
cd ~/source
git clone https://github.com/jdwittenauer/alpha
git clone https://github.com/jdwittenauer/colab
git clone https://github.com/jdwittenauer/blogit
git clone https://github.com/jdwittenauer/dotnet-sandbox
git clone https://github.com/jdwittenauer/hackerrank
git clone https://github.com/jdwittenauer/hadoop-training
git clone https://github.com/jdwittenauer/insight-net
git clone https://github.com/jdwittenauer/ipython-notebooks
git clone https://github.com/jdwittenauer/kaggle
git clone https://github.com/jdwittenauer/linux-setup
git clone https://github.com/jdwittenauer/littlecompiler
git clone https://github.com/jdwittenauer/or-tools-examples
git clone https://github.com/jdwittenauer/ppm-cut-detection
git clone https://github.com/jdwittenauer/projecteuler-solutions
git clone https://github.com/jdwittenauer/sandbox
git clone https://github.com/jdwittenauer/selforganizingmap-demo
git clone https://github.com/jdwittenauer/twitter-viz-demo