FROM tensorflow/tensorflow:latest-gpu
#copy python reqs and install
RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Create a non-root user
ARG username=lgaudet
ARG uid=22082
ARG gid=22082
ENV USER $username
ENV UID $uid
ENV GID $gid
ENV HOME /raid/$USER

RUN groupadd $USER -g22082
RUN mkdir -p /raid/$USER
RUN useradd -m -d /raid/$USER/ -s /bin/bash -u22082 -g22082 $USER

COPY entrypoint.sh /usr/local/bin/
RUN chown $UID:$GID /usr/local/bin/entrypoint.sh && \
    chmod u+x /usr/local/bin/entrypoint.sh

COPY environment.yml requirements.txt /tmp/
RUN chown $UID:$GID /tmp/environment.yml /tmp/requirements.txt

RUN chown -R $UID:$GID /raid/$USER

SHELL [ "/bin/bash", "--login", "-c" ]
USER $USER

# install miniconda
#ENV MINICONDA_VERSION 4.8.2
ENV CONDA_DIR $HOME/miniconda3
#RUN touch miniconda.sh
#RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-$MINICONDA_VERSION-Linux-x86_64.sh -O ~/miniconda.sh && \
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    chmod u+x ~/miniconda.sh && \
    ~/miniconda.sh -b -p $CONDA_DIR && \
    rm ~/miniconda.sh
# make non-activate conda commands available
ENV PATH=$CONDA_DIR/bin:$PATH
# make conda activate command available from /bin/bash --login shells
RUN echo ". $CONDA_DIR/etc/profile.d/conda.sh" >> ~/.profile
# make conda activate command available from /bin/bash --interative shells
RUN conda init bash

#COPY requirements.txt requirements.txt
#RUN pip install -r requirements.txt
#should also copy any code you will need to run project ex:
#VOLUME ["/raid/lgaudet/"]
#COPY . /raid/lgaudet/
WORKDIR /raid/$USER/

#RUN pip install -U pip
# build the conda environment
ENV ENV_PREFIX /raid/$USER/env
RUN conda update --name base --channel defaults conda && \
    conda env create --prefix $ENV_PREFIX --file /tmp/environment.yml --force && \
    conda clean --all --yes

#CMD python download_hrrr_archive.py
# use an entrypoint script to insure conda environment is properly activated at runtime
#ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
# default command will be to launch JupyterLab server for development
#CMD [ "jupyter", "lab", "--no-browser", "--ip", "0.0.0.0", "--port", "8886" ]
