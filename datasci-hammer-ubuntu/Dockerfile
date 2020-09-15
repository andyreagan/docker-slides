FROM andyreagan/extended-ubuntu:latest

LABEL maintainer="Andy Reagan"

USER root

################################################################################
# Set up the new user                                                          #
################################################################################

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# # Install Tini
# RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.10.0/tini && \
#     echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0 *tini" | sha256sum -c - && \
#     mv tini /usr/local/bin/tini && \
#     chmod +x /usr/local/bin/tini

# Configure environment
ENV SHELL=/bin/bash \
    NB_USER=jovyan \
    NB_UID=1000 \
    NB_GID=100 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV HOME=/home/$NB_USER

ADD fix-permissions /usr/local/bin/fix-permissions
# Create jovyan user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    fix-permissions $HOME

USER $NB_USER

# Setup work directory for backward-compatibility
RUN mkdir /home/$NB_USER/work && \
    fix-permissions /home/$NB_USER

################################################################################
# Python basics (needed for Julia setup)                                       #
################################################################################

USER root

RUN sudo pip3 install pip -U --no-cache-dir

RUN sudo pip3 install setuptools -U --no-cache-dir

RUN sudo pip3 install notebook \
    jupyterhub \
    jupyterlab --no-cache-dir
# jupyter labextension install @jupyterlab/hub-extension@^0.6.0

################################################################################
# JULIA itself                                                                 #
################################################################################

# These strategies also work....
# RUN wget --quiet https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.1-linux-x86_64.tar.gz && \
#     tar xzf julia-0.6.1-linux-x86_64.tar.gz && \
#     rm julia-0.6.1-linux-x86_64.tar.gz && \
#     sudo ln -s /julia-0d7248e2ff/bin/julia /usr/local/bin/julia

# RUN cd /tmp && \
#     wget --quiet https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.1-linux-x86_64.tar.gz && \
#     tar xzf julia-0.6.1-linux-x86_64.tar.gz -C /usr/local && \
#     rm julia-0.6.1-linux-x86_64.tar.gz

# Don't install these other versions for sake of time building (they're big downloads!)
# # https://github.com/tanmaykm/JuliaDockerImages/blob/master/base/latest/Dockerfile
# # Install julia 0.3
# RUN mkdir -p /opt/julia-0.3.12 && \
#     curl -s -k -L https://julialang.s3.amazonaws.com/bin/linux/x64/0.3/julia-0.3.12-linux-x86_64.tar.gz | tar -C /opt/julia-0.3.12 -x -z --strip-components=1 -f -
# # RUN mkdir -p /opt/julia-0.3.12 && \
# #     cd /tmp && \
# #     wget -q --no-check-certificate https://julialang.s3.amazonaws.com/bin/linux/x64/0.3/julia-0.3.12-linux-x86_64.tar.gz && \
# #     tar -C /opt/julia-0.3.12 -x -z --strip-components=1 -f julia-0.3.12-linux-x86_64.tar.gz
# RUN ln -fs /opt/julia-0.3.12 /opt/julia-0.3
#
# # Install julia 0.4
# RUN mkdir -p /opt/julia-0.4.7 && \
#     curl -s -k -L https://julialang.s3.amazonaws.com/bin/linux/x64/0.4/julia-0.4.7-linux-x86_64.tar.gz | tar -C /opt/julia-0.4.7 -x -z --strip-components=1 -f -
# RUN ln -fs /opt/julia-0.4.7 /opt/julia-0.4
# RUN echo '("JULIA_LOAD_CACHE_PATH" in keys(ENV)) && unshift!(Base.LOAD_CACHE_PATH, ENV["JULIA_LOAD_CACHE_PATH"])' >> /opt/julia-0.4/etc/julia/juliarc.jl
#
# # Install julia 0.5
# RUN mkdir -p /opt/julia-0.5.2 && \
#     curl -s -k -L https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.2-linux-x86_64.tar.gz | tar -C /opt/julia-0.5.2 -x -z --strip-components=1 -f -
# RUN ln -fs /opt/julia-0.5.2 /opt/julia-0.5
# RUN echo '("JULIA_LOAD_CACHE_PATH" in keys(ENV)) && unshift!(Base.LOAD_CACHE_PATH, ENV["JULIA_LOAD_CACHE_PATH"])' >> /opt/julia-0.5/etc/julia/juliarc.jl

