#!/usr/bin/env bash

set -e

TEST=( maintenance/benchmarks/benchmarkParse.php --wiki=enwiki NOFX )
# FIXME: bug 66942
EXTRA=( --config-value Eval.Jit=false )

repeat () {
    echo "# $*"
    for i in {1..10}; do
        $*
    done
}

echo Testing mwscript...
repeat mwscript "${TEST[@]}"

echo Testing hhvm, RepoAuthoritative off...
repeat ./hhscript "${TEST[@]}"

echo Testing hhvm, RepoAuthoritative on with one MW version precompiled...
repeat ./hhscript --config 1.24wmf10/config.hdf "${EXTRA[@]}" "${TEST[@]}"

echo Testing hhvm, RepoAuthoritative on with two MW versions precompiled...
repeat ./hhscript --config inuse/config.hdf "${EXTRA[@]}" "${TEST[@]}"
