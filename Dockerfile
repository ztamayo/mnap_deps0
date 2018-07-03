##
# Dockerfile for MNAP
# MNAP code created by: Anticevic Lab, Yale University and Mind and Brain Lab, University of Ljubljana
# Maintainer of Dockerfile: Zailyn Tamayo, Yale University
##

##
# Tag: ztamayo/mnap_deps0:latest
# Dockerfile 0 for dependencies needed to run MNAP suite
# Dockerfile created using neurodocker - https://github.com/kaczmarj/neurodocker 
# Installs dependencies dcm2niix, AFNI, FSL 5.0.9, and FreeSurfer 6.0.0
##

FROM ubuntu:16.04

ARG DEBIAN_FRONTEND="noninteractive"

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    ND_ENTRYPOINT="/neurodocker/startup.sh"
RUN export ND_ENTRYPOINT="/neurodocker/startup.sh" \
    && apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           apt-utils \
           bzip2 \
           ca-certificates \
           curl \
           locales \
           unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG="en_US.UTF-8" \
    && chmod 777 /opt && chmod a+s /opt \
    && mkdir -p /neurodocker \
    && if [ ! -f "$ND_ENTRYPOINT" ]; then \
         echo '#!/usr/bin/env bash' >> "$ND_ENTRYPOINT" \
    &&   echo 'set -e' >> "$ND_ENTRYPOINT" \
    &&   echo 'if [ -n "$1" ]; then "$@"; else /usr/bin/env bash; fi' >> "$ND_ENTRYPOINT"; \
    fi \
    && chmod -R 777 /neurodocker && chmod a+s /neurodocker

ENTRYPOINT ["/neurodocker/startup.sh"]

# Install dcm2niix
ENV PATH="/opt/dcm2niix-latest/bin:$PATH"
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           cmake \
           g++ \
           gcc \
           git \
           make \
           pigz \
           zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && git clone https://github.com/rordenlab/dcm2niix /tmp/dcm2niix \
    && mkdir /tmp/dcm2niix/build \
    && cd /tmp/dcm2niix/build \
    && cmake  -DCMAKE_INSTALL_PREFIX:PATH=/opt/dcm2niix-latest .. \
    && make \
    && make install \
    && rm -rf /tmp/dcm2niix

# Install AFNI
#ENV PATH="/opt/afni-latest:$PATH" \
#    AFNI_PLUGINPATH="/opt/afni-latest"
#RUN apt-get update -qq \
#    && apt-get install -y -q --no-install-recommends \
#           ed \
#           gsl-bin \
#           libglib2.0-0 \
#           libglu1-mesa-dev \
#           libglw1-mesa \
#           libgomp1 \
#           libjpeg62 \
#           libxm4 \
#           netpbm \
#           tcsh \
#           xfonts-base \
#           xvfb \
#           wget \
#    && apt-get clean \
#    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
#    && curl -sSL --retry 5 -o /tmp/toinstall.deb http://mirrors.kernel.org/debian/pool/main/libx/libxp/libxp6_1.0.2-2_amd64.deb \
#    && dpkg -i /tmp/toinstall.deb \
#    && rm /tmp/toinstall.deb \
#    && curl -sSL --retry 5 -o /tmp/toinstall.deb http://mirrors.kernel.org/debian/pool/main/libp/libpng/libpng12-0_1.2.49-1%2Bdeb7u2_amd64.deb \
#    && dpkg -i /tmp/toinstall.deb \
#    && rm /tmp/toinstall.deb \
#    && apt-get install -f \
#    && apt-get clean \
#    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
#    && gsl2_path="$(find / -name 'libgsl.so.19' || printf '')" \
#    && if [ -n "$gsl2_path" ]; then \
#         ln -sfv "$gsl2_path" "$(dirname $gsl2_path)/libgsl.so.0"; \
#    fi \
#    && ldconfig \
#    && echo "Downloading AFNI..." \
#    && mkdir -p /opt/afni-latest \
#    && wget --progress=bar:force -O /tmp/linux_openmp_64.tgz https://afni.nimh.nih.gov/pub/dist/tgz/linux_openmp_64.tgz 
#RUN tar -xzvf /tmp/linux_openmp_64.tgz -C /opt/afni-latest --strip-components 1 && \
#    rm /tmp/linux_openmp_64.tgz

# Install FSL
ENV FSLDIR="/opt/fsl-5.0.9" \
    PATH="/opt/fsl-5.0.9/bin:$PATH"
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           bc \
           dc \
           file \
           libfontconfig1 \
           libfreetype6 \
           libgl1-mesa-dev \
           libglu1-mesa-dev \
           libgomp1 \
           libice6 \
           libmng1 \
           libxcursor1 \
           libxft2 \
           libxinerama1 \
           libxrandr2 \
           libxrender1 \
           libxt6 \
           wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "Downloading FSL..." \
    && mkdir -p /opt/fsl-5.0.9 \
    && wget --progress=bar:force -O /tmp/fsl-5.0.9-centos6_64.tar.gz https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-5.0.9-centos6_64.tar.gz 
RUN tar -xzvf /tmp/fsl-5.0.9-centos6_64.tar.gz -C /opt/fsl-5.0.9 --strip-components 1 && \
    rm /tmp/fsl-5.0.9-centos6_64.tar.gz

# Install FreeSurfer
ENV FREESURFER_HOME="/opt/freesurfer-6.0.0-min" \
    PATH="/opt/freesurfer-6.0.0-min/bin:$PATH"
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           bc \
           libgomp1 \
           libxmu6 \
           libxt6 \
           perl \
           tcsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "Downloading FreeSurfer..." \
    && mkdir -p /opt/freesurfer-6.0.0-min \
    && wget --progress=bar:force -O /tmp/recon-all-freesurfer6-3.min.tgz https://dl.dropbox.com/s/nnzcfttc41qvt31/recon-all-freesurfer6-3.min.tgz 
RUN tar -xzvf /tmp/recon-all-freesurfer6-3.min.tgz -C /opt/freesurfer-6.0.0-min --strip-components 1 \
    && sed -i '$isource "/opt/freesurfer-6.0.0-min/SetUpFreeSurfer.sh"' "$ND_ENTRYPOINT" && \
    rm /tmp/recon-all-freesurfer6-3.min.tgz

RUN echo '{ \
    \n  "pkg_manager": "apt", \
    \n  "instructions": [ \
    \n    [ \
    \n      "base", \
    \n      "debian:stretch" \
    \n    ], \
    \n    [ \
    \n      "dcm2niix", \
    \n      { \
    \n        "version": "latest", \
    \n        "method": "source" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "afni", \
    \n      { \
    \n        "version": "latest", \
    \n        "method": "binaries" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "fsl", \
    \n      { \
    \n        "version": "5.0.9", \
    \n        "method": "binaries" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "freesurfer", \
    \n      { \
    \n        "version": "6.0.0-min", \
    \n        "method": "binaries" \
    \n      } \
    \n    ] \
    \n  ] \
    \n}' > /neurodocker/neurodocker_specs.json

# Clear apt cache and other empty folders
USER root
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /boot /media /mnt /srv && \
    rm -rf ~/.cache/pip

CMD ["bash"]
