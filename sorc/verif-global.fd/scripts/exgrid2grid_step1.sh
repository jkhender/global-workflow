#!/bin/sh
# Program Name: grid2grid_step1
# Author(s)/Contact(s): Mallory Row
# Abstract: Run METplus for global grid-to-grid verification
#           to produce SL1L2 and VL1L2 stats
# History Log:
#   2/2019: Initial version of script
# 
# Usage:
#   Parameters: 
#       agrument to script
#   Input Files:
#       file
#   Output Files:  
#       file
#  
# Condition codes:
#       0 - Normal exit
# 
# User controllable options: None

set -x 

# Set up directories
mkdir -p $RUN
cd $RUN

# Set up environment variables for initialization, valid, and forecast hours and source them
python $USHverif_global/set_init_valid_fhr_info.py
status=$?
[[ $status -ne 0 ]] && exit $status
[[ $status -eq 0 ]] && echo "Succesfully ran set_init_valid_fhr_info.py"
echo
. $DATA/$RUN/python_gen_env_vars.sh
[[ $status -ne 0 ]] && exit $status
[[ $status -eq 0 ]] && echo "Succesfully sourced python_gen_env_vars.sh"
echo

# Link needed data files and set up model information
mkdir -p data
python $USHverif_global/get_data_files.py
[[ $status -ne 0 ]] && exit $status
[[ $status -eq 0 ]] && echo "Succesfully ran get_data_files.py"
echo

# Create output directories for METplus
python $USHverif_global/create_METplus_output_dirs.py
[[ $status -ne 0 ]] && exit $status
[[ $status -eq 0 ]] && echo "Succesfully ran create_METplus_output_dirs.py"
echo

# Create job scripts to run METplus
python $USHverif_global/create_METplus_job_scripts.py
[[ $status -ne 0 ]] && exit $status
[[ $status -eq 0 ]] && echo "Succesfully ran create_METplus_job_scripts.py"

# Run METplus job scripts
chmod u+x metplus_job_scripts/job*
if [ $MPMD = YES ]; then
    ncount=$(ls -l  metplus_job_scripts/poe* |wc -l)
    nc=0
    while [ $nc -lt $ncount ]; do
        nc=$((nc+1))
        poe_script=$DATA/$RUN/metplus_job_scripts/poe_jobs${nc}
        chmod 775 $poe_script
        export MP_PGMMODEL=mpmd
        export MP_CMDFILE=${poe_script}
        if [ $machine = WCOSS_C ]; then
            launcher="aprun -j 1 -n ${nproc} -N ${nproc} -d 1 cfp"
        elif [ $machine = WCOSS_DELL_P3 ]; then
            launcher="mpirun -n ${nproc} cfp"
        elif [ $machine = HERA ]; then
            launcher="srun --export=ALL --multi-prog"
        fi
        $launcher $MP_CMDFILE
    done
else
    ncount=$(ls -l  metplus_job_scripts/job* |wc -l)
    nc=0
    while [ $nc -lt $ncount ]; do
        nc=$((nc+1))
        sh +x $DATA/$RUN/metplus_job_scripts/job${nc}
    done
fi

# Copy data to user archive or to COMOUT
gather_by=$g2g1_gather_by
if [ $gather_by = INIT ]; then
    gather_by_hour_list=$g2g1_fcyc_list
else
    gather_by_hour_list=$g2g1_vhr_list
fi
DATE=${start_date}
while [ $DATE -le ${end_date} ] ; do
    export DATE=$DATE
    export COMIN=${COMIN:-$COMROOT/$NET/$envir/$RUN.$DATE}
    export COMOUT=${COMOUT:-$COMROOT/$NET/$envir/$RUN.$DATE}
    m=0
    arch_dirs=($model_arch_dir_list)
    for model in $model_list; do
        export model=$model
        export arch_dir=${arch_dirs[m]} 
        arch_dir_strlength=$(echo -n $arch_dir | wc -m)
        if [ $arch_dir_strlength = 0 ]; then
            arch_dir=${arch_dirs[0]}
        fi
        for type in $g2g1_type_list; do
            # Copy to requested locations
            for gather_by_hour in $gather_by_hour_list; do
                verif_global_filename="metplus_output/gather_by_$gather_by/stat_analysis/$type/$model/${model}_${DATE}${gather_by_hour}.stat"
                arch_filename="$arch_dir/metplus_data/by_$gather_by/grid2grid/$type/${gather_by_hour}Z/$model/${model}_${DATE}.stat"
                comout_filename="$COMOUT/${model}_grid2grid_${type}_${DATE}_${gather_by_hour}Z_${gather_by}.stat"
                if [ -s $verif_global_filename ]; then
                   if [ $SENDARCH = YES ]; then
                       mkdir -p $arch_dir/metplus_data/by_$gather_by/grid2grid/$type/${gather_by_hour}Z/$model
                       cpfs $verif_global_filename $arch_filename
                   fi
                   if [ $SENDCOM = YES ]; then
                       mkdir -p $COMOUT
                       cpfs $verif_global_filename $comout_filename
                       if [ "${SENDDBN^^}" = YES ]; then
                           $DBNROOT/bin/dbn_alert MODEL VERIF_GLOBAL $job $veif_global_filename
                       fi
                   fi
                else
                   echo "*************************************************************"
                   echo "** WARNING: $verif_global_filename was not generated or zero size"
                   echo "*************************************************************"
                fi
            done
        done
        m=$((m+1))
    done
    DATE=$(echo $($NDATE +24 ${DATE}00 ) |cut -c 1-8 )
done

# Send data to METviewer AWS server
if [ $SENDMETVIEWER = YES ]; then
    python $USHverif_global/load_to_METviewer_AWS.py
fi