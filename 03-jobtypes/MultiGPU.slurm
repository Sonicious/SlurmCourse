#!/bin/bash

## Slurm general options
#SBATCH --job-name=MultiGPU
#SBATCH --output=MultiGPU.out
#SBATCH --error=MultiGPU.err
#SBATCH --mail-type=NONE

## Slurm resources
#SBATCH --partition=paula
#SBATCH --gpus=10

## Job environment

## Job steps
srun echo $(hostname -f) with $(nvidia-smi -L)
