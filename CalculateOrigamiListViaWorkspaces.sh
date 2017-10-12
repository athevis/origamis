#!/bin/bash
D=$1
PARTITIONS=$2
I=1
NUM_JOBS=4

nohup gap -q init-origami-list.g <<- EOF >> origami.log 2>&1 
CreateOrigamiWorkspace(${D});
EOF

for (( ; I <= NUM_JOBS ; I++ )) ; do
    nohup gap -q -L ConjugacyClasses${D}.gapws init-origami-list.g <<- EOF >> origami.log 2>&1 &
    CalcOrigamiListViaWorkspaces(${I},${D});;
    Print(${I});
EOF
done

echo "started ${NUM_JOBS} jobs"


for (( ; I <= PARTITIONS ; I++ )) ; do
    wait -n
    nohup gap -q -L ConjugacyClasses${D}.gapws init-origami-list.g <<- EOF >> origami.log 2>&1 &
    CalcOrigamiListViaWorkspaces(${I},${D});;
    Print(${I});
EOF
    echo "started job for I= ${I}"
done

wait