# Install julia 0.6

RUN mkdir -p /opt/julia-0.6.1 && \
    curl -s -L https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.1-linux-x86_64.tar.gz | tar -C /opt/julia-0.6.1 -x -z --strip-components=1 -f -
RUN ln -fs /opt/julia-0.6.1 /opt/julia-0.6
RUN echo '("JULIA_LOAD_CACHE_PATH" in keys(ENV)) && unshift!(Base.LOAD_CACHE_PATH, ENV["JULIA_LOAD_CACHE_PATH"])' >> /opt/julia-0.6/etc/julia/juliarc.jl

# Make v0.6 default julia
RUN ln -s /opt/julia-0.6 /opt/julia
RUN ln -s /opt/julia/bin/julia /usr/local/bin/julia

################################################################################
# Python packages
################################################################################

COPY REQUIREMENTS.txt /home/$NB_USER
# RUN pip install -r REQUIREMENTS.txt
RUN pip3 install --no-cache-dir -r /home/$NB_USER/REQUIREMENTS.txt

# RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
#     # Also activate ipywidgets extension for JupyterLab
#     jupyter labextension install @jupyter-widgets/jupyterlab-manager

# Install facets which does not have a pip or conda package at the moment
RUN cd /tmp && \
    git clone https://github.com/PAIR-code/facets.git && \
    cd facets && \
    jupyter nbextension install facets-dist/ --sys-prefix && \
    rm -rf facets

# RUN fix-permissions /usr/local/lib/python3.5/dist-packages

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python3 -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

# RUN fix-permissions /etc/jupyter/

################################################################################
# Julia packages
################################################################################

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_USER
WORKDIR $HOME

# COPY julia_config.jl .
# RUN julia julia_config.jl
# this is perhaps a more julia-like way to manage:
COPY .juliarc.jl .
RUN julia -e 'Pkg.init();'
COPY REQUIRE .julia/v0.6/REQUIRE
RUN julia -e 'emerge();'

# Add local files as late as possible to avoid cache busting
COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/
COPY start-lab.sh /usr/local/bin/
COPY start-singleuser.sh /usr/local/bin/
COPY jupyter_notebook_config.py /etc/jupyter/

################################################################################
# R packages                                                                   #
################################################################################

USER root
RUN fix-permissions /usr/local/lib/R/site-library

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_USER
WORKDIR $HOME

RUN Rscript -e "install.packages('devtools')"
RUN Rscript -e "devtools::install_github('IRkernel/IRkernel')"
RUN Rscript -e "IRkernel::installspec()"
RUN Rscript -e "install.packages('yhatr')"
RUN Rscript -e "install.packages('ggplot2')"
RUN Rscript -e "install.packages('dplyr')"
RUN Rscript -e "install.packages('reshape2')"
RUN Rscript -e "install.packages('forecast')"
RUN Rscript -e "install.packages('stringr')"
RUN Rscript -e "install.packages('lubridate')"
RUN Rscript -e "install.packages('randomForest')"
RUN Rscript -e "install.packages('rpart')"
RUN Rscript -e "install.packages('e1071')"
RUN Rscript -e "install.packages('kknn')"
RUN Rscript -e "install.packages('lme4')"
RUN Rscript -e "install.packages('mmviz')"


USER root
RUN fix-permissions /usr/local/lib/R/site-library
RUN fix-permissions /home/$NB_USER/.julia

################################################################################
# Setup to run the server                                                      #
################################################################################
USER $NB_USER
EXPOSE 8888
WORKDIR $HOME

# # Configure container startup
# ENTRYPOINT ["tini", "--"]
# RUN ["start-notebook.sh"]
