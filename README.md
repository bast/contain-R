# contain-R

Apptainer/Singularity container for reproducible R environments.


## What you need for this to work

- [Apptainer](https://apptainer.org/) or [Singularity CE](https://docs.sylabs.io/guides/latest/user-guide/introduction.html)
- `install.R` or `renv.lock` file (examples below) that define the environment
- An R script/project/command that you want to run in that environment
- **No need to install R itself** (R 4.3.0 is provided by the container)


## Motivation and big picture

For reproducibility it is important to:
- document dependencies
- isolate dependencies from dependencies of other projects

This container:
- creates a per-project [renv](https://rstudio.github.io/renv/)-environment and
  isolates dependencies
- uses [pak](https://pak.r-lib.org/) under
  the hood to speed up installation
- allows to configure a user- or group-wide cache which can be reused across projects
- does not allow accidental "I will just quickly install it into my system and document it later" since it is a container


## Quick start on your computer

1. Create a new directory.
2. In the new directory create a file `install.R` which contains:
```r
renv::install('ggplot2')
```
3. Download the container:
```
# ...
```
4. Run the following in your terminal (this will take 1-2 minutes):
```
$ ./container.sif R --quiet -e 'library(ggplot2)'
```
5. Run the above again (now it will only take a second).
6. Run some R script which depends on that environment:
```
$ ./container.sif Rscript somescript.R
```


## Quick start on a cluster

Same as above but instead of step 4) use (adapt paths to your situation):
```
# ...
```


## install.R or renv.lock or both?

You need something to define the environment you want, either `install.R` or `renv.lock`.

An `install.R` file looks like this:
```r
renv::install('ggplot2')
renv::install('vcfR')
renv::install('hierfstat')
renv::install('poppr')
```

List as many packages as you need. You can pin them to specific versions, if
needed:
```r
renv::install("digest@0.6.18")
```

Alternatively, you can create your environment from `renv.lock` which looks
like this example and typically has been generated by [renv](https://rstudio.github.io/renv/):
```json
{
  "R": {
    "Version": "3.6.1",
    "Repositories": [
      {
        "Name": "CRAN",
        "URL": "https://cloud.r-project.org"
      }
    ]
  },
  "Packages": {
    "markdown": {
      "Package": "markdown",
      "Version": "1.0",
      "Source": "Repository",
      "Repository": "CRAN",
      "Hash": "4584a57f565dd7987d59dda3a02cfb41"
    },
    "mime": {
      "Package": "mime",
      "Version": "0.7",
      "Source": "Repository",
      "Repository": "CRAN",
      "Hash": "908d95ccbfd1dd274073ef07a7c93934"
    }
  }
}
```
For more information about lock files, please see
<https://rstudio.github.io/renv/reference/lockfiles.html>.

The container will process them in this order:
- If there is only `install.R`, it will use that one and create an `renv` environment and lock dependencies in `renv.lock`.
- If there is only `renv.lock`, it will use that one and create an `renv` environment.
- If `install.R` is more recent than `renv`, it will install from it (again).
- If `renv.lock` is more recent than `renv`, it will install from it (again).

In practice you will probably do either of these two:
- You arrive with `install.R` and it will create `renv.lock` and `renv`. You
  can then take the `renv.lock` and use it to share an environment with your
  friend. Maybe you modify `install.R` later and refresh `renv.lock` and `renv`.
- Or you arrive with `renv.lock` that you got from somebody and it will create
  `renv`.


## Generated paths

Running the container creates the following files and directories in the same
place where you run the container (but you can configure some of them if you
want them somewhere else):
- `renv` - holding the environment
- `renv.lock` - created or updated if you installed from `install.R`
- creates or modifies `.Rprofile` - [renv](https://rstudio.github.io/renv/) adds the line `source("renv/activate.R")`
- `renv-cache` - [renv](https://rstudio.github.io/renv/) package cache; you can change its location by defining environment variable `RENV_CACHE`
- `pak-cache` - [pak](https://pak.r-lib.org/) package cache; you can change its location by defining environment variable `RENV_CACHE`


## Installation takes too long?

Running a script for the first time may take time since it needs to set up the
environment and download and install dependencies.

However, re-running the script will take no installation time and if
dependencies are already in the cache, it will take no time either.


## Pak and renv use different caches and methods

For historical reasons they are slightly different but their
developers are working on smoothing things out between the two.
You will notice the difference if you start from `install.R`,
and then try to restore back from the generated `renv.lock`: you will
notice that the two will use different methods.

Relevant GitHub issues:
- https://github.com/rstudio/renv/issues/907
- https://github.com/r-lib/pak/issues/343

You have the option to turn off [pak](https://pak.r-lib.org/) like this:
```bash
export USE_PAK=false
```

Pros and cons of turning it off:
- Advantage: Only one cache location and everything is nicely consistent. You
  could install from `install.R`, then remove it even and run from `renv.lock`
  and it would be all consistent and not need to re-install anything.
- Disadvantage: First installation from `install.R` might take longer when
  without [pak](https://pak.r-lib.org/).


## How to configure location for package caches

You can change the location of the package caches:
```bash
export RENV_CACHE=/home/user/R/renv-cache
export PAK_CACHE=/home/user/R/pak-cache
```


## Recommendations on where to place package caches

**On your own computer** it will make sense to reuse the same cache(s) across
all projects.  This way, when installing dependencies, renv will first look
whether you already have the package on your computer.

**On a shared cluster** it might make sense to have one common cache for your
group/allocation since your research group might use similar dependencies in
their work.  This way you can save space and install time.


## Known problems/ ideas for later

- Maybe you need a different version of R than 4.3.0. I guess we should at some
  point have several containers for different versions? Or you build your own
  from the definition file.
- It could be good to let the user configure where `renv` itself should be
  located. Currently it is placed in the same folder where the container is run.


## Resources

I have used these resources when writing/testing:
- https://rstudio.github.io/renv/
- https://rstudio.github.io/renv/articles/docker.html
- https://pak.r-lib.org/
- https://rstudio.github.io/packrat/ (deprecated)
- https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/r-packages-with-renv
- https://raps-with-r.dev/repro_intro.html
- https://www.youtube.com/watch?v=N7z1K4FhVFE (stream recording on how to use renv)
