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


USER root


ENV USER_NAME "latex"
ENV EXCH_PATH "/${USER_NAME}"
ENV EXCH_PATH_INPUT "${EXCH_PATH}/input"
ENV EXCH_PATH_OUTPUT "${EXCH_PATH}/output"
ARG DEBIAN_FRONTEND=noninteractive

# Upgrade system and Yocto Proyect basic dependencies and set to locals
RUN apt-get update && apt-get -y upgrade                                    \
        && export export DEBIAN_FRONTEND=noninteractive                     \
        && apt-get -y install locales apt-utils sudo                        \
        && dpkg-reconfigure locales                                         \
        && locale-gen en_US.UTF-8                                           \
        && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8


ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8


# Install packedes into the image
RUN apt-get -y install texlive-base texlive-lang-german apt-utils           \
        texlive-latex-extra latex-make latexmk latexdiff latexdraw          \
        texlive-bibtex-extra nbibtex biber ingerman wngerman make           \
        texlive-fonts-extra vim



# Clean up APT when done and set shell and user options.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*          \
        && rm /bin/sh && ln -s /bin/bash /bin/sh                            \
        && groupadd -g 1000 ${USER_NAME}                                    \
        && useradd -u 1000 -g 1000 -ms /bin/bash ${USER_NAME}               \
        && usermod -a -G sudo ${USER_NAME}                                  \
        && usermod -a -G users ${USER_NAME}                                 \
        && usermod --password ${USER_NAME} ${USER_NAME}                     \ 
        && usermod --password toor root


# Run as yocto  user from the installation path
RUN install -o 1000 -g 1000 -m 2777  -d ${EXCH_PATH}                        \
        && install -o 1000 -g 1000 -m 2777 -d ${EXCH_PATH_INPUT}            \
        && install -o 1000 -g 1000 -m 2777 -d ${EXCH_PATH_OUTPUT} 


USER ${USER_NAME}

WORKDIR ${EXCH_PATH_INPUT}


#ENTRYPOINT ["latex-mk"]
#CMD ["main"]

#ENTRYPOINT ["make"]
CMD [ "make", "all"]

#CMD /bin/bash
