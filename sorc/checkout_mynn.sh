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

echo fv3gfs_mynn.fd checkout ...
if [[ ! -d ufs-weather-model_16jun_b50c86d ]] ; then
    rm -f ${topdir}/checkout-mynn.log
    git clone --recursive -b gsl/develop https://github.com/NOAA-GSL/ufs-weather-model ufs-weather-model_16jun_b50c86d >> ${topdir}/checkout-mynn.log 2>&1
    cd ufs-weather-model_16jun_b50c86d
    git checkout b50c86d8fbdc9d4e671b4e235f602d2eacf49508
    git submodule update --init --recursive
    cd ${topdir}
    ln -fs ufs-weather-model_16jun_b50c86d fv3gfs_mynn.fd 
    rsync -ax fv3gfs_mynn.fd_gsl/ fv3gfs_mynn.fd/                    ## copy over MYNN changes not in ccpp-physics repository
else
    echo 'Skip.  Directory fv3gfs_mynn.fd already exists.'
fi

exit 0
