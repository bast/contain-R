#!/usr/bin/env bash

# safe bash settings
set -o errexit -o pipefail -o nounset

# here we could change where to place cache directories
# export RENV_CACHE=/home/user/R/renv-cache
# export PAK_CACHE=/home/user/R/pak-cache

./container.sif R --quiet -e 'library(ggplot2)'
