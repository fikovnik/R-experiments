#!/bin/bash
set -e

N=${1:-10}
DATA_DIR=$(dirname $0)

Rscript -e 'install.packages("rbenchmark", repos="http://cran.us.r-project.org")'

test -d "$DATA_DIR/results" || mkdir "$DATA_DIR/results"

for i in $(seq 1 $N); do
  Rscript "$DATA_DIR"/colmeans-test.R | tee -a "$DATA_DIR/results/$(hostname).out"
done
