USER=Judy.K.Henderson
GITDIR=/scratch2/BMC/gsd-fv3-dev/Judy.K.Henderson/test/gsd_ccpp_v16b_restructure_update  ## where your git checkout is located
COMROT=$GITDIR/FV3GFSrun                                                                 ## default COMROT directory
EXPDIR=$GITDIR/FV3GFSwfm                                                                 ## default EXPDIR directory

#    ICSDIR is assumed to be under $COMROT/FV3ICS
#cp $GITDIR/parm/config/config.base.emc.dyn $GITDIR/parm/config/config.base

PSLOT=ffemcv16
IDATE=2020082000
EDATE=2020082000
RESDET=768               ## 96 192 384 768

### gfs_cyc 1  00Z only;  gfs_cyc 2  00Z and 12Z

./setup_expt_fcstonly_gsd.py --pslot $PSLOT  \
       --gfs_cyc 1 --idate $IDATE --edate $EDATE \
       --configdir $GITDIR/parm/config \
       --res $RESDET --comrot $COMROT --expdir $EXPDIR

#for running chgres, forecast, and post 
./setup_workflow_fcstonly_gsd.py --expdir $EXPDIR/$PSLOT

# call jobs/rocoto/makefv3ic_link.sh for fv3ic task
sed -i "s/fv3ic.sh/makefv3ic_link.sh/" $EXPDIR/$PSLOT/$PSLOT.xml
# call jobs/rocoto/arch_gsd.sh for gfsarch task
sed -i "s/arch.sh/arch_gsd.sh/" $EXPDIR/$PSLOT/$PSLOT.xml
