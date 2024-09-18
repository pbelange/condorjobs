#!/bin/bash


# PARSE BASH INPUTS
#=========================================================================================
JOB_ID=$1
#=========================================================================================

# IMPORT COLLIDERS AND CONFIGS
#=========================================================================================
EOS_DIR=root://eosuser.cern.ch//eos/user/p/phbelang/database/study_HL_BBLR
#-----------------------------------------------------------------------------------------

# Main Script
xrdcp ${EOS_DIR}/compute_survival_BBLR.py ./main.py

# Copy Metadata:
xrdcp -r ${EOS_DIR}/HL_190/ ./

# Creating outputs directory
mkdir outputs
#=========================================================================================


# EXTRA MANIPULATIONS (OPTIONAL)
#=========================================================================================
# # modify universal config for proper collider name
# #--------
# sed -i 's/collider_PLACEHOLDER/collider_${collider_name}.json/g' configs/config_universal.json
# sed -i 's/name_PLACEHOLDER/${collider_name}/g' configs/config_universal.json
# #--------
#=========================================================================================


# RUN SIMULATION
#=========================================================================================
python main.py -id ${JOB_ID}
#=========================================================================================

# EXPORT RESULTS ("xrdcp -f" to overwrite)
#=========================================================================================
EXPORT_DIR=root://eosuser.cern.ch//eos/user/p/phbelang/database/study_HL_BBLR
#-----------------------------------------------------------------------------------------
xrdcp -rf ./outputs ${EXPORT_DIR}/
#=========================================================================================



