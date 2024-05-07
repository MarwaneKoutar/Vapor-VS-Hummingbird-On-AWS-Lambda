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

# zip the executable and its dependencies
cd "$target"
ln -s "$executable" "bootstrap"
zip --symlinks VaporApp.zip *

# move the zip to the output directory
cd "$root"
ls -la
mv "$target/VaporApp.zip" "$output"