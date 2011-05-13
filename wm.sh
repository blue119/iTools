#!/bin/sh

SOURCE_DIR="/home/blue119/projects/source"
MAINLINE_DIR="ml"
RELEASE_DIR="release"
WORK_DIR="work"
PRJ="toronto"

l_string="${RELEASE_DIR}:${PRJ}"
r_string="${WORK_DIR}:${PRJ}"
l_file=$(echo "${SOURCE_DIR}/${RELEASE_DIR}/${PRJ}" | sed -e 's/\//\\/g')
r_file=$(echo "${SOURCE_DIR}/${WORK_DIR}/${PRJ}" | sed -e 's/\//\\/g')
# filter_file=$(echo "/home/blue119/.wine/dosdevices/c:/Program Files/WinMerge/Filters/Merge_GnuC_loose.flt" | sed -e 's/\//\\/g')
filter_file=Merge_GnuC_loose.flt
wine ~/.wine/dosdevices/c\:/Program\ Files/WinMerge/WinMergeU.exe -r -e -ub -f "${filter_file}" -dl "${l_string}" -dr "${r_string}" ${l_file} ${r_file}

