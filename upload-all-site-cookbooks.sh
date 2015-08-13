#!/bin/sh

echo "Uploading all site-cookbooks to $1 environment..."

for file in `ls site-cookbooks`;do
  bin/knife cookbook upload $file --include-dependencies -E $1
done
