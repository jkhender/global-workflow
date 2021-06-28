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

echo dom_thmpsubcyc checkout ...
if [[ ! -d dom_thmpsubcyc ]] ; then
    rm -f ${topdir}/checkout-dom.log
    git clone -b bugfix_thompson_pass_correct_timestep --recursive https://github.com/climbfuji/ufs-weather-model  dom_thmpsubcyc >> ${topdir}/checkout-dom.log 2>&1
    cd dom_thmpsubcyc
    git submodule update --init --recursive
    cd ${topdir}
    ln -fs dom_thmpsubcyc fv3gfs_dom.fd
else
    echo 'Skip.  Directory fv3gfs_dom.fd already exists.'
fi

exit 0
