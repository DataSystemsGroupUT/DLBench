# Benchmarking-Deep-Learning-Frameworks
## The frameworks that are included in this benchmark are:
  1-[Keras](https://keras.io/) <br /> 
  2-[Chainer](https://docs.chainer.org/en/stable/glance.html) <br /> 
  3-[Tensorflow](https://www.tensorflow.org/) <br /> 
  4-[Pytorch](https://pytorch.org/) <br />
  5-[Theano](http://deeplearning.net/software/theano/)  <br />
  6-[Mxnet](https://mxnet.apache.org/) <br />

## The Experiments comparing those frameworks over 4 datasets:
  1- [MNIST](http://yann.lecun.com/exdb/mnist/) <br />
  2- [CIFAR10](https://www.cs.toronto.edu/~kriz/cifar.html) <br />
  3- [CIFAR100](https://www.cs.toronto.edu/~kriz/cifar.html) <br />
  4- [SVHN](http://ufldl.stanford.edu/housenumbers/) <br />

There are two experiments one of them uses CPU and the other uses GPU.

## This repository is divided into 3 folders:
 ### 1- CPU Experiment <br />
    * The CPU experiments are performed on a single machine running on Centos release 7.5.1804 with 32 core Intel Xeon Processor (Skylake,  IBRS) @ 2.00GHz;64 GB DIMM memory; and 240 GB SSD hard drive.
    * For Keras, version 2.2.4 is used on Tensorflow 1.11.0. 
    * For Chainer, version 4.5.0 is used. 
    * For Tensorflow, version 1.11 is used. 
    * For Pytorch, version 0.4.1 is used
    * For Theano, version 1.0.2 is used. 
    * For MXNet, version 1.3.0 is used.
    * It contain the CPU source code 
    * The Generated graphs 
    * The logs of the experiment 
       
 ### 2- GPU Experiment <br />
    * The GPU experiments are performed on a single machine running on Debian GNU/Linux 9 (stretch) with 8 core Intel(R) Xeon(R) CPU @ 2.00GHz; NVIDIA Tesla P4;36 GB DIMM memory; and 300 GB SSD hard drive.
    * For Keras, version 2.2.4 is used and run on Tensorflow version 1.11.0. 
    * For Chainer, version 4.5.0 is used. 
    * For Tensorflow, version 1.11.0 is used. 
    * For Pytorch, version 0.4.1 is used, For Theano, version 1.0.2 is used. 
    * For MXNet, version 1.3.0 is used.
    * For Chainer, MXNet and Pytorch, we used CUDA 9.2 and cuDNN 7.2.1, and for Tensorflow, Keras, and Theano, we used CUDA 10.0 and cuDNN 7.3
    * It contain the GPU experiment 
    * The Generated graphs 
    * The logs of the experiment 
    
 ### 3- Installation Guide <br />
    * It contain file for each framework with the commands needed for installation 
    * It contains the required packages to be included for each environment.
    * It's recommended to create different environmnet for each framework using conda or virtualenvs

  
 ## Experiment Logging:
  There exist 3 files for logging the resources during the experiment: CPU log, GPU Log, memory Log.<br />
  
## How to run? 
 1- Install the environment for each framework using the installation  guide <br />
 2- Clone the project <br />
 3- For running the experiment over MNIST datset for Keras framework for example, you will find in CPU folder the source code, There is a file for each framework. <br />
 4- There is a method in the main function that is called runModel, this methods holds the name of the dataset and the number of       epochs needed for this run.

## Optional hyperparameters:<br />
There are  many other optional parameters with the following default values, these paramters including: <br />
     1- Learning Rate=0.01 <br />
     2- momentum=0.5 <br />
     3- Weight Decay=1e-6 <br />
     4- batch size = 128 <br />
     
 ## #Installation steps:
 create a new environment with conda
  $ conda create -n [my-env-name]
 activate the environment you created
  $ source activate [my-env-name]
 install pip in the virtual environment
  $ conda install pip
  
  
