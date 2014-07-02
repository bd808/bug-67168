#!/usr/bin/env bash

# Use perf to trace HHVM using 2 branch authoritative repo and JIT to parse
# [[en:NOFX]]
sudo -u apache -- \
    perf record -v -b --call-graph dwarf -- \
        hhvm --config inuse/config.hdf \
        --config-value Eval.Jit=true \
        --file /usr/local/apache/common-local/multiversion/MWScript.php -- \
            maintenance/benchmarks/benchmarkParse.php --wiki=enwiki NOFX

# Convert the perf stack samples into single lines
sudo -u apache perf script |
./stackcollapse-perf.pl > out.perf-folded

# Generate a flame graph
# Flame graph -- http://www.brendangregg.com/perf.html#FlameGraphs
./flamegraph.pl > hhvm.svg
