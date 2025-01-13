# Example projects

write slurm scripts that submit the following files. One slurm script per file.

- `python_numpy.py`: Run and retrieve the result
- `python_torch.py`: Run and retrieve the result on CPU and then on GPU.

## Tips

- To run on GPUs, you need access to a partition with GPUs on the cluster (e.g.
  `paula`).
- you can create a `conda` environment interactively on the login nodes (load
  `conda` with `module`) and then. Then you can call the python executable from
  that project directly.
  - Checkout `01-basics/PyVer.py` on how to get the path to the `python`
    interpreter.
  - Alternatively: activate the environment and run `which python` from `bash`.
- Test the code on the login nodes. 
  - In case of a long running script, test the code with less data or less
    iterations.
