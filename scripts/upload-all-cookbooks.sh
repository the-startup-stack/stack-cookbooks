#!/bin/sh

for file in `ls cookbooks`;do
  bin/knife cookbook upload $file --include-dependencies
done