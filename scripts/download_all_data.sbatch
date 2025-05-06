#!/bin/bash
# sbatch ...

#SBATCH -j mysrun 
#SBATCH -N 1 
#SBATCH --mem=8g 
#SBATCH -t 240

#SBATCH -p msismall 
#SBATCH --tmp=100g 
download_all_data.sh ${OPENFOLD_HOME}/resources
