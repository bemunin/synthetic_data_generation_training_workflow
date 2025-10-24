#!/bin/bash

# Check if Isaac Sim path is provided as argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <FULL_PATH_TO_ISAAC_SIM>"
    echo "Example: $0 /home/user/isaacsim"
    exit 1
fi

# Options: 0 (Performance), 1 (Balanced), 2 (Quality), 3 (Auto)
DLSS_MODE=2  # Set DLSS mode to Quality
HEADLESS=true

# This is the path where Isaac Sim is installed which contains the python.sh script
ISAAC_SIM_PATH="$1"

# Validate that the Isaac Sim path exists and contains python.sh
if [ ! -d "$ISAAC_SIM_PATH" ]; then
    echo "Error: Isaac Sim path '$ISAAC_SIM_PATH' does not exist"
    exit 1
fi

if [ ! -f "$ISAAC_SIM_PATH/python.sh" ]; then
    echo "Error: python.sh not found in '$ISAAC_SIM_PATH'"
    echo "Please make sure you provided the correct Isaac Sim installation path"
    exit 1
fi

## Go to location of the SDG script
cd ../palletjack_sdg
SCRIPT_PATH="${PWD}/standalone_palletjack_sdg.py"
OUTPUT_WAREHOUSE="${PWD}/palletjack_data/distractors_warehouse"
OUTPUT_ADDITIONAL="${PWD}/palletjack_data/distractors_additional"
OUTPUT_NO_DISTRACTORS="${PWD}/palletjack_data/no_distractors"


# set CPU to performance mode before running Isaac Sim
sudo cpupower frequency-set -g performance

## Go to Isaac Sim location for running with ./python.sh
cd $ISAAC_SIM_PATH

start_time=$(date +%s)

echo "Starting Data Generation using Isaac Sim at: $ISAAC_SIM_PATH"  

./python.sh $SCRIPT_PATH --headless $HEADLESS --dlss $DLSS_MODE --height 544 --width 960 --num_frames 2000 --distractors warehouse --data_dir $OUTPUT_WAREHOUSE

./python.sh $SCRIPT_PATH --headless $HEADLESS --dlss $DLSS_MODE --height 544 --width 960 --num_frames 2000 --distractors additional --data_dir $OUTPUT_ADDITIONAL

./python.sh $SCRIPT_PATH --headless $HEADLESS --dlss $DLSS_MODE --height 544 --width 960 --num_frames 1000 --distractors None --data_dir $OUTPUT_NO_DISTRACTORS

end_time=$(date +%s)

echo "Execution time was $(($end_time - $start_time)) seconds."
