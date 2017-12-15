#!/bin/bash
set -x

for exp in g;
do

#for sim in {a..z};
for sim in {a..k};
do
    DIRECTORY=$exp$sim
    echo $DIRECTORY
    rm -rf $DIRECTORY
    mkdir $DIRECTORY
    cd $DIRECTORY
    sed -e 's/ZZZZ/'$DIRECTORY'/g' ../submit-GPU.sh > run.sh
    qsub run.sh
    sleep 2

    cd ../

done

done
