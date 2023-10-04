#!/bin/bash

## Slurm general options
#SBATCH --job-name=MultiThread
#SBATCH --output=MultiThread.out
#SBATCH --error=MultiThread.err
#SBATCH --mail-type=NONE

## Slurm resources
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --time=0-00:05:00
#SBATCH --mem-per-cpu=3GB

## Job environment
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

## Job steps
nproc --all