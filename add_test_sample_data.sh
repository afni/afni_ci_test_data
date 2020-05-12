#!/usr/bin/env bash
export userid=$(id -u)
export PYTEST_ARGS="scripts --create_sample_output $@"

docker run \
    -e "ARGS=$PYTEST_ARGS" \
    -e "userid=$userid" \
    --rm \
    -ti \
    -v $PWD/../..:/opt/src/afni \
    afni/afni_cmake_build \
    bash -c 'ninja pytest && chown -R $userid:$userid afni_tests/sample_output_of_tests'

# an example sync command... need to think about best way to tidy this up
# output=$(find ../sample_output_of_tests/ -maxdepth 1|sort -n|tail -n 1)
# for d in $(ls -d $output/*/*)
# do     
#     rsync -a $d sample_test_output/RetroTS
# done
