#!/bin/bash

## Slurm general options
#SBATCH --job-name=MultiProcess
#SBATCH --output=MultiProcess.out
#SBATCH --error=MultiProcess.err
#SBATCH --mail-type=NONE

## Slurm resources
#SBATCH --ntasks=8
# In some cases you want to set the number of nodes and set the number of tasks per node
# #SBATCH --nodes=4
# #SBATCH --ntasks-per-node=1
#SBATCH --mem=1GB
#SBATCH --time=0-00:05:00

## Job environment

## Job steps
srun echo "Hello from" $SLURMD_NODENAME	 with $(nproc --all) CPUs