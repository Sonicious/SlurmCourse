#!/bin/bash

## Slurm general options
#SBATCH --job-name=SingleGPU
#SBATCH --output=SingleGPU.out
#SBATCH --error=SingleGPU.err
#SBATCH --mail-type=NONE

## Slurm resources
#SBATCH --partition=clara
#SBATCH --gpus=v100:1

## Job environment

## Job steps
srun echo $(hostname -f) with $(nvidia-smi -L)
