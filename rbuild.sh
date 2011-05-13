#!/bin/sh

export TFTPBOOT="/var/tftpboot"

CLIENT_ROOT=$(p4 info | grep 'Client root' | awk -F': ' '{ print $2 }')
BUILD_ROOT=$(echo ${PWD} | awk -F/ '{ print $(NF-1) }')
TIME=$(date +%FT%H-%M-%S)
LOG_DIR_NAME="build_log"
LOG_DIRECTORY="${CLIENT_ROOT}/${LOG_DIR_NAME}"
if [ ! -d ${LOG_DIRECTORY} ]; then
  echo "Create Directory for Log in ${LOG_DIRECTORY}"
  mkdir ${LOG_DIRECTORY} > /dev/null 2>&1
  result=$?
  if [ "${result}" -ne "0" ]; then
    echo "log directory create fail"
    exit
  fi
fi

# LOG_FILE formate : ${BUILD_ROOT}_${PROFILE}_${TIME}.log <--> toronto_kddi_director_2011-02-23T10:25:06.log
if [ "${PROFILE}_" = "_" ]; then
  echo "you have to set your profile before to build"
  exit
fi

LOG_FILE="${BUILD_ROOT}_${PROFILE}_${TIME}.log"
LOG_FILE_FULL_PATH="${LOG_DIRECTORY}/${LOG_FILE}"

PROFILE_BACKUP="${PROFILE}_bak"
BACKUP_FOLDER="${BUILD_ROOT}_${PROFILE}_${TIME}"
if [ ! -d "${TFTPBOOT}/${PROFILE_BACKUP}" ]; then
  echo "create ${TFTPBOOT}/${PROFILE_BACKUP}"
  $(mkdir "${TFTPBOOT}/${PROFILE_BACKUP}")
fi

# clean tftp folder
if [ -d "${TFTPBOOT}/${PROFILE}" ]; then
  $(rm -rf "${TFTPBOOT}/${PROFILE}")
fi

# go
echo "make $1 > ${LOG_FILE_FULL_PATH} 2>&1"

START_TIME=$(date +%s)
make $1 > ${LOG_FILE_FULL_PATH} 2>&1
result=$?
END_TIME=$(date +%s)
DELTA=`expr ${END_TIME} - ${START_TIME}`
SEC=$(( ${DELTA} % 60 ))
MIN=$(( (${DELTA} / 60 )% 60 ))
HOUR=$(( (${DELTA} / 60 / 60 ) % 60 ))

echo "total spent ${HOUR} h ${MIN} m ${SEC} s"

# if [ "${result}" -ne "0" ]; then
  # $(vim + ${LOG_FILE_FULL_PATH})
  # exit
# fi

tail -n 20 ${LOG_FILE_FULL_PATH}

# backup
if [ -d "${TFTPBOOT}/${PROFILE}" ]; then
  $(cp -rf "${TFTPBOOT}/${PROFILE}" "${TFTPBOOT}/${PROFILE_BACKUP}/${BACKUP_FOLDER}")
fi

