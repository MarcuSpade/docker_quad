FROM osrf/ros:noetic-desktop-full-focal

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Bahia
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Instalação de pacotes necessários
RUN apt-get update && apt-get install -y \
    nano \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get install -y --reinstall ca-certificates
RUN apt-get update && apt-get install -y software-properties-common
RUN apt-get install -y sudo

RUN add-apt-repository -y 'ppa:deadsnakes/ppa'

RUN apt-get install -y libpython3.8 python3.8 python3-pip python3.8-distutils

RUN python3.8 -m pip install numpy

RUN apt-get update

RUN apt install -y libcgal-dev libcgal-qt5-dev \
    liboce-ocaf-dev libassimp-dev libavcodec-dev \
    libavformat-dev libavutil-dev libswscale-dev \
    libblas-dev liblapack-dev 
RUN apt install libasound2 libnss3 -y

# Install utils
RUN apt install -y vim gedit nano
RUN apt install -y ros-noetic-velodyne*

# Add user
RUN useradd -rm -d /home/ubuntu -p $(perl -e 'print crypt($ARGV[0], "password")' 'ubuntu') -s /bin/bash -g root -G sudo -u 1001 ubuntu

USER ubuntu



# Creating directory and cloning repositories.
RUN mkdir -p /home/ubuntu/modbot_ws

RUN mkdir -p /home/ubuntu/quad_ws/src/ \
    && cd /home/ubuntu/quad_ws/src/ \
    && git clone --recursive https://github.com/chvmp/champ \
    && git clone https://github.com/chvmp/champ_teleop \
    && git clone https://github.com/MarcuSpade/robots.git

# Rosdep and Install robots descriptions
USER root

COPY setup.sh /root/setup.sh
RUN chmod +x /root/setup.sh
RUN /root/setup.sh

USER ubuntu

WORKDIR /home/ubuntu/quad_ws

RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_make"

RUN echo "source /opt/ros/noetic/setup.bash" >> /home/ubuntu/.bashrc
RUN echo "source /home/ubuntu/quad_ws/devel/setup.bash" >> /home/ubuntu/.bashrc

WORKDIR /home/ubuntu/quad_ws

RUN echo "TUDO CERTO"