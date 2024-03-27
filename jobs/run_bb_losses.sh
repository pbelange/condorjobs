#!/bin/bash


# PARSE BASH INPUTS
#=========================================================================================
collider_name   =   $1
#=========================================================================================


# IMPORT COLLIDERS AND CONFIGS
#=========================================================================================
EOS_DIR = root://eosuser.cern.ch//eos/user/p/phbelang/database/bb_losses
#-----------------------------------------------------------------------------------------

# Main Script
xrdcp ${EOS_DIR}/run_tracking_htc.py ./main.py

# Collider
mkdir colliders
xrdcp ${EOS_DIR}/colliders/collider_${collider_name}.json ./colliders/

# Config
mkdir configs
xrdcp ${EOS_DIR}/configs/config_universal.json ./configs/

# Particles
mkdir particles
xrdcp ${EOS_DIR}/particles/particles_hypersphere.parquet ./particles/

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
python main.py --device GPU --collider ${collider_name}
#=========================================================================================

# EXPORT RESULTS ("xrdcp -f" to overwrite)
#=========================================================================================
EXPORT_DIR = root://eosuser.cern.ch//eos/user/p/phbelang/database/bb_losses
#-----------------------------------------------------------------------------------------
xrdcp -rf ./tracking ${EXPORT_DIR}/
#=========================================================================================



