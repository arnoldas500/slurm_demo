#!/bin/bash

#SBATCH --job-name=cnnViT
#SBATCH --account=ai2es
#SBATCH --qos=long
#SBATCH --time=96:00:00
#SBATCH --partition=gh200
#SBATCH --nodelist=gh201
#SBATCH --error=/home/aevans/slurm_error_logs/ai2es_error_%j.err
#SBATCH --output=/home/aevans/slurm_output_logs/ai2es_log_%j.out

while true; do foo; sleep 2; done
