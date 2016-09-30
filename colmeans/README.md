```sh
$ OUTPUT="R-3.3.1-vanilla" ./colmeans-test.sh
$ ../../R-docker-images/run-all.sh /data/colmeans-test.sh
$ for i in ../../R-srcs/R-3.3.1-clang-*; do OUTPUT="$(basename $i)" RSCRIPT="$i/bin/Rscript" ./colmeans-test.sh; done
```
