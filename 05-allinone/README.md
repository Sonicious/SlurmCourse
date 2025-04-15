Slurm requires submitting a file using

`submit_job.sh`:
```bash
sbatch file.sh
```

where the contents of the file.sh contain the actual script

`run.sh`:
``` bash
#! /bin/bash

#SBATCH --nodes=1


srun ./run.py --par1 p1v1 --par2 p2v1
```

which in return requires a python file

`run.py`
``` python
import argparse

parser = argparse.ArgumentParser(description = "Run the experiment")

parser.add_arguments("--par1", required=True, help="this is the first parameter")
parser.add_arguments("--par2", required=True, help="this is the second parameter")

args = parser.parse_args()

print(args)
```

If you want to run your experiment with different parameters, this requires a
separate `run.sh` for each parameter configuration.

To avoid this, `bash` provides a feature called `here document`, e.g. `cat file.txt`

```bash
cat <<EOF
hello world
EOF
```

`EOF` can be any string and everything in between is treated as if it was a
separtate file. This mean we can `heredocs` with `sbatch`


``` bash

sbatch <<EOF
#! /bin/bash

#SBATCH --nodes=1

srun run.py --par1 p1v2 --par2 p2v1

EOF

```










