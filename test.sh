#!/usr/bin/env bash

set -e

WIKI=enwiki
VERSION=1.24wmf10
PAGE=NOFX

TEST=( maintenance/benchmarks/benchmarkParse.php --wiki=$WIKI $PAGE )
NOJIT=( --config-value Eval.Jit=false )
JIT=( --config-value Eval.Jit=true )

repeat () {
    echo "# $*"
    for i in {1..15}; do
        $*
    done
}

echo Test started at $(date +%Y-%m-%dT%H:%M)
hhvm --version
echo

#echo Testing mwscript...
#repeat mwscript "${TEST[@]}"

echo Testing hhvm, RepoAuthoritative off, No JIT ...
echo =====================================================================
repeat ./hhscript --config stock/config.hdf "${NOJIT[@]}" "${TEST[@]}"
echo

echo Testing hhvm, RepoAuthoritative off, JIT ...
echo =====================================================================
repeat ./hhscript --config stock/config.hdf "${JIT[@]}" "${TEST[@]}"
echo

echo Testing hhvm, RepoAuthoritative on, No JIT, one MW version ...
echo =====================================================================
repeat ./hhscript --config $VERSION/config.hdf "${NOJIT[@]}" "${TEST[@]}"
echo

echo Testing hhvm, RepoAuthoritative on, JIT, one MW version ...
echo =====================================================================
repeat ./hhscript --config $VERSION/config.hdf "${JIT[@]}" "${TEST[@]}"
echo

echo Testing hhvm, RepoAuthoritative on, No JIT, two MW versions ...
echo =====================================================================
repeat ./hhscript --config inuse/config.hdf "${NOJIT[@]}" "${TEST[@]}"
echo

echo Testing hhvm, RepoAuthoritative on, JIT, two MW versions ...
echo =====================================================================
repeat ./hhscript --config inuse/config.hdf "${JIT[@]}" "${TEST[@]}"
echo

echo Test finished at $(date +%Y-%m-%dT%H:%M)
