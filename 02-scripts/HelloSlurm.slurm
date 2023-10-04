#!/bin/bash

## Slurm general options
#SBATCH --job-name=HelloSlurm
#SBATCH --output=HelloSlurm.out
#SBATCH --error=HelloSlurm.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<email>

## Slurm resources
#SBATCH --time=0-00:01:00

## Job environment

## Job steps
echo "Hello from" $(hostname -f)
