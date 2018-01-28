#!/bin/bash
# run this script with "sudo bash setup_admin.sh"

# indicates if the install includes a front-end GUI
GUI="TRUE"

# indicates if a CUDA-enabled GPU is present
GPU="TRUE"

# allow automated installations
export DEBIAN_FRONTEND=noninteractive

if [ "$GUI" = "TRUE" ]
then
	# change backgroud image
	# adjust mouse speed
	# install and configure tilda (height 100, width 100, transparency 40, always on top = FALSE)
	# pin to task bar by finding via search and dragging to bar
	sudo apt-get -y install tilda
fi

# initial setup
cd ~
mkdir blas
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install build-essential
sudo apt-get -y autoremove
sudo apt-get -y install wget
sudo apt-get -y install git
git config --global user.name "John Wittenauer"
git config --global user.email jdwittenauer@gmail.com

# install JDK and Fortran compiler
sudo apt-get -y install openjdk-8-jre openjdk-8-jdk
sudo apt-get -y install gfortran

# install Scala
wget "http://downloads.lightbend.com/scala/2.12.4/scala-2.12.4.deb"
sudo dpkg -i scala-2.12.4.deb
sudo apt-get -y update
sudo apt-get -y install scala
rm -rf scala-2.12.4.deb

# install sbt
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
sudo apt-get -y update
sudo apt-get -y install sbt

# install Go
sudo add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
sudo apt-get -y update
sudo apt-get -y install golang

# build OpenBLAS
cd ~/blas
git clone https://github.com/xianyi/OpenBLAS
cd OpenBLAS
sudo make FC=gfortran
sudo make PREFIX=/usr/local install

# install OpenCV libraries
sudo apt-get -y install libopencv-dev python-opencv

# install Chrome
# pin to task bar by finding via search and dragging to bar
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i --force-depends google-chrome-stable_current_amd64.deb
sudo apt-get -y update
sudo apt-get -y install -f
printf "\nexport BROWSER=google-chrome" >> ~/.bashrc

# install inconsolata font
sudo apt-get -y install fonts-inconsolata
sudo fc-cache -fv
sudo apt-get -y autoremove

if [ "$GPU" = "TRUE" ]
then
	# update GPU driver
	sudo add-apt-repository ppa:graphics-drivers/ppa -y
	sudo apt-get -y update
	sudo apt-get -y upgrade
	sudo apt-get -y autoremove

	# install cuda
	cd ~/Downloads
	wget "https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb"
	sudo dpkg -i cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb
	sudo apt-key add /var/cuda-repo-9-0-local/7fa2af80.pub
	sudo apt-get -y update
	sudo apt-get -y install cuda
	printf "\nexport CUDA_HOME=/usr/local/cuda" >> ~/.bashrc
	printf "\nexport CUDA_ROOT=/usr/local/cuda" >> ~/.bashrc
	printf "\nexport PATH=\$PATH:/usr/local/cuda/bin" >> ~/.bashrc
	source ~/.bashrc

	# install cudnn
	# login to nvidia developer and download https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.0.5/prod/9.0_20171129/cudnn-9.0-linux-x64-v7
	cd ~/Downloads
	tar xvzf cudnn-9.0-linux-x64-v7.tgz
	sudo cp -P cuda/include/cudnn.h /usr/local/cuda/include
	sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda/lib64
	sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
	printf "\nexport LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64" >> ~/.bashrc
	source ~/.bashrc

	# clean up downloaded files
	cd ~/Downloads
	sudo rm -rf cuda
	sudo rm cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb
	sudo rm cudnn-9.0-linux-x64-v7.tgz
fi
