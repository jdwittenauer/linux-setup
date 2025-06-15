#!/bin/bash

# WSL commands:
# list: wsl -l -v
# install: wsl --install -d Ubuntu-22.04
# uninstall: wsl --unregister Ubuntu-22.04
# shutdown: wsl --shutdown

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

# install Node
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install v20.10.0

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
printf "\nexport PATH=\$HOME/miniconda/bin:\$PATH" >> ~/.bashrc
printf "\nexport LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/home/jdwittenauer/miniconda/envs/deep_learning_env/lib" >> ~/.bashrc
source ~/.bashrc
conda init bash

# download additional git repos
cd ~/source
git clone https://github.com/jdwittenauer/ai-news-agent
git clone https://github.com/jdwittenauer/alpha
git clone https://github.com/jdwittenauer/colab
git clone https://github.com/jdwittenauer/blogit
git clone https://github.com/jdwittenauer/dotnet-sandbox
git clone https://github.com/jdwittenauer/hackerrank
git clone https://github.com/jdwittenauer/hadoop-training
git clone https://github.com/jdwittenauer/insight-net
git clone https://github.com/jdwittenauer/ionyx
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