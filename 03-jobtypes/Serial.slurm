#!/bin/bash

## Slurm general options
#SBATCH --job-name=Serial
#SBATCH --output=Serial.out
#SBATCH --error=Serial.err
#SBATCH --mail-type=NONE

## Slurm resources
#SBATCH --partition=paul
#SBATCH --time=0-00:01:00
#SBATCH --mem=20GB

## Job environment

## Job steps
echo "Hello from" $(hostname -f)