#!/bin/bash

## Slurm general options
#SBATCH --job-name=SerialArray
#SBATCH --output=SerialArray.out
#SBATCH --error=SerialArray.err
#SBATCH --mail-type=NONE

## Slurm resources
#SBATCH --partition=paul
#SBATCH --time=0-01:00:00
#SBATCH --mem=20GB
#SBATCH --array=1-10

## Job environment

## Job steps
echo "Hello from" $(hostname -f) with with Array ID $SLURM_ARRAY_TASK_ID