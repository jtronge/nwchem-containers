# Modified NWCHEM container for use with Charliecloud.
#
# Based on
# https://github.com/edoapra/nwchem-singularity/tree/master/nwchem-dev.ompi40x
#Bootstrap: docker

FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
ARG VERSION=master

RUN pwd \
&& apt-get -y update \
&& apt-get -y install -y tzdata git \
&& pwd \
&& echo '@@ ls -lart ' \
&& ls -lart  \
&& echo '@@ ls on /opt' \
&& ls -lart /opt \
&& apt-get -y install -y curl wget tar libnl-3-200 libnl-route-3-200 libgomp1 libnuma1 \
 g++ gfortran   make ssh patch curl  wget unzip perl-base file \
 python3 python3-dev cmake  unzip zip perl automake libtool autoconf flex  \
 libnuma-dev libslurm-dev libnl-3-dev libnl-route-3-dev udev libevent-dev \
 hwloc libhwloc-dev

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
ENV OMPI_DIR=/opt/mpi
# Install OpenMPI
RUN curl -O -L https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.2.tar.bz2 && \
    tar -xvf openmpi-4.1.2.tar.bz2 && \
    cd openmpi-4.1.2 && \
    ./configure --prefix=$OMPI_DIR --with-pmix=$PMIX_DIR --with-ompi-pmix-rte \
                --with-slurm --enable-mpi1-compatibility && \
    make -j$NUMJOBS && \
    make install && \
    echo "$OMPI_DIR/lib" >> /etc/ld.so.conf.d/mpi.conf && \
    ldconfig

ENV PATH=$OMPI_DIR/bin:$PATH
# ENV LD_LIBRARY_PATH=$OMPI_DIR/lib:$LD_LIBRARY_PATH
ENV ARMCI_NETWORK=MPI-PR
#export NWCHEM_TOP=/opt/nwchem
ENV NWCHEM_TARGET=LINUX64
ENV NWCHEM_MODULES="tce ccsd"
# ENV NWCHEM_MODULES="tce"
ENV BUILD_OPENBLAS=1
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

RUN git clone https://github.com/nwchemgit/nwchem.git \
&& cd nwchem \
&& git fetch \
&& git checkout $VERSION \
&& export NWCHEM_TOP=`pwd` \
&& ls -lrt \
&& cd src \
&& make nwchem_config && make -j6  \
&& make install INSTALL_PREFIX=/opt/nwchem \
&& DEBIAN_FRONTEND=noninteractive apt-get -y install localepurge \
&& echo MANDELETE >  /etc/locale.nopurge \
&& echo DONTBOTHERNEWLOCALE >> /etc/locale.nopurge \
&& echo en_US.UTF-8 >> /etc/locale.nopurge \
&& localepurge \
&& rm -rf /usr/share/doc  /usr/share/man \
&& du -sh /opt/nwchem \
&& du -sk /opt/nwchem/*|sort -n \
&& rm -rf tce tools nwdft NWints/simint/libsimint_source/simint.l?_p?_d? geom symmetry util nwxc ddscf lapack blas rism argos peigs rmdft gradients symmetry property smd lucia dplot propery hessian ccsd mp2_grad moints cafe analyz dimqm   develop libext/scalapack libext/openblas libext/libxc/libxc*   ../lib || true\
&& ls -la NWints/simint/libsimint_source || true \
&& ls -la NWints/simint || true \
&& du -sk *|sort -n  || true\
&& cd .. \
&& du -sk *|sort -n || true \
&& dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n | tail -n 100
