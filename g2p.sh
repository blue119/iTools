#!/bin/sh

ROOT=$(pwd | awk -F/work/ '{ print $1 }')
BAK_DIR="/tmp/$$"
P4_WORK_SPACE="${ROOT}/release"
WORK_SPACE="${ROOT}/work"

PRJ_NAME=$(pwd | awk -Fwork/ '{ print $(NF) }')
P4_PRJ_PATH="${P4_WORK_SPACE}/${PRJ_NAME}"
WORK_PRJ_PATH="${WORK_SPACE}/${PRJ_NAME}"

GIT_DIFF=$(git diff --numstat HEAD^ | awk '{ print $(NF) }')

if [ "${P4CONFIG}_" = "_" ]; then
  echo "you have to set your config before to build"
  exit
fi

# echo ${ROOT}
# echo ${P4_WORK_SPACE}
# echo ${WORK_SPACE}

# echo ${PRJ_NAME}
# echo ${P4_PRJ_PATH}
# echo ${WORK_PRJ_PATH}

if [ "${GIT_DIFF}_" != "_" ]; then
  $(mkdir ${BAK_DIR})
  echo "backup to ${BAK_DIR}"

  for file in ${GIT_DIFF}
  do
    $(p4 open ${P4_PRJ_PATH}/${file})
    $(cp ${WORK_PRJ_PATH}/${file} ${BAK_DIR})
    # echo "cp ${WORK_PRJ_PATH}/${file} ${P4_PRJ_PATH}/${file}"
    l_string="P4:${file}"
    r_string="GIT:${file}"
    l_file=$(echo "${P4_PRJ_PATH}/${file}" | sed -e 's/\//\\/g')
    r_file=$(echo "${WORK_PRJ_PATH}/${file}" | sed -e 's/\//\\/g')
    wine ~/.wine/dosdevices/c\:/Program\ Files/WinMerge/WinMergeU.exe -r -e -ub -dl "${l_string}" -dr "${r_string}" ${l_file} ${r_file}
  done
    # l_file=$(echo "${P4_PRJ_PATH}/controller/ac/usr" | sed -e 's/\//\\/g')
    # r_file=$(echo "${WORK_PRJ_PATH}/controller/ac/usr" | sed -e 's/\//\\/g')
    # wine ~/.wine/dosdevices/c\:/Program\ Files/WinMerge/WinMergeU.exe -r -e -ub -dl "P4" -dr "GIT" ${l_file} ${r_file}
fi

