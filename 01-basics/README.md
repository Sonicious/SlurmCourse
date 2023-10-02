# Basic Slurm

## General information

Hardware in the slurm context:

- A **job** is a unit of work that is submitted to the cluster for execution. It can be a docker image, scripts or all other non-interactive programs. 
- **Resource allocation:** SLURM allocates resources based on a set of policies, such as fair-share scheduling or priority-based scheduling. Users can set various options to influence the allocation of resources, such as the number of CPUs, the amount of memory, and the duration of the job.
- A **partition** is a subset of the computing resources on a cluster, such as a specific group of nodes or a particular type of hardware. Users can request access to specific partitions when submitting a job.
- A (*compute*) **node** is a computer part of a larger set of nodes (a cluster). Besides compute nodes, a cluster comprises one or more *login* nodes, *file server* nodes, *management* nodes, etc. A compute node offers resources such as processors, volatile memory (RAM), permanent disk space (e.g. SSD), accelerators (e.g. GPU) etc.
- a **CPU** in a general context refers to a processor, but in the Slurm context, a CPU is a consumable resource offered by a node. It can refer to a socket, a core, or a hardware thread, based on the Slurm configuration.
- A **core** is the part of a processor that does the computations. A processor comprises multiple cores, as well as a memory controller, a bus controller, and possibly many other components. A processor in the Slurm context is referred to as a **socket**, which actually is the name of the slot on the motherboard that hosts the processor. A single core can have one or two **hardware threads**. This is a technology that allows virtually doubling the number of cores the operating systems perceives while only doubling part of the core components -- typically the components related to memory and I/O and not the computation components. Hardware multi-threading is very often disabled in HPC.

Partitions which are offered by the SC Team:

| name         | max time limit | max resources    | usage pattern               |
| :----------- | :------------- | :--------------- | :-------------------------- |
| sirius       | 2 days         | 1 node           | big memory applications     |
| sirius-long  | 10 days        | 1 node           | big memory applications     |
| polaris      | 2 days         | 10 nodes         | general computation         |
| polaris-long | 42 days        | 4 nodes          | long runtime                |
| clara        | 2 days         | 29 nodes w/ GPUs | general and GPU computation |
| clara-prio   | 10 days        | 29 nodes w/ GPUs | high priority GPU jobs      |
| clara-long   | 10 days        | 6 nodes w/ GPUs  | long running GPU jobs       |
| paula        | 2 days         | 12 nodes w/ GPUs | general and GPU computation |
| paul         | 2 days         | 32 nodes         | general computation         |

The partitions and their nodes which are available to you can be checked with `sinfo -n -L`.

### About text editors

You can use Visual Studio Code with the Remote plugin to work directly on the cluster. `nano` is not available. You can use `vim`, if you are familiar with it.

## Interactive Slurm console

Interactive jobs are useful for testing and debugging. They allow you to run commands on the compute nodes interactively, as if you were logged in to the node. This is useful for testing and debugging your code, as well as for running interactive applications. 

You prepare an interactive job with `salloc`. This reservers some computational resources for you. Then you can use `srun` to run commands on the compute nodes (without this the command runs on the login node). When you are done, you can free the resources with `exit` or `logout` again. The following example shows how to run a command on a compute node of `clara`:

```bash
mn087nhya@login01:~ $ salloc -p clara
salloc: Pending job allocation 2832168
salloc: job 2832168 queued and waiting for resources
salloc: job 2832168 has been allocated resources
salloc: Granted job allocation 2832168
mn087nhya@login01:~ $ hostname
login01.sc.uni-leipzig.de
mn087nhya@login01:~ $ srun hostname
clara05.sc.uni-leipzig.de
mn087nhya@login01:~ $ exit
salloc: Relinquishing job allocation 2832168
mn087nhya@login01:~ $
```

You can also use `srun` without ressource allocation. then every time you have to wait for a free node. This is not recommended.

## Exercise Tasks

1. Login to any of the login nodes.
1. load the `git` module and clone the git repository: `git clone https://github.com/sonicious/SlurmCourse`
1. Find out which partitions are available to you with `sinfo -n -L`
1. Run the script `PyVer.py` from the repository on a compute node with loaded Python module. Use `salloc` and `srun` for this.
1. Don't forget to free the resources with `exit` or `logout` again.