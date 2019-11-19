################################################################################
# \brief        A minimal yoctor build host docker image
# \author       Marco Israel
# \date         2019-11
# \detail
# \copyright    GNU Lizense
#
#
#
################################################################################


FROM ubuntu:19.04

MAINTAINER Marco Israel

ENV USERNAME "yocto"
ENV YOCTO_INSTALL_PATH "/yocto"
ENV BUILD_INPUT_DIR ${YOCTO_INSTALL_PATH}/input
ENV BUILD_OUTPUT_DIR ${YOCTO_INSTALL_PATH}/output

USER root

# Upgrade system and Yocto Proyect basic dependencies
RUN apt-get update && apt-get -y upgrade

# Install packedes into the image
RUN apt-get -y install gawk wget git-core diffstat unzip texinfo            \
        gcc-multilib build-essential chrpath socat cpio python python3      \
        python3-pip python3-pexpect xz-utils debianutils iputils-ping       \
        libsdl1.2-dev xterm curl vim bash-completion tree

# Set up locales
RUN apt-get -y install locales apt-utils sudo && dpkg-reconfigure locales   \
    && locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Replace dash with bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# User management
RUN groupadd -g 1000 ${USER_NAME}  && useradd -u 1000 -g 1000 -ms /bin/bash ${USER_NAME}
RUN usermod -a -G sudo ${USER_NAME}  && usermod -a -G users ${USER_NAME}

# Install repo
RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo
RUN chmod a+x /usr/local/bin/repo

# Run as yocto  user from the installation path

RUN install -o 1000 -g 1000 -m 0777  -d $YOCTO_INSTALL_PATH
RUN install -o 1000 -g 1000 -m 0777 -d $YOCTO_INSTALL_PATH/input
RUN install -o 1000 -g 1000 -m 0777 -d $YOCTO_INSTALL_PATH/output

USER ${USER_NAME}
WORKDIR ${YOCTO_INSTALL_PATH}


# Install Poky
WORKDIR ${BUILD_INPUT_DIR}
RUN git clone git://git.yoctoproject.org/poky

#WORKDIR $BUILD_OUTPUT_DIR
#ENV TEMPLATECONF=${BUILD_INPUT_DIR}/poky/meta-poky/conf
#CMD source ${BUILD_INPUT_DIR}/poky/oe-init-build-env build
#
#
## Make /home/yocto  the working directory
#WORKDIR $BUILD_INPUT_DIR 
