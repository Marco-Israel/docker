################################################################################
# \brief        A minimal latex build host docker image
# \author       Marco Israel
# \date         2019-11
# \detail
# \copyright    GNU Lizense
#
#
#
################################################################################


FROM ubuntu:latest

ENV USER_NAME "latex"
ENV YOCTO_INSTALL_PATH "/$[USER_NAME}"

USER root

RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install texlive-base texlive-lang-german \
        texlive-latex-extra latex-make latex-mk latexdiff latexdraw \
        texlive-bibtex-extra nbibtex biber ingerman wngerman



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


# Run as yocto  user from the installation path
RUN install -o 1000 -g 1000 -m 0777 -d ${YOCTO_INSTALL_PATH}

USER ${USER_NAME}

# Set up locales

ENTRYPOINT ["latexmk"]

CMD ["main.tex"]
