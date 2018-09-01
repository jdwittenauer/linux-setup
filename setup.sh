#!/bin/bash
# run this script with "source setup.sh"

# indicates if the install includes a front-end GUI
GUI="TRUE"

# indicates if a CUDA-enabled GPU is present
GPU="TRUE"

# allow automated installations
export DEBIAN_FRONTEND=noninteractive

# initial setup
cd ~
mkdir git
mkdir data
mkdir temp
mkdir go
cd go
mkdir workspace

# add Go path variables
printf "\nexport GOROOT=/usr/lib/go" >> ~/.bashrc
printf "\nexport GOPATH=\$HOME/go/workspace" >> ~/.bashrc
printf "\nexport PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin" >> ~/.bashrc
source ~/.bashrc

# install Julia
cd ~/Downloads
wget "https://julialang-s3.julialang.org/bin/linux/x64/1.0/julia-1.0.0-linux-x86_64.tar.gz"
tar xvzf julia-1.0.0-linux-x86_64.tar.gz
mv ~/Downloads/julia-1.0.0 ~/julia
printf "\nexport PATH=\$PATH:\$HOME/julia/bin" >> ~/.bashrc
source ~/.bashrc
rm -rf julia-1.0.0-linux-x86_64.tar.gz

# install Anaconda
cd ~/Downloads
wget "https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh"
bash Anaconda3-5.2.0-Linux-x86_64.sh -b -p $HOME/anaconda
printf "\nexport PATH=\$PATH:\$HOME/anaconda/bin" >> ~/.bashrc
source ~/.bashrc
rm Anaconda3-5.2.0-Linux-x86_64.sh

# install additional packages
conda update -y conda
conda update -y anaconda
conda update -y --all
conda install -y biopython
conda install -y gensim
conda install -y opencv
conda install -y pydot
conda install -y pyodbc
conda install -y scrapy
conda install -y seaborn
conda install -y spacy
~/anaconda/bin/pip install --upgrade pip
~/anaconda/bin/pip install celery
~/anaconda/bin/pip install deap
~/anaconda/bin/pip install fbprophet
~/anaconda/bin/pip install keras
~/anaconda/bin/pip install hyperopt
~/anaconda/bin/pip install ortools
~/anaconda/bin/pip install pattern
~/anaconda/bin/pip install pymc3
~/anaconda/bin/pip install pyro-ppl
~/anaconda/bin/pip install pystan
~/anaconda/bin/pip install xgboost

# install and configure jupyter theme
~/anaconda/bin/pip install jupyterthemes
jt -t chesterish -fs 10 -ofs 95 -cellw 80% -lineh 130 -T

# install tensor libraries
~/anaconda/bin/pip install --upgrade --ignore-installed setuptools
if [ "$GPU" = "TRUE" ]
then
	conda install -y pytorch torchvision -c pytorch
	~/anaconda/bin/pip install tensorflow-gpu
else
	conda install -y pytorch-cpu torchvision-cpu -c pytorch
	~/anaconda/bin/pip install tensorflow
fi

# download and install custom library
cd ~/git
git clone https://github.com/jdwittenauer/ionyx
cd ~/git/ionyx
~/anaconda/bin/python setup.py develop

if [ "$GUI" = "TRUE" ]
then
	# install extensions for VS code
	code --install-extension formulahendry.code-runner
	code --install-extension formulahendry.vscode-mysql
	code --install-extension julialang.language-julia
	code --install-extension msjsdiag.debugger-for-chrome
	code --install-extension ms-python.python
	code --install-extension ms-vscode.cpptools
	code --install-extension ms-vscode.csharp
	code --install-extension ms-vscode.Go
	code --install-extension PeterJausovec.vscode-docker
	code --install-extension PKief.material-icon-theme
	code --install-extension scala-lang.scala
	code --install-extension vscjava.vscode-java-pack

	# download additional git repos
	cd ~/git
	git clone https://github.com/jdwittenauer/alpha
	git clone https://github.com/jdwittenauer/blogit
	git clone https://github.com/jdwittenauer/dotnet-sandbox
	git clone https://github.com/jdwittenauer/hackerrank
	git clone https://github.com/jdwittenauer/hadoop-training
	git clone https://github.com/jdwittenauer/insight-net
	git clone https://github.com/jdwittenauer/ipython-notebooks
	git clone https://github.com/jdwittenauer/kaggle
	git clone https://github.com/jdwittenauer/linux-setup
	git clone https://github.com/jdwittenauer/little-compiler
	git clone https://github.com/jdwittenauer/or-tools-examples
	git clone https://github.com/jdwittenauer/ppm-cut-detection
	git clone https://github.com/jdwittenauer/projecteuler-solutions
	git clone https://github.com/jdwittenauer/sandbox
	git clone https://github.com/jdwittenauer/selforganizingmap-demo
	git clone https://github.com/jdwittenauer/twitter-viz-demo
fi
