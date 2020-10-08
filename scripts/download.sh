#!/bin/bash

# this script is meant to be used with 'datalad run'

for file_url in "http://cs231n.stanford.edu/tiny-imagenet-200.zip tiny-imagenet-200.zip"
do
        echo ${file_url} | git-annex addurl -c annex.largefiles=anything --raw --batch --with-files
done

md5sum tiny-imagenet-200.zip > md5sums
