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


FROM ubuntu:16.04


USER root


ENV USER_NAME "yocto"
ENV EXCH_PATH "/${USER_NAME}"
ENV EXCH_PATH_INPUT "${EXCH_PATH}/input"
ENV EXCH_PATH_OUTPUT "${EXCH_PATH}/output"
ARG DEBIAN_FRONTEND=noninteractive

# Upgrade system and Yocto Proyect basic dependencies and set to locals
RUN apt-get update && apt-get -y upgrade && apt-get clean                   \
        && apt-get -y install locales apt-utils sudo                        \
        && dpkg-reconfigure locales                                         \
        && locale-gen en_US.UTF-8                                           \
        && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8


ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8


# Install packedes into the image
RUN apt-get -y install gawk wget git diffstat unzip texinfo                 \ 
        gcc-multilib build-essential chrpath socat cpio python3-lxml python3 \
        python3-pip python3-pexpect xz-utils debianutils iputils-ping       \
        libsdl1.2-dev xterm curl vim bash-completion tree apt-utils         \
        python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev  pylint       \
         python python-lxml


# Clean up APT when done and set shell and user options.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*          \
        && rm /bin/sh && ln -s /bin/bash /bin/sh                            \
        && groupadd -g 1000 ${USER_NAME}                                    \
        && useradd -u 1000 -g 1000 -ms /bin/bash ${USER_NAME}               \
        && usermod -a -G sudo ${USER_NAME}                                  \
        && usermod -a -G users ${USER_NAME}                                 \
        && usermod --password ${USER_NAME} ${USER_NAME}                     \
        && usermod --password toor root                                     \
        && passwd -d root                                                   \
        && passwd -d ${USER_NAME}                           


# Install repo
RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo \
        && chmod a+x /usr/local/bin/repo

# Run as yocto  user from the installation path
RUN install -o 1000 -g 1000 -m 2777  -d ${EXCH_PATH}                        \
        && install -o 1000 -g 1000 -m 2777 -d ${EXCH_PATH_INPUT}            \
        && install -o 1000 -g 1000 -m 2777 -d ${EXCH_PATH_OUTPUT}


USER ${USER_NAME}

WORKDIR ${EXCH_PATH}

#ENTRYPOINT /bin/bash
CMD [ "bash", "./dockerjob.sh"]
