#!/bin/sh

for file in `ls roles`;do
  bin/knife role from file roles/$file
done