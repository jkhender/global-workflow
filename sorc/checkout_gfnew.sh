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

echo fv3gfs_gfnew.fd checkout ...
if [[ ! -d fv3gfs_gfnew.fd ]] ; then
    rm -f ${topdir}/checkout-gfnew.log
    git clone https://github.com/ufs-community/ufs-weather-model fv3gfs_gfnew.fd >> ${topdir}/checkout-fv3gfs_gfnew.log 2>&1
    cd fv3gfs_gfnew.fd
    git checkout 14c69ba5aea7d48310981fb62041b5d6fd0a277a
    git submodule update --init --recursive
    cd ${topdir}
    rsync -avx fv3gfs_gfnew.fd_gsl/ fv3gfs_gfnew.fd/        ## copy over changes not in FV3 repository
else
    echo 'Skip.  Directory fv3gfs_gfnew.fd already exists.'
fi

exit 0
