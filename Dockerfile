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

ENV USER_NAME "pokybuilder"
ENV YOCTO_INSTALL_PATH "/home/${USER_NAME}/yocto"
ENV YOCTO_DEPLOY_PATH "/yocto_deploy"

# Upgrade system and Yocto Proyect basic dependencies
RUN apt-get update && apt-get -y upgrade

# Install packedes into the image
RUN apt-get -y install gawk wget git-core diffstat unzip texinfo            \
        gcc-multilib build-essential chrpath socat cpio python python3      \
        python3-pip python3-pexpect xz-utils debianutils iputils-ping       \
        libsdl1.2-dev xterm curl vim bash-completion libncursesw5-dev       \
        curl libncurses5-dev

# Set up locales
RUN apt-get -y install locales apt-utils sudo && dpkg-reconfigure locales   \
    && locale-gen de_DE.UTF-8 && update-locale LC_ALL=de_DE.UTF-8 LANG=de_DE.UTF-8
ENV LANG de_DE.UTF-8
ENV LC_ALL de_DE.UTF-8

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Replace dash with bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# User management
RUN groupadd -g 1000 ${USER_NAME}
RUN useradd -u 1000 -g 1000 -ms /bin/bash ${USER_NAME}
RUN usermod -a -G sudo ${USER_NAME}  && usermod -a -G users ${USER_NAME}

# Install repo
RUN curl -o /usr/local/bin/repo                                             \
    https://storage.googleapis.com/git-repo-downloads/repo
RUN chmod a+x /usr/local/bin/repo


# Run as yocto  user from the installation path
RUN install -o 1000 -g 1000 -m -d ${YOCTO_INSTALL_PATH}
RUN install -o 1000 -g 1000 -m 0777 -d ${YOCTO_DEPLOY_PATH}
RUN install -o 1000 -g 1000 -m 0777 -d ${YOCTO_DEPLOY_PATH}/tftp
RUN install -o 1000 -g 1000 -m 0777 -d ${YOCTO_DEPLOY_PATH}/nfs
RUN install -o 1000 -g 1000 -m 0777 -d ${YOCTO_DEPLOY_PATH}/results

USER ${USER_NAME}


# Install Poky
WORKDIR ${YOCTO_INSTALL_PATH}
RUN git clone git://git.yoctoproject.org/poky

#WORKDIR ${YOCTO_DEPLOY_PATH}
#ENV TEMPLATECONF=${BUILD_INPUT_DIR}/poky/meta-poky/conf
#CMD source ${BUILD_INPUT_DIR}/poky/oe-init-build-env build


# Make /home/yocto  the working directory
