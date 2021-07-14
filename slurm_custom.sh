#!/bin/bash
#SBATCH --job-name=GPUTest
#SBATCH -p gpu
#SBATCH --nodes=1
#SBATCH -n 1
#SBATCH --mem-per-cpu=1000
#SBATCH --time=00:05:00
#SBATCH --gres=gpu:1

docker run --runtime=nvidia --rm jpan:v0.1
