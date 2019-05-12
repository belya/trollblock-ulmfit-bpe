# For development usage only
FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

RUN apt-get update && apt-get install -y \
	wget \
	vim \
	bzip2

#Downgrade CUDA, TF issue: https://github.com/tensorflow/tensorflow/issues/17566#issuecomment-372490062
RUN apt-get install --allow-downgrades --allow-change-held-packages -y libcudnn7=7.0.5.15-1+cuda9.0

#Install MINICONDA
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O Miniconda.sh && \
	/bin/bash Miniconda.sh -b -p /opt/conda && \
	rm Miniconda.sh

ENV PATH /opt/conda/bin:$PATH

#Install ANACONDA Environment
RUN conda create -y -n jupyter_env python=3.6 anaconda && \
	/opt/conda/envs/jupyter_env/bin/pip install jupyterlab

RUN /opt/conda/envs/jupyter_env/bin/pip install torch

RUN /opt/conda/envs/jupyter_env/bin/pip install fastai

# Install ULMFiT package
ADD . /tmp/package/

RUN /opt/conda/envs/jupyter_env/bin/pip install /tmp/package

#Launch JUPYTER COMMAND
CMD /opt/conda/envs/jupyter_env/bin/jupyter notebook --ip=127.0.0.1 --no-browser --allow-root --notebook-dir=/tmp/

