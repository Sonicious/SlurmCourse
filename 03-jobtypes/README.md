# Slurm Job Types

## Serial Jobs

Serial Jobs run on **one** cluster node on **one** CPU only. Most of these can be done on your local computer as well. But sometimes it might need much RAM or it is a long running job. You should check out the hardware and the time limit of the cluster before submitting a job. You can check the hardware with `sinfo`. 

Some basic parameters are:

- `--partition`: This is the partition you want to use. The default is `paul`.
- `--time`: This is the maximum runtime of your job. The format is `days-hours:minutes:seconds`
- `--mem`: This is the maximum memory of your job. You can use units like `GB` or `MB`.

Example: `Serial.slurm`
    
```bash
## Slurm resources
#SBATCH --partition=paul
#SBATCH --time=0-00:01:00
#SBATCH --mem=20GB
```

## Serial Array Jobs

These kind of jobs are a special case of serial jobs. They run on **one** cluster node on **one** CPU only. But they run multiple times with different parameters. This is useful for jobs that can be parallelized. You can use the `--array` option to specify the number of jobs you want to run.

Example: `SerialArray.slurm`

```bash
## Slurm resources
#SBATCH --partition=paul
#SBATCH --time=0-01:00:00
#SBATCH --mem=20GB
#SBATCH --array=1-10

## Job environment

## Job steps
echo "Hello from" $(hostname -f) with with Array ID $SLURM_ARRAY_TASK_ID
```

Which can have a result like this:

```bash
@login01:~ $ cat SerialArray.out
Hello from paul02.sc.uni-leipzig.de with with Array ID 1
Hello from paul02.sc.uni-leipzig.de with with Array ID 7
Hello from paul02.sc.uni-leipzig.de with with Array ID 6
Hello from paul02.sc.uni-leipzig.de with with Array ID 9
Hello from paul02.sc.uni-leipzig.de with with Array ID 8
Hello from paul02.sc.uni-leipzig.de with with Array ID 3
Hello from paul02.sc.uni-leipzig.de with with Array ID 2
```

The missing jobs come from the parallel outputs from the jobs. You can use the `--output` option to specify the output file. The placeholders `%a` and `%A` can be used to specify the array ID and the array job ID (). The default is `slurm-%j.out`. Also for the `--array` option, you can use the following specifications

- `--array=1-10`: This will run 10 jobs with the array IDs 1 to 10.
- `--array=1-10:2`: The parameter `:2` is the step size. This will run 5 jobs with the array IDs 1, 3, 5, 7, and 9.
- `--array=1-10%2`: This parameter ensures that only 2 jobs are running at the same time. 
- `--array=1,4,8,9`: This will the jobs with the array IDs 1, 4, 8, and 9.
- `--array=1,4,6-9,25`: This will the jobs with the array IDs 1, 4, 6, 7, 8, 9, and 25.

more complex Example: `SerialArrayComplex.slurm`

```bash
#!/bin/bash

## Slurm general options
#SBATCH --job-name=SerialArrayComplex
#SBATCH --output=SerialArrayComplex_%A.out-%a

## Slurm resources
#SBATCH --partition=paul
#SBATCH --time=0-01:00:00
#SBATCH --mem=20GB
#SBATCH --array=1,4,8-10

## Job environment

## Job steps
echo "Hello from" $(hostname -f) with with Array ID $SLURM_ARRAY_TASK_ID
```

This will ensure one single file for each job. The output will look like this:

```bash
@login01:~ $ cat SerialArrayComplex_2833454.out-1
Hello from paul02.sc.uni-leipzig.de with with Array ID 1
@login01:~ $ cat SerialArrayComplex_2833454.out-4
Hello from paul02.sc.uni-leipzig.de with with Array ID 4
...
```

## Multi-threaded Jobs

Multi-threaded Jobs run on **one** cluster node on **multiple** CPUs. This is useful for jobs that can be parallelized. You can use the `--cpus-per-task` option to specify the number of CPUs you want to use.

Some basic parameters are:

