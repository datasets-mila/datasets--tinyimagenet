#!/bin/bash

# this script is meant to be used with 'datalad run'
# and executed after extract_transcode.sh

function exit_on_error_code {
	err=$?
	if [ $err -ne 0 ]
	then
		>&2 echo "$(tput setaf 1)error$(tput sgr0): $1: $err"
		exit $err
	fi
}

mkdir -p tmp_processing/logs/

(source tmp_processing/venv/bzna/bin/activate && \
 cd tmp_processing/ && \
 python -m pybenzinaconcat.index_metadata tiny-imagenet-200.mp4 \
 	>>logs/index_metadata.out 2>>logs/index_metadata.err && \
 mv tiny-imagenet-200.mp4 ../)
exit_on_error_code "Failed to index metadata of tiny-imagenet-200.mp4"

md5sum tiny-imagenet-200.mp4 >> md5sums
