USER=Judy.K.Henderson
GITDIR=/scratch2/BMC/gsd-fv3-dev/Judy.K.Henderson/test/gsd_ccpp_v16b_restructure_update  ## where your git checkout is located
COMROT=$GITDIR/FV3GFSrun                                                                 ## default COMROT directory
EXPDIR=$GITDIR/FV3GFSwfm                                                                 ## default EXPDIR directory

#    ICSDIR is assumed to be under $COMROT/FV3ICS

PSLOT=cycemcv16_c384
IDATE=2020081918
EDATE=2020082100
RESDET=384 
RESENS=192
NENS=20
### gfs_cyc 1  00Z only;  gfs_cyc 2  00Z and 12Z

### note default RESDET=384 RESENS=192 NENS=20
###./setup_expt.py --pslot $PSLOT --configdir $CONFIGDIR --idate $IDATE --edate $EDATE --comrot $COMROT --expdir $EXPDIR [ --icsdir $ICSDIR --resdet $RESDET --resens $RESENS --nens $NENS --gfs_cyc $GFS_CYC ]
#       --icsdir $ICSDIR --idate $IDATE --edate $EDATE \

./setup_expt_gsd.py --pslot $PSLOT  \
       --idate $IDATE --edate $EDATE \
       --configdir $GITDIR/parm/config \
       --resdet $RESDET --resens $RESENS --nens $NENS \
       --comrot $COMROT --expdir $EXPDIR

#for running chgres, forecast, and post 
./setup_workflow.py --expdir $EXPDIR/$PSLOT
