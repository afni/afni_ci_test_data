#!/bin/tcsh
# use this command to create tgz for distribution
# update sorted_atlas_lastest_list.txt as needed
# tar tzvf ../atlases_latest_2019_02.tgz | awk '{print $6}' | sort -u > sorted_atlas_latest_list.txt
tar czvf ../atlases_latest.tgz `cat sorted_atlas_latest_list.txt`
