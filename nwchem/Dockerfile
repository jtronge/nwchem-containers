# Modified NWCHEM container for use with Charliecloud.
#
# Based on
# https://github.com/edoapra/nwchem-singularity/tree/master/nwchem-dev.ompi40x
#Bootstrap: docker

FROM jtronge/ubuntu-mpi

ARG VERSION=master
ARG NUMJOBS=2
ENV OMPI_DIR=/opt/mpi
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
