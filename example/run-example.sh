#!/usr/bin/env bash

# safe bash settings
set -o errexit -o pipefail -o nounset

# export RENV_CACHE=/home/user/R/renv-cache
# export PAK_CACHE=/home/user/R/pak-cache
# export USE_PAK=false

./container.sif R --quiet -e 'library(ggplot2)'
