#!/bin/bash
set -x

for exp in a;
do

#for sim in {a..z};
for sim in a;
do
    DIRECTORY=$exp$sim
    echo $DIRECTORY
    rm -rf $DIRECTORY
    mkdir $DIRECTORY
    cd $DIRECTORY
    sed -e 's/ZZZZ/'$DIRECTORY'/g' ../submit-CPU.sh > run.sh
    qsub run.sh
    sleep 2

    cd ../

done

done
