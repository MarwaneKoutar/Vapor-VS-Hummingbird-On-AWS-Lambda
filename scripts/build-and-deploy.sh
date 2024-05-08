#!/bin/bash

set -eu

# build and package the executables
scripts/build-and-package.sh

# deploy to AWS
scripts/deploy.sh