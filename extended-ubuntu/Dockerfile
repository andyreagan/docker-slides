# docker build extended-ubuntu -t andyreagan/extended-ubuntu
# Ubuntu 16.04 (xenial) from 2017-07-23
# https://github.com/docker-library/official-images/commit/0ea9b38b835ffb656c497783321632ec7f87b60c
FROM ubuntu@sha256:84c334414e2bfdcae99509a6add166bbb4fa4041dc3fa6af08046a66fed3005f

LABEL maintainer="Andy Reagan"

USER root

################################################################################
# Install all OS dependencies for notebook server that starts                  #
################################################################################

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get -yq dist-upgrade \
    && apt-get upgrade -yq -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" \
    && apt-get install -yq --no-install-recommends \
    bzip2 \
    unzip \
    ca-certificates \
    sudo \
    locales \
    build-essential \
    libssl-dev \
    libffi-dev \
    man-db \
    libc6 \
    libc6-dev \
    wget \
    curl \
    rsync \
    file \
    screen \
    tmux \
    pkg-config \
    cmake \
    gcc \
    gfortran \
    gettext \
    libreadline-dev \
    libncurses-dev \
    libpcre3-dev \
    libgnutls30 \
    libzmq3-dev \
    libzmq5 \
    supervisor \
    iputils-ping \
    dnsutils \
    net-tools \
    inetutils-traceroute \
    hdf5-tools \
    git \
    inkscape \
    jed \
    libsm6 \
    libxext-dev \
    fonts-liberation \
    libxrender1 \
    lmodern \
    pandoc \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-xetex \
    vim \
    vim-tiny \
    emacs \
    fonts-dejavu \
    tzdata \
    libav-tools \
    software-properties-common \
    ed \
    less \
    ssh-client \
    default-jre \
    default-jdk \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

################################################################################
# python                                                                       #
################################################################################

RUN apt-get update \
    && apt-get -yq dist-upgrade \
    && apt-get upgrade -yq -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" \
    && apt-get install -yq --no-install-recommends \
    python \
    python-dev \
    python-pip \
    python3-dev \
    python3-pip \
    python3-venv \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

################################################################################
# nodesjs                                                                      #
################################################################################

# from here:
# https://askubuntu.com/questions/786272/why-does-installing-node-6-x-on-ubuntu-16-04-actually-install-node-4-2-6
# RUN echo "deb https://deb.nodesource.com/node_9.x xenial main" >> /etc/apt/sources.list.d/nodesource.list && \
#     echo "deb-src https://deb.nodesource.com/node_9.x xenial main" >> /etc/apt/sources.list.d/nodesource.list && \
#     curl -s -k https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add && \
#     apt-get update
# RUN curl -skL https://deb.nodesource.com/setup_9.x | bash && \
#     apt-get install -yq --no-install-recommends \
#     nodejs \
#     && apt-get clean && \
#     rm -rf /var/lib/apt/lists/*
# this isn't supported at least back to version 5 of nodejs
# I'm not sure how else nb extensions are built...
## Your distribution, identified as "xenial", is not currently supported, please contact NodeSource at https://github.com/nodesource/distributions/issues if you think this is incorrect or would like your distribution to be considered for support

# https://nodejs.org/download/release/v9.2.0/node-v9.2.0-linux-x86.tar.gz

################################################################################
# R                                                                            #
################################################################################

# https://www.r-bloggers.com/installing-r-on-ubuntu/
# https://hub.docker.com/r/rocker/r-apt/~/dockerfile/
RUN add-apt-repository --enable-source --yes "ppa:marutter/rrutter" \
    && add-apt-repository --enable-source --yes "ppa:marutter/c2d4u"

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# Now install R and littler, and create a link for littler in /usr/local/bin
# Also set a default CRAN repo, and make sure littler knows about it too
# Note 1: we need wget here as the build env is too old to work with libcurl (we think, precise was)
# Note 2: r-cran-docopt is not currently in c2d4u so we install from source
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    littler \
    libcurl4-openssl-dev \
    r-base \
    r-base-dev \
    r-recommended \
    r-cran-stringr \
    r-cran-rcpp \
    && echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
    && ln -s /usr/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r \
    && ln -s /usr/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
    && ln -s /usr/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
    && ln -s /usr/lib/R/site-library/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
    && install.r docopt \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
    && rm -rf /var/lib/apt/lists/*

################################################################################
# return to bash                                                               #
################################################################################

ENTRYPOINT /bin/bash
