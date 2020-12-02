USER=Judy.K.Henderson
PTMP=/scratch2/BMC/gsd-fv3-dev/NCEPDEV/stmp3/${USER}                     ## default PTMP directory
STMP=/scratch2/BMC/gsd-fv3-dev/NCEPDEV/stmp4/${USER}                     ## default STMP directory
GITDIR=/scratch2/BMC/gsd-fv3-dev/Judy.K.Henderson/test/emc_feature_lgan  ## where your git checkout is located
COMROT=${GITDIR}/FV3GFSrun                                               ## default COMROT directory
EXPDIR=${GITDIR}/FV3GFSwfm                                               ## default EXPDIR directory

PSLOT=gsdnoahcyc
IDATE=2020020800
EDATE=2020021000
RESDET=768
RESENS=384
NENS=80
HPSS_PROJECT=fim

### note default RESDET=384 RESENS=192 NENS=20  CCPP_SUITE=FV3_GFS_v16beta
###./setup_expt.py --pslot $PSLOT --configdir $CONFIGDIR --idate $IDATE --edate $EDATE --comrot $COMROT --expdir $EXPDIR [ --icsdir $ICSDIR --resdet $RESDET --resens $RESENS --nens $NENS --gfs_cyc $GFS_CYC ]

./setup_expt_gsd.py --pslot $PSLOT  \
       --idate $IDATE --edate $EDATE \
       --configdir $GITDIR/parm/config \
       --resdet=$RESDET --resens $RESENS \
       --nens $NENS --comrot $COMROT --expdir $EXPDIR

#for running chgres, forecast, and post 
./setup_workflow.py --expdir $EXPDIR/$PSLOT

