import numpy as np
import pandas as pd
import gc
import subprocess
import time
import json
import ruamel.yaml

import BBStudies.Tracking.Utils as xutils


from pathlib import Path
JOBS = {f.name[:4]:str(f) for f in list(Path('./Jobs').glob('J*'))} 




def run_jobs(user_context = 'GPU', device_id = None,collider_file = None):
    # Load Config
    #-------------------------
    config_file = 'configs/config_J003.yaml'
    tmp_file    = 'configs/tmp_config_J003_{user_context}_{device_id}.yaml'
    #-------------------------

    # Choose collider file from device_id
    collider_name   = collider_file.split('collider_')[1].split('.json')[0]
    particle_name   = 'HYPERSPHERE'
    sequence        = 'lhcb2'



    # Update config
    config = xutils.read_YAML(config_file)

    # TRACKING
    #====================================
    config['tracking']['num_turns']                 = int(2e4)
    config['tracking']['size_chunks']               = int(1000)
    #====================================

    #====================================
    config['tracking']['context']['type']           = user_context
    config['tracking']['context']['device_id']      = None
    #-----------------------
    config['tracking']['collider']['path']          = f'colliders/{collider_file}'
    config['tracking']['collider']['name']          = collider_name
    config['tracking']['collider']['sequence']      = sequence
    #-----------------------
    config['tracking']['collider']['cycle_at']      = 'IP3'
    config['tracking']['collider']['monitor_at']    = ['TCP_V', 'TCP_H', 'TCP_S'] 
    #====================================

    #====================================
    config['tracking']['particles']['path']         = f'particles/{particle_name}.parquet'
    config['tracking']['particles']['name']         = particle_name
    #====================================



    # ANALYSIS
    #====================================
    config['analysis']['path']                      = 'tracking'

    #-----------------------
    config['analysis']['num_turns']                 = int(1e4)
    #-----------------------
    
    #-----------------------
    config['analysis']['turn_by_turn']['active']    = False
    config['analysis']['naff']['active']            = False

    config['analysis']['checkpoints']['active']     = True
    config['analysis']['excursion']['active']       = True
    #-----------------------
    
    #-----------------------
    config['analysis']['naff']['num_turns']         = None
    config['analysis']['naff']['num_harmonics']     = None
    config['analysis']['naff']['window_order']      = None
    config['analysis']['naff']['window_type']       = None
    config['analysis']['naff']['multiprocesses']    = None
    #====================================




    # Save tmp file
    #-------------------------
    tmp_file = tmp_file.format( user_context = config['tracking']['context']['type'],
                                device_id    = config['tracking']['context']['device_id'])
    xutils.save_YAML(config,file=tmp_file)
    #-------------------------


    # Running Jop
    #====================================
    print(f'RUNNING FILE: {tmp_file}')
    subprocess.run(["cat",f"{tmp_file}"])
    print(40*'=')
    subprocess.run(["python", f"{JOBS['J003']}/main.py","-c", f"{tmp_file}"])
    # subprocess.run(["python", f"{JOBS['J004']}/main.py",   "--data_path"       , f"{config['tracking']['data_path']}",
    #                                                             "--checkpoint_path" , f"{config['tracking']['checkpoint_path']}",
    #                                                             "--partition_name"  , f"{config['tracking']['partition_name']}",
    #                                                             "--partition_ID"    , f"{config['tracking']['partition_ID']}"])
    #====================================




# ==================================================================================================
# --- Script for execution
# ==================================================================================================
if __name__ == '__main__':
    import argparse
    # Adding command line parser
    aparser = argparse.ArgumentParser()
    aparser.add_argument("-d", "--device"   ,help = "device [CPU | GPU]"    ,default = 'GPU')
    aparser.add_argument("-c", "--collider" ,help = "collider_file"         ,default = None)
    aparser.add_argument("-i", "--id"       ,help = "device ID"             ,default = 0)
    args = aparser.parse_args()
    
    
    run_jobs(user_context = args.device, device_id = int(args.id),collider_file=args.collider)
    #===========================