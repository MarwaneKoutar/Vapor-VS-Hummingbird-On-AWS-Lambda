#!/bin/bash

set -eu

# ensure the executable is passed
executable=$1

# root, target, and output directories
root=/tmp/$executable
target=project/VaporLambda/.build/lambda/$executable
output=.aws-sam/build/VaporApp

# build the executable
cd project/VaporLambda
swift build --product $executable -c release
cd "$root"

# copy the executable and its dependencies
rm -rf "$target"
mkdir -p "$target"
cp "project/VaporLambda/.build/release/$executable" "$target/"

# add the target deps based on ldd
ldd "project/VaporLambda/.build/release/$executable" | grep swift | awk '{print $3}' | xargs cp -Lv -t "$target"

# move the whole folder (it's contents) to the output directory
cd "$root"
mv "$target"/* "$output"

# make symbolic link to the executable in the output directory
cd "$output"
ln -s "$executable" "bootstrap"
