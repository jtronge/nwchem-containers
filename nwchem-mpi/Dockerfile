
# Modified MPI base container for use with Charliecloud.
#
# Based on
# https://github.com/edoapra/nwchem-singularity/tree/master/nwchem-dev.ompi40x
#Bootstrap: docker
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && \
    apt-get -y install -y tzdata git && \
    apt-get -y install -y curl wget tar libnl-3-200 libnl-route-3-200 libgomp1 libnuma1 \
       g++ gfortran   make ssh patch curl  wget unzip perl-base file \
       python3 python3-dev cmake  unzip zip perl automake libtool autoconf flex  \
       libnuma-dev libslurm-dev libnl-3-dev libnl-route-3-dev udev libevent-dev \
       hwloc libhwloc-dev libpmi2-0
ARG NUMJOBS=8
ENV PMIX_DIR=/opt/pmix
# Install PMIx
RUN curl -O -L https://github.com/openpmix/openpmix/releases/download/v4.1.0/pmix-4.1.0.tar.bz2 && \
    tar -xvf pmix-4.1.0.tar.bz2 && \
    cd pmix-4.1.0 && \
    ./configure --prefix=/opt/pmix --disable-man-pages && \
    make -j$NUMJOBS && \
    make install && \
    echo "$PMIX_DIR/lib" >> /etc/ld.so.conf.d/pmix.conf && \
    ldconfig
# Install PMI2 manually (based on Charliecloud example)
ENV PMI_DIR=/opt/pmi
ARG SLURM_VERSION=21.08.5
RUN curl -O -L https://download.schedmd.com/slurm/slurm-$SLURM_VERSION.tar.bz2 && \
    tar -xvf slurm-$SLURM_VERSION.tar.bz2 && \
    cd slurm-$SLURM_VERSION && \
    ./configure --prefix=$PMI_DIR && \
    cd contribs/pmi2 && \
    make install
# Install OpenMPI
ENV OMPI_DIR=/opt/mpi
RUN curl -O -L https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.2.tar.bz2 && \
    tar -xvf openmpi-4.1.2.tar.bz2 && \
    cd openmpi-4.1.2 && \
    ./configure --prefix=$OMPI_DIR --with-pmix=$PMIX_DIR --with-pmi=$PMI_DIR \
                --with-ompi-pmix-rte --with-slurm --enable-mpi1-compatibility && \
    make -j$NUMJOBS && \
    make install && \
    echo "$OMPI_DIR/lib" >> /etc/ld.so.conf.d/mpi.conf && \
    ldconfig

# Installation specific to NWChem
# Modified NWCHEM container for use with Charliecloud.
#
# Based on
# https://github.com/edoapra/nwchem-singularity/tree/master/nwchem-dev.ompi40x
#Bootstrap: docker
ARG VERSION=master
ARG NUMJOBS=2
ENV PATH=$OMPI_DIR/bin:$PATH
# ENV LD_LIBRARY_PATH=$OMPI_DIR/lib:$LD_LIBRARY_PATH
ENV ARMCI_NETWORK=MPI-PR
#export NWCHEM_TOP=/opt/nwchem
ENV NWCHEM_TARGET=LINUX64
ENV NWCHEM_MODULES="all python"
# ENV NWCHEM_MODULES="tce"
# ENV BUILD_OPENBLAS=1
# ENV TARGET=HASWELL
# use internal BLAS for right now
ENV USE_INTERNALBLAS=y
ENV BUILD_SCALAPACK=1
ENV BLAS_SIZE=8
ENV SCALAPACK_SIZE=8
#export USE_64TO32=y
ENV USE_MPI=y
ENV USE_MPIF=y
ENV USE_MPIF4=y
ENV USE_HWOPT=n
ENV USE_LIBXC=y
ENV USE_NOIO=y
ENV USE_SIMINT=y
ENV SIMINT_MAXAM=5
ENV NWCHEM_TOP=/nwchem
# get the version directly through the GitHub API instead of with git (it's faster this way)
RUN curl -L https://api.github.com/repos/nwchemgit/nwchem/tarball/$VERSION > nwchem.tar.gz && \
    mkdir -p nwchem && \
    cd nwchem && \
    tar zxvf ../nwchem.tar.gz --strip-components=1 && \
    cd src && \
    make nwchem_config && \
    make -j$NUMJOBS && \
    make install INSTALL_PREFIX=/opt/nwchem
