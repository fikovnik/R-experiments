#!/bin/bash -x
set -e

URL="https://cloud.r-project.org/src/base/R-3/R-3.3.1.tar.gz"
VERSION="3.3.1"
FORCE=${FORCE:-''}

test -f "R-$VERSION.tar.gz" || wget "$URL"

function do_exec() {
  cmd=$@

  time {
    echo "$cmd"
    $cmd >> "../build.out" 2>&1
  }
}

function run() {
  BASE_DIR="RUN-$1"
  R_DIR="$BASE_DIR/R-3.3.1"
  export CC="$2"
  export CFLAGS="$3"

  test -d "$R_DIR" || {
    mkdir "$BASE_DIR"
    tar xzf "R-$VERSION.tar.gz" -C "$BASE_DIR"
  }
  cd "$R_DIR"

  if [ "$FORCE" ]; then
      rm -f ../run.out
      rm -f ../build.out
      test -f "Makefile" && do_exec make clean
      do_exec ./configure --without-recommended-packages --disable-java --without-aqua --with-x --without-tcltk
      do_exec make
  else
    test -f "Makefile" || do_exec do_exec ./configure --without-recommended-packages --disable-java --without-aqua --with-x --without-tcltk
    test -f "bin/exec/R" || do_exec make
  fi

  rm -f ../run.out
  for i in {1..10}; do
    ./bin/Rscript ../../colmeans-test.R | tee -a "../run.out"
  done

  cd ../..
}

run "clang_debug" "clang" "-Wall -O0 -g3 -gdwarf-4 -DDEBUG"
run "clang_standard" "clang" "-g -O2"
run "clang_O2" "clang" "-O2"
run "clang_O3" "clang" "-O3"
run "clang_Ofast" "clang" "-Ofast"

run "gcc6_debug" "/usr/local/bin/gcc-6" "-Wall -O0 -g3 -gdwarf-4 -DDEBUG"
run "gcc6_standard" "/usr/local/bin/gcc-6" "-g -O2"
run "gcc6_O2" "/usr/local/bin/gcc-6" "-O2"
run "gcc6_O3" "/usr/local/bin/gcc-6" "-O3"
run "gcc6_Ofast" "/usr/local/bin/gcc-6" "-Ofast"
