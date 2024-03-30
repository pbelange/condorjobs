#!/bin/bash


# PARSE BASH INPUTS
#=========================================================================================
collider_file=$1
#=========================================================================================

# IMPORT COLLIDERS AND CONFIGS
#=========================================================================================
EOS_DIR=root://eosuser.cern.ch//eos/user/p/phbelang/database/study_IPAC24
#-----------------------------------------------------------------------------------------

# Main Script
xrdcp ${EOS_DIR}/run_J003_J004_batch.py ./main.py

# Copy Jobs:
xrdcp -r ${EOS_DIR}/Jobs/ ./

# Collider
mkdir colliders
xrdcp ${EOS_DIR}/colliders/${collider_file} ./colliders/

# Config
mkdir configs
xrdcp ${EOS_DIR}/configs/config_J003.yaml ./configs/

# Particles
mkdir particles
xrdcp ${EOS_DIR}/particles/HYPERSPHERE.parquet ./particles/

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
python main.py --device GPU --collider ${collider_file}
#=========================================================================================

# EXPORT RESULTS ("xrdcp -f" to overwrite)
#=========================================================================================
EXPORT_DIR=root://eosuser.cern.ch//eos/user/p/phbelang/database/study_IPAC24
#-----------------------------------------------------------------------------------------
xrdcp -rf ./tracking ${EXPORT_DIR}/
#=========================================================================================



