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

if [[ ! -e "bin/ffmpeg" ]]
then
	(exit 1)
	exit_on_error_code "ffmpeg is not present in $PWD/bin/"
fi

# Add favored ffmpeg and jug_exec to PATH
export PATH="$(cd bin/; pwd):${PATH}"

# Create container header and concat transcoded images into tiny-imagenet-200.mp4
# Note: For jug to chain the actions, extract and transcode must use the
# same arguments as in extract_transcode.sh
(source tmp_processing/venv/bzna/bin/activate && \
 cd tmp_processing/ && \
 jug_exec.py python -m pybenzinaconcat.create_container tiny-imagenet-200.mp4 && \
 python -m pybenzinaconcat \
 	extract tiny-imagenet-200.zip extract/ tinyimagenet:zip --batch-size 512 \
 	--transcode ./ --mp4 --tmp tmp/ \
	--concat tiny-imagenet-200.mp4 \
 	>>logs/extract_transcode_concat.out 2>>logs/extract_transcode_concat.err)
exit_on_error_code "Failed to concat into tiny-imagenet-200.mp4"

md5sum tmp_processing/tiny-imagenet-200.mp4 >> md5sums
