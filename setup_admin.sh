#!/bin/bash
# run this script with "sudo bash setup_admin.sh"

# indicates if the install includes a front-end GUI
GUI="TRUE"

# indicates if a CUDA-enabled GPU is present
GPU="TRUE"

# allow automated installations
export DEBIAN_FRONTEND=noninteractive

# initial setup
sudo apt -y update
sudo apt -y upgrade
sudo apt -y install build-essential
sudo apt -y autoremove
sudo apt -y install wget
sudo apt -y install git
git config --global user.name "John Wittenauer"
git config --global user.email jdwittenauer@gmail.com

# install JDK
sudo apt -y install openjdk-11-jre openjdk-11-jdk

# install fortran compiler
sudo apt -y install gfortran

# install OpenCV libraries
sudo apt -y install libopencv-dev python-opencv

# install MySQL
sudo -E apt -q -y install mysql-server

# install Go
sudo apt -y install golang

# install Scala
cd ~/Downloads
wget "http://downloads.lightbend.com/scala/2.12.6/scala-2.12.6.deb"
sudo dpkg -i scala-2.12.6.deb
sudo apt -y update
sudo apt -y install scala
rm -rf scala-2.12.6.deb

# install sbt
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
sudo apt -y update
sudo apt -y install sbt

# install Mono
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt -y update
sudo apt -y install mono-devel

# install node.js
sudo apt -y install curl
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt -y install nodejs

# install Docker
sudo apt -y install apt-transport-https ca-certificates software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt -y update
sudo apt -y install docker-ce

# install Chrome
cd ~/Downloads
wget "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
sudo dpkg -i --force-depends google-chrome-stable_current_amd64.deb
sudo apt -y update
sudo apt -y install -f
printf "\nexport BROWSER=google-chrome" >> ~/.bashrc
rm -rf google-chrome-stable_current_amd64.deb

# install inconsolata font
sudo apt -y install fonts-inconsolata
sudo fc-cache -fv

# build OpenBLAS
cd ~
mkdir blas
cd blas
git clone https://github.com/xianyi/OpenBLAS
cd OpenBLAS
sudo make FC=gfortran
sudo make PREFIX=/usr/local install

if [ "$GUI" = "TRUE" ]
then
	# change backgroud image
	# adjust mouse speed
	# configure sound
	# install and configure tilda (height 100, width 100, transparency 40, always on top = FALSE, do not show in task bar = FALSE)
	sudo apt -y install tilda

	# install VS Code
	cd ~/Downloads
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
	sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
	sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
	sudo apt -y install apt-transport-https
	sudo apt -y update
	sudo apt -y install code
	sudo rm microsoft.gpg
fi

if [ "$GPU" = "TRUE" ]
then
	# install gcc
	sudo apt -y install gcc-6
	sudo apt -y install g++-6

	# update GPU driver
	sudo add-apt-repository ppa:graphics-drivers/ppa -y
	sudo apt -y update
	sudo apt -y upgrade
	sudo apt -y autoremove

	# install cuda
	cd ~/Downloads
	wget "https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb"
	sudo dpkg -i cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb
	sudo apt-key add /var/cuda-repo-9-0-local/7fa2af80.pub
	sudo apt -y update
	sudo apt -y install cuda
	printf "\nexport CUDA_HOME=/usr/local/cuda" >> ~/.bashrc
	printf "\nexport CUDA_ROOT=/usr/local/cuda" >> ~/.bashrc
	printf "\nexport PATH=\$PATH:/usr/local/cuda/bin" >> ~/.bashrc
	source ~/.bashrc

	# install cudnn
	# login to nvidia developer and download for linux
	cd ~/Downloads
	tar xvzf cudnn-9.0-linux-x64-v7.2.1.38.tgz
	sudo cp -P cuda/include/cudnn.h /usr/local/cuda/include
	sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda/lib64
	sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
	printf "\nexport LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64" >> ~/.bashrc
	source ~/.bashrc

	# clean up downloaded files
	cd ~/Downloads
	sudo rm -rf cuda
	sudo rm cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb
	sudo rm cudnn-9.0-linux-x64-v7.2.1.38.tgz
fi

sudo apt -y autoremove
