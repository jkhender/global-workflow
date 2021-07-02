#!/bin/sh
#set -xue
set -x

while getopts "oc" option;
do
 case $option in
  o)
   echo "Received -o flag for optional checkout of GTG, will check out GTG with EMC_post"
   checkout_gtg="YES"
   ;;
  c)
   echo "Received -c flag, check out ufs-weather-model develop branch with CCPP physics"  
   run_ccpp="YES"
   ;;
  :)
   echo "option -$OPTARG needs an argument"
   ;;
  *)
   echo "invalid option -$OPTARG, exiting..."
   exit
   ;;
 esac
done

topdir=$(pwd)
echo $topdir

echo fv3gfs_gf.fd checkout ...
if [[ ! -d fv3gfs_gf.fd ]] ; then
    rm -f ${topdir}/checkout-gfnew.log
    git clone -b 14c69ba https://github.com/ufs-community/ufs-weather-model fv3gfs_gf.fd >> ${topdir}/checkout-fv3gfs_gf.log 2>&1
    cd fv3gfs_gf.fd
    git submodule update --init --recursive
    cd ${topdir}
    rsync -ax fv3gfs_gf.fd_gsl/ fv3gfs_gf.fd/        ## copy over changes not in FV3 repository
else
    echo 'Skip.  Directory fv3gfs_gf.fd already exists.'
fi

exit 0