- `--ntasks`: This is the number of tasks (processes) you want to run. The default is 1.
- `cpus-per-task`: This is the number of CPUs you want to use per task. By default it just takes all available CPUs on the node. But if you need at least some amount of CPUs, you can specify it here. It helps the scheduler to find a suitable node for your job.

You can use the Environment Variable `SLURM_CPUS_PER_TASK` to set the number of threads for specific reasons (e.g. OpenMP). You can check the number of CPUs in a shell with `nproc --all`.

The memory is shared between all threads. So if you have 4 CPUs and 20GB of memory, each thread has 5GB of memory. In case you need more memory, you can use the `--mem-per-cpu` option to specify the memory per CPU. The options `--mem` and `--mem-per-cpu` are mutually exclusive.

Example: `MultiThread.slurm`
    
```bash
## Slurm resources
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --time=0-00:05:00
#SBATCH --mem-per-cpu=3GB

## Job environment
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

## Job steps
nproc --all
```

## Multi Process Jobs

Multi Process Jobs run on **multiple** cluster nodes on **multiple** CPUs. This usually requires a MPI implementation. Also many applications require a special configuration to run in a multi node environment. You can use the `--ntasks` option to specify the number of tasks you want to run.

Some basic parameters are:

- `--ntasks`: This is the number of tasks you want to run. The default is 1.
- `--cpus-per-task`: This is the number of CPUs you want to use per task. By default it just takes all available CPUs on the node. But if you need at least some amount of CPUs, you can specify it here. It helps the scheduler to find a suitable node for your job.

It is important to start the application with the launcher `srun`. This starts the application with the parallel processes. You can check the number of CPUs per each process in a shell with `nproc --all`.

Example: `MultiProcess.slurm`
        
```bash
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
```

The tasks are not guaranteed to run on a single node, when it is not specified. Here is some possible output:

```bash
@login01:~ $ cat MultiProcess.out
Hello from paul01 with 256 CPUs
Hello from paul01 with 256 CPUs
...
```

## GPU Jobs

For GPU Applications, there are three types of NVIDIA GPUs available: Geforce **RTX2080 Ti**, **Tesla V100** and **Tesla A30**. A GPU can be specified with the `--gres` (Generic RESources) option or with the simple `--gpus` option (The SC Team does not provide any other generic resources than gpus). The format is `--gpus=<type>:<number>`. The type can be `v100`, `a30`, or `rtx2080ti`. The number is the number of GPUs you want to use. You can check the available GPUs with `sinfo`:

```bash
@login01:~ $ sinfo -o "%30N %4c: %8z %G"
NODELIST                       CPUS: S:C:T    GRES
paul[01-32],polaris[01-10]     64+ : 2+:8+:2  (null)
clara[02,04-08]                64  : 4:8:2    gpu:v100:4(S:0-3)
clara[09-30]                   64  : 4:8:2    gpu:rtx2080ti:8(S:0-3)
paula[01-12]                   128 : 8:16:1   gpu:a30:8(S:0-7)
```

Things to consider:

- You can only use one partition at a time. So you can't use `--partition=paul --partition=clara`.
- You can only use one type of GPU at a time. So you can't use `--gpus=v100:2 --gpus=rtx2080ti:2`.
- If you don't specify the type, the scheduler will choose the first available GPU type.
- If you ask for more GPUs than available on one node, the scheduler will choose multiple nodes.
- You can test the Slurm configuration with `salloc` to see if your configuration is valid.

simple Example: `singleGPU.slurm`

```bash
## Slurm resources
#SBATCH --partition=clara
#SBATCH --gpus=v100:1

## Job environment

## Job steps
srun echo $(hostname -f) with $(nvidia-smi -L)
```

output:

```bash
@login01:~ $ cat SingleGPU.out
clara04.sc.uni-leipzig.de with GPU 0: Tesla V100-PCIE-32GB (UUID: GPU-d1c9d705-f26a-de70-c36b-d3d227126973)
```

## multi GPU Jobs (advanced)

