#!/bin/bash
# run this script with "source setup.sh"

# indicates if the install includes a front-end GUI
GUI="TRUE"

# indicates if a CUDA-enabled GPU is present
GPU="TRUE"

# allow automated installations
export DEBIAN_FRONTEND=noninteractive
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

# install Anaconda and update packages
cd ~/Downloads
wget "https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh"
bash Anaconda3-5.0.1-Linux-x86_64.sh -b -p $HOME/anaconda
printf "\nexport PATH=\$PATH:\$HOME/anaconda/bin" >> ~/.bashrc
source ~/.bashrc
rm Anaconda3-5.0.1-Linux-x86_64.sh
conda update -y conda
conda update -y anaconda
conda update -y --all
conda install -y biopython
conda install -y gensim
conda install -y pydot
conda install -y pyodbc
conda install -y scrapy
conda install -y seaborn
conda install -y spacy
conda install -y opencv
~/anaconda/bin/pip install --upgrade pip
~/anaconda/bin/pip install --upgrade --ignore-installed setuptools
~/anaconda/bin/pip install celery
~/anaconda/bin/pip install deap
~/anaconda/bin/pip install hyperopt
~/anaconda/bin/pip install pattern
~/anaconda/bin/pip install flask-socketio
~/anaconda/bin/pip install pystan
~/anaconda/bin/pip install fbprophet
~/anaconda/bin/pip install tpot

# install Tensorflow
if [ "$GPU" = "TRUE" ]
then
	~/anaconda/bin/pip install --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.5.0-cp36-cp36m-linux_x86_64.whl
else
	~/anaconda/bin/pip install --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.5.0-cp36-cp36m-linux_x86_64.whl
fi

# create Tensorflow test file
cat > ~/tensorflow_test.py << EOF
import time
import tensorflow as tf
import numpy as np

x_data = np.random.rand(100).astype("float32")
y_data = x_data * 0.1 + 0.3

W = tf.Variable(tf.random_uniform([1], -1.0, 1.0))
b = tf.Variable(tf.zeros([1]))
y = W * x_data + b

loss = tf.reduce_mean(tf.square(y - y_data))
optimizer = tf.train.GradientDescentOptimizer(0.5)
train = optimizer.minimize(loss)

init = tf.global_variables_initializer()

t0 = time.time()
sess = tf.Session()
sess.run(init)

for step in range(1001):
    sess.run(train)
    if step % 100 == 0:
        print(step, sess.run(W), sess.run(b))
t1 = time.time()
print('Complete in {0:3f} s.'.format(t1 - t0))
EOF

# download and install git repos
cd ~/git
git clone https://github.com/pymc-devs/pymc3
git clone https://github.com/fchollet/keras
git clone --recursive https://github.com/dmlc/xgboost
git clone https://github.com/jdwittenauer/ionyx
cd ~/git/pymc3
~/anaconda/bin/python setup.py install
cd ~/git/keras
~/anaconda/bin/python setup.py install
cd ~/git/xgboost
make -j4
cd python-package
~/anaconda/bin/python setup.py develop --user
cd ~/git/ionyx
~/anaconda/bin/python setup.py develop

if [ "$GUI" = "TRUE" ]
then
	# download additional git repos
	cd ~/git
	git clone https://github.com/jdwittenauer/kaggle
	git clone https://github.com/jdwittenauer/ipython-notebooks
	git clone https://github.com/jdwittenauer/twitter-viz-demo
	git clone https://github.com/jdwittenauer/alpha
	git clone https://github.com/jdwittenauer/hackerrank
	git clone https://github.com/jdwittenauer/sandbox
	git clone https://github.com/jdwittenauer/linux-setup

	# install and configure PyCharm
	# darcula theme with inconsolata font size 30
	# install plugins
	# configure github login
	# set interpreter to Anaconda
	cd ~/Downloads
	wget "https://download-cf.jetbrains.com/python/pycharm-community-2017.3.3.tar.gz"
	tar -xzf pycharm-community-2017.3.3.tar.gz
	mv ~/Downloads/pycharm-community-2017.3.3 ~/pycharm
	cd ~/pycharm/bin
	bash pycharm.sh

	# install and configure Intellij IDEA
	# darcula theme with inconsolata font size 30
	# install plugins
	# configure github login
	# configure Java and Scala SDKs
	cd ~/Downloads
	wget "https://download-cf.jetbrains.com/idea/ideaIC-2017.3.3.tar.gz"
	tar -xzf ideaIC-2017.3.3.tar.gz
	mv ~/Downloads/idea-IC-173.4301.25 ~/idea
	cd ~/idea/bin
	bash idea.sh

	# clean up downloaded files
	cd ~/Downloads
	rm pycharm-community-2017.3.3.tar.gz
	rm ideaIC-2017.3.3.tar.gz
fi
