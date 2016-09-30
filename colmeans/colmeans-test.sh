#!/bin/bash -x
set -e

N=${1:-10}
RSCRIPT=${RSCRIPT:-"Rscript"}
DATADIR=${DATADIR:-"$(dirname $0)"}
OUTPUT=${OUTPUT:-"$(hostname).out"}

"$RSCRIPT" -e 'install.packages("rbenchmark", repos="http://cran.us.r-project.org")'

test -d "$DATADIR/results" || mkdir "$DATADIR/results"

for i in $(seq 1 $N); do
  "$RSCRIPT" "$DATADIR"/colmeans-test.R | tee -a "$DATADIR/results/$OUTPUT"
done