Here is an example for a multi GPU job: `MultiGPU.slurm`

```bash
## Slurm resources
#SBATCH --partition=paula
#SBATCH --gpus=10

## Job environment

## Job steps
srun echo $(hostname -f) with $(nvidia-smi -L)
```

with the output

```bash
@login01:~ $ cat MultiGPU.out
paula10.sc.uni-leipzig.de with GPU 0: NVIDIA A30 (UUID: GPU-c2b237fe-1988-29b8-a817-116dac94b918) GPU 1: NVIDIA A30 (UUID: GPU-11f99fb5-a685-3915-8a19-3c6913d13da5) GPU 2: NVIDIA A30 (UUID: GPU-0ae8f8ee-e8ae-e12d-98de-2c8d8530528c) GPU 3: NVIDIA A30 (UUID: GPU-e65b25a1-dbd8-ebf1-a287-8f2931886b30) GPU 4: NVIDIA A30 (UUID: GPU-78112747-905e-9b55-2601-2b6311537044) GPU 5: NVIDIA A30 (UUID: GPU-f4c47ad2-5944-af08-3b31-4c49564fade8) GPU 6: NVIDIA A30 (UUID: GPU-3dfa84db-f3ce-05e3-b45b-ec8eee587dbc) GPU 7: NVIDIA A30 (UUID: GPU-28ba2aa4-4bbb-d7f0-b0de-5354f4ec5ee7)
paula10.sc.uni-leipzig.de with GPU 0: NVIDIA A30 (UUID: GPU-c2b237fe-1988-29b8-a817-116dac94b918) GPU 1: NVIDIA A30 (UUID: GPU-11f99fb5-a685-3915-8a19-3c6913d13da5) GPU 2: NVIDIA A30 (UUID: GPU-0ae8f8ee-e8ae-e12d-98de-2c8d8530528c) GPU 3: NVIDIA A30 (UUID: GPU-e65b25a1-dbd8-ebf1-a287-8f2931886b30) GPU 4: NVIDIA A30 (UUID: GPU-78112747-905e-9b55-2601-2b6311537044) GPU 5: NVIDIA A30 (UUID: GPU-f4c47ad2-5944-af08-3b31-4c49564fade8) GPU 6: NVIDIA A30 (UUID: GPU-3dfa84db-f3ce-05e3-b45b-ec8eee587dbc) GPU 7: NVIDIA A30 (UUID: GPU-28ba2aa4-4bbb-d7f0-b0de-5354f4ec5ee7)
```

Which shows that the scheduler will choose multiple nodes if you ask for more GPUs than available on one node. Have this in mind when you want to use multiple GPUs. Consider the following parameters:

- `--gpu-bind`: By default every spawned task can access every GPU allocated to the step. As soon as there is more than one task the binding might be important:
  - `closest`: This binds each task to the GPU closest to the task's CPU.
  - `map_gpu`: With this option, a list of GPUs is created for each task. E.g. `--gpu-bind=map_gpu:0,0,1,1` will bind the first GPU to tasks 1 and 2 and the second GPU to tasks 3 and 4.
  - `none`: This is the default. It does not bind any GPU to any task.
  - `per_task:<gpus_per_task>`: This binds each task to a number of GPUs specified. E.g. `--gpu-bind=per-task:2` will bind two GPUs to each task. Assigning more GPUs than available will result in an error.
  - `single:<tasks_per_gpu>`: This binds each GPU to a number of tasks. E.g. `--gpu-bind=single:2` will bind two tasks to each GPU. Assigning more tasks than available will result in an error.
- `--gpus-per-task`: This is the number of GPUs you want to use per task. By default it just takes all available GPUs on the node. But if you need at least some amount of GPUs, you can specify it here. It helps the scheduler to find a suitable node for your job. It sets the `--gpu-bind` option to `per-task:1` but can be overridden.

## Exercises

1. Try out all examples and check the output.
2. Get an easy python script running in a Serial Array Job
3. Use a script from your research and give it a try on the SC CLuster