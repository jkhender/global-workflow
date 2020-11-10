#!/bin/bash

module purge
module load intel/18.0.5.274
module load impi/2018.4.274
module load hdf5/1.10.4
module load netcdf/4.6.1
module load udunits/2.1.24
module load ncl/6.5.0
module use -a /contrib/anaconda/modulefiles
module load anaconda/2.0.1

export LD_PRELOAD=$PWD/thirdparty/lib/libjpeg.so
export PATH=$PWD/thirdparty/bin:$PATH
export LD_LIBRARY_PATH=$PWD/thirdparty/lib:$PWD/thirdparty/lib64:$LD_LIBRARY_PATH
export PYTHONPATH=$PWD/thirdparty/lib/python2.7/site-packages:$PYTHONPATH

