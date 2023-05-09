#!/usr/bin/env bash

# safe bash settings
set -o errexit -o pipefail -o nounset

sudo singularity build container.sif ../container.def
