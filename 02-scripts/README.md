# Slurm Batch Jobs - The heart of the slurm system

## General information

Slurm is a queueing system. ...

## First Slurm job - Hello Slurm

Jobs in Slurm are usually submitted through small shell scripts. Consider the following file `HelloSlurm.sh`:

```bash
#!/bin/bash

## Slurm general options
#SBATCH --job-name=ExampleRun
#SBATCH --output=ExampleRun.out
#SBATCH --error=ExampleRun.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<email>

## Slurm resources
#SBATCH --time=0-00:01:00

## Job environment

## Job steps
echo "Hello from" $(hostname -f)
```

The information helps the scheduler to enqueue your job and to allocate the resources. The first line `#!/bin/bash` is called a shebang. It tells the system which interpreter to use to run the script. The next lines are the Slurm options. They are prefixed with `#SBATCH`. The options are:

- `--job-name`: This is the name of your job. It will be displayed in the queue and in the accounting.
- `--output`: This is the name of the file where the standard output of your job will be written to.
- `--error`: This is the name of the file where the standard error of your job will be written to.
- `--mail-type`: This is the type of mail notifications you want to receive. You can choose between `NONE`, `BEGIN`, `END`, `FAIL`, `ALL`, or a comma separated list of these values. There is also a shorthand notation: `--mail-type=ALL` is the same as `--mail-type=BEGIN,END,FAIL`. Time Warning notifications are done separately with `TIME_LIMIT_50`, `TIME_LIMIT_80` ,`TIME_LIMIT_90`.
- `--mail-user`: This is the email address where you want to receive the notifications.
- `--time`: This is the maximum runtime of your job. The format is `days-hours:minutes:seconds`

For the `--output` and `--error` options, you can use the following placeholders:

- `%j`: This is the job ID.
- `%x`: This is the job name.
- `%u`: This is the user name.

The next section is the job environment. Here you can load modules, set environment variables, etc. The last section is the job steps. Here you can run your commands. In this example, we just print the hostname of the compute node.

### Job enqueueing

To submit the job, you can use the `sbatch` command:

```bash
@login01:~ $ sbatch HelloSlurm.sh
Submitted batch job 2833452
```

This will submit the job to the scheduler. The scheduler will then enqueue the job and allocate the resources. You can check the status of your job with `squeue`:

```bash
@login01:~ $ squeue -u <LoginUser>
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
           2833452      paul ExampleR <LoginUser> PD       0:00      1 (Priority)
```

The job is in the `PD` state, which means pending. Once the job is running, the state will change to `R` for running.

You can also check the status of your job with `sacct`:

```bash
@login01:~ $ sacct -j 2833452
JobID           JobName  Partition    Account  AllocCPUS      State ExitCode
------------ ---------- ---------- ---------- ---------- ---------- --------
2833452      ExampleRun       paul     fakpug          1    PENDING      0:0
```

which will look like this after completion:

```bash
@login01:~ $ sacct -j 2833452
JobID           JobName  Partition    Account  AllocCPUS      State ExitCode
------------ ---------- ---------- ---------- ---------- ---------- --------
2833452      ExampleRun       paul     fakpug          1  COMPLETED      0:0
2833452.bat+      batch                fakpug          1  COMPLETED      0:0
```

The Account column shows the specific project of you. The term "fakpug" means "Fakultät für Physik und Geowissenschaften". This depends completely on your account and can be different for you (there exist others like "scads" or "idiv" as well).

#### pro tip

You can log the information about your jobs easily in a tmux window with the following command:

```bash
watch -n0.5 sacct -u <LoginUser> -S now-20minutes -X
```

This works excellent in combination with `tmux``

#### pro tip

It is not necessary to name the jobscript with the `.sh` extension. You can also use `.sbatch`, `.slurm` or any other extension. The only important thing is the shebang `#!/bin/bash` at the beginning of the file.

#### pro tip

There is a `--test-only` option for `sbatch`. This will not submit the job to the scheduler, but it will check the syntax of the job script and print the information about the job.

```bash
@login01:~ $ sbatch --test-only Test.slurm
sbatch: Job 2933250 to start at 2023-06-21T10:00:55 using 1 processors on nodes paula02 in partition paula
@login01:~ $

```

### Important commands

- `sbatch`: This command is used to submit a batch job to the Slurm scheduler
- `squeue`: This command shows the status of all jobs in the queue, including the job ID, user, status, and node allocation.
- `srun`: This command is used to launch a job on the compute nodes and execute commands on them.
- `scancel`: This command is used to cancel a running or pending job.
- `sinfo`: This command provides information about the compute nodes, such as their state, availability, and partition membership.
- `sacct`: This command is used to view job accounting information, such as job start and end times, resource usage, and exit status.
- `scontrol`: This command is used to modify the job and node configuration, such as setting up a reservation, configuring job priority, and modifying the job environment.
- `sshare`: These command is used to view the fair-share information

The next sections will go into detail about the ressource allocations and the different job types.

## Exercise

1. Run the `HelloSlurm.sh` script on the cluster.
2. Change the file `HelloSlurm.slurm` and check the status while running it.
3.  