##
# Dockerfile for MNAP
# MNAP code created by: Anticevic Lab, Yale University and Mind and Brain Lab, University of Ljubljana
# Maintainer of Dockerfile: Zailyn Tamayo, Yale University
##

##
# Tag: ztamayo/mnap_deps0:latest
# Dockerfile 0 for dependencies needed to run MNAP suite
# Installs dependencies dcm2niix, AFNI (removed), FSL 5.0.9, and FreeSurfer 6.0.0
##

FROM ubuntu:18.04

RUN apt-get update -qq \
    && apt-get clean \
    && apt-get install -y -q --no-install-recommends \
           apt-utils \
           bzip2 \
           ca-certificates \
           curl \
           locales \
           unzip \
           cmake \
           g++ \
           gcc \
           git \
           make \
           pigz \
           wget \
           vim \
           bc \
           dc \
           file \
           perl \
           tcsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && chmod 777 /opt && chmod a+s /opt 
# Set dcm2niix path
ENV PATH="/opt/dcm2niix-latest/bin:$PATH" 
# Install dcm2niix
RUN mkdir -p /tmp/dcm2niix \
    && wget --progress=bar:force -O /tmp/dcm2niix.tar.gz https://github.com/rordenlab/dcm2niix/archive/v1.0.20170624.tar.gz \
    && tar -xzvf /tmp/dcm2niix.tar.gz -C /tmp/ --strip-components 1 \
    && cd /tmp \
    && cmake -DUSE_OPENJPEG=ON . \
    && mkdir -p /opt/dcm2niix-latest \
    && make \
    && mv bin/ /opt/dcm2niix-latest \
    && cd / \
    && rm -rf /tmp/*

# Set FreeSurfer path
ENV FREESURFER_HOME="/opt/freesurfer-6.0/freesurfer" \
    PATH="/opt/freesurfer-6.0/freesurfer/bin:$PATH" \
# Set FSL path
    FSLDIR="/opt/fsl-5.0.9" \
    PATH="/opt/fsl-5.0.9/bin:$PATH"
RUN apt-get update -qq \
# Install shared libraries
    && apt-get install -y -q --no-install-recommends \
           zlib1g-dev \
           libfontconfig1 \
           libfreetype6 \
           libgl1-mesa-dev \
           libglu1-mesa-dev \
           libgomp1 \
           libice6 \
           libxcursor1 \
           libxft2 \
           libxinerama1 \
           libxrandr2 \
           libxrender1 \
           libxt6 \
           libc6 \
           libftgl2 \
           libgcc1 \
           libgl1-mesa-glx \
           libgl1 \
           libglu1-mesa \
           libglu1 \
           libosmesa6 \
           libqt4-network \
           libqt4-opengl \
           libqt4-xml \
           libqtcore4 \
           libstdc++6 \
           zlib1g \
           libqtgui4 \
           libqtwebkit4 \
           libxmu6 \
           libxm4  \
           libglw1-mesa \
           libglib2.0-0 \
           libjpeg62 \
           libssl1.0.0 \
           libssl-dev \
    && wget --progress=bar:force -O /tmp/gcc-6-base_6.4.0-17ubuntu1_amd64.deb http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-6/gcc-6-base_6.4.0-17ubuntu1_amd64.deb \
    && dpkg -i /tmp/gcc-6-base_6.4.0-17ubuntu1_amd64.deb \
    && rm /tmp/gcc-6-base_6.4.0-17ubuntu1_amd64.deb \
    && wget --progress=bar:force -O /tmp/libgfortran3_6.4.0-17ubuntu1_amd64.deb http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-6/libgfortran3_6.4.0-17ubuntu1_amd64.deb \
    && dpkg -i /tmp/libgfortran3_6.4.0-17ubuntu1_amd64.deb \
    && rm /tmp/libgfortran3_6.4.0-17ubuntu1_amd64.deb \
    && wget --progress=bar:force -O /tmp/libhdf5-serial-1.8.4_1.8.4-patch1-3ubuntu2_amd64.deb http://security.ubuntu.com/ubuntu/pool/universe/h/hdf5/libhdf5-serial-1.8.4_1.8.4-patch1-3ubuntu2_amd64.deb \
    && dpkg -i /tmp/libhdf5-serial-1.8.4_1.8.4-patch1-3ubuntu2_amd64.deb \
    && rm /tmp/libhdf5-serial-1.8.4_1.8.4-patch1-3ubuntu2_amd64.deb \
    && wget --progress=bar:force -O /tmp/libnetcdf6_4.1.1-6_amd64.deb http://security.ubuntu.com/ubuntu/pool/universe/n/netcdf/libnetcdf6_4.1.1-6_amd64.deb \
    && dpkg -i /tmp/libnetcdf6_4.1.1-6_amd64.deb \
    && rm /tmp/libnetcdf6_4.1.1-6_amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
# Install FSL
    && echo "Downloading FSL..." \
    && mkdir -p /opt/fsl-5.0.9 \
    && wget --progress=bar:force -O /tmp/fsl-5.0.9-centos6_64.tar.gz https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-5.0.9-centos6_64.tar.gz \
    && tar -xzvf /tmp/fsl-5.0.9-centos6_64.tar.gz -C /opt/fsl-5.0.9 --strip-components 1 \
    && rm /tmp/fsl-5.0.9-centos6_64.tar.gz \
    && rm -R ${FSLDIR}/data/first/

# Install FreeSurfer
RUN apt-get update -qq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "Downloading FreeSurfer..." \
    && mkdir -p /opt/freesurfer-6.0/freesurfer \
    && wget --progress=bar:force -O /tmp/recon-all-freesurfer6-3.min.tgz https://dl.dropbox.com/s/nnzcfttc41qvt31/recon-all-freesurfer6-3.min.tgz \ 
    && tar -xzvf /tmp/recon-all-freesurfer6-3.min.tgz -C /opt/freesurfer-6.0/freesurfer --strip-components 1 \
    && echo "source $FREESURFER_HOME/SetUpFreeSurfer.sh" >> ~/.bashrc \
    && rm /tmp/recon-all-freesurfer6-3.min.tgz \
    && rm -R /opt/freesurfer-6.0/freesurfer/trctrain && \
# Clear apt cache and other empty folders
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /boot /media /mnt /srv && \
    rm -rf ~/.cache/pip

CMD ["bash"]


# Install AFNI
#ENV PATH="/opt/afni-latest:$PATH" \
#    AFNI_PLUGINPATH="/opt/afni-latest"
#RUN apt-get update -qq \
#    && apt-get install -y -q --no-install-recommends \
#           ed \
#           gsl-bin \
#           netpbm \
#           xfonts-base \
#           xvfb \
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
