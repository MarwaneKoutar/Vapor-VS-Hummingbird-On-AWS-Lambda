#!/bin/bash

set -eu

# deploy to AWS
sam deploy --template scripts/template.yml --stack-name vapor-vs-hummingbird --resolve-s3