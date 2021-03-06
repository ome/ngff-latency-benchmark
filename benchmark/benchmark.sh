#!/usr/bin/env bash

DIR=${DIR:-./data}
export BENCHMARK_DATA=${DIR}

set -e
set -u
set -x

cd /benchmark  # TODO: should work without docker

for (( i=0; i<$TEST_REPEATS; i++ ))
do
    pytest benchmark.py "$@" --csv=${BENCHMARK_DATA}/${i}_benchmark_data.csv \
        --csv-columns status,duration,properties_as_columns,markers_args_as_columns
    head ${BENCHMARK_DATA}/${i}_benchmark_data.csv
    python plot_results.py ${BENCHMARK_DATA}/${i}_benchmark_data.csv ${BENCHMARK_DATA}/${i}_benchmark_plot.png
done
