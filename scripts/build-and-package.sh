#!/bin/bash

set -eu

# execute the makefile
cd scripts && make build-VaporApp && make build-HummingbirdApp
