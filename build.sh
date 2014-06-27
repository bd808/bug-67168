#!/usr/bin/env bash

COMPILER=/home/bd808/projects/hhvm/bug-67168/scap-hhvm-compile
OUTPUT=$(pwd)

for b in $(mwversionsinuse); do
    rm -rf $OUTPUT/$b
    $COMPILER --branch $b --output $OUTPUT/$b
done
rm -rf $OUTPUT/inuse
$COMPILER --output $OUTPUT/inuse
