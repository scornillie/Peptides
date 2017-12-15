#!/bin/bash

BLOCK=GGG

for SERIE in "ga" "gb" "gc" "gd" "ge" "gf" "gg" "gh" "gi" "gj" "gk";
do
  mkdir $SERIE
  cd $SERIE
  for sim in {1..100};
  do
    simid[$sim]=`mktemp -d $SERIE.XXXXXXXXX`
    export SIMID=${simid[$sim]}

    cd ${simid[$sim]}

    cp -r /scratch/sciteam/sean/EBOLA_2017/block-$BLOCK/$SERIE/$sim/2build ./
    cp -r /scratch/sciteam/sean/EBOLA_2017/block-$BLOCK/$SERIE/$sim/5ANALYZE ./

    cd ../
    done
cd ../
done
