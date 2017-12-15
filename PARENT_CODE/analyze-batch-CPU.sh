#!/bin/bash
set -x

for exp in g;
do

for sim in {a..k};
do
    DIRECTORY=$exp$sim
    echo $DIRECTORY
    cd $DIRECTORY
    sed -e 's/ZZZZ/'$DIRECTORY'/g' ../analyze-submit-CPU.sh > analyze.sh
    qsub analyze.sh
    sleep 2

    cd ../

done

done
