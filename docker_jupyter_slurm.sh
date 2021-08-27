#!/bin/bash

#SBATCH --job-name=jupyterLG
#SBATCH --partition=gpu
#SBATCH --qos=normal
#SBATCH --mem-per-cpu=1gb
#SBATCH -t 00-08:00:00
#SBATCH --gres=gpu:1
#SBATCH --error=/raid/lgaudet/slurm_error_logs/error_%j.err
#SBATCH --output=/raid/lgaudet/slurm_output_logs/log_%j.out

#to specify specific GPU devices change gpus= to -e NVIDIA_VISIBLE_DEVICES=4,5,6

docker run -v /raid/lgaudet:/home/lgaudet -v /raid/NYSM:/home/lgaudet/NYSM -v /rdma/flash/AI2ES/data:/home/lgaudet/model-data --name=jupyter_lg -w /home/lgaudet -u lgaudet --runtime=nvidia --gpus=1 -p 8886:88
88 akurbanovas/lg.ai2es:v0.2 /opt/conda/bin/jupyter lab --port=8888 --ip=0.0.0.0 --allow-root --no-browser /home/lgaudet

#docker run -v /raid/lgaudet:/home/lgaudet -v /raid/NYSM:/home/lgaudet/NYSM -v /rdma/flash/AI2ES/data:/home/lgaudet/model-data --name=jupyter_lg -w /home/lgaudet -u lgaudet --runtime=nvidia --gpus=1 -p 8886:88
88 akurbanovas/lg.ai2es:v0.2 python job.py
