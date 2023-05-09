# contain-R

Apptainer/Singularity container for reproducible R environments.


## What you need for this to work

- [Apptainer](https://apptainer.org/) or [Singularity CE](https://docs.sylabs.io/guides/latest/user-guide/introduction.html)
- `install.R` or `renv.lock` file (examples below) that define the environment
- An R script/project/command that you want to run in that environment
- You **do not need to install R itself** (R 4.3.0 is provided by the container)


## Motivation and big picture

...


## Quick start

...


## How to configure location for package caches

...


## Recommendations on where to place package caches

...


## How to run this on a cluster

...


## Pak and renv use different caches and methods

...


## Known problems

...


## Resources

I have used these resources when writing/testing:
- https://rstudio.github.io/renv/
- https://pak.r-lib.org/
- https://rstudio.github.io/packrat/ (deprecated)
- https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/r-packages-with-renv
- https://raps-with-r.dev/repro_intro.html
- https://www.youtube.com/watch?v=N7z1K4FhVFE
