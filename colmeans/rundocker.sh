#!/bin/bash -x
set -e

BASE_DIR="$(dirname $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}"))"
pushd . > /dev/null
cd "$BASE_DIR"

ALL=$(docker images --format '{{.Repository}}' | grep "r-.*")

test -d results && rm -fr results

for d in $ALL; do
  echo "Running $d"
  docker run --rm -v $(pwd):/data -h $d -ti $d /data/colmeans-test.sh
done

popd
