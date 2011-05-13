#!/bin/bash

SRC_PATH="/home/blue119/projects/source/work"
PRJ_LIST=("${SRC_PATH}/toronto/" "${SRC_PATH}/toronto_kddi/" "${SRC_PATH}/ml/")
CPNT_LIST=("apps" "controller" "atheros" "video54")
CSCOPE_DB_PATH="cscope_db"

for PRJ in ${PRJ_LIST[*]}
do
  if [ ! -d ${PRJ}${CSCOPE_DB_PATH} ]; then
    echo "mkdir ${PRJ}${CSCOPE_DB_PATH}"
    mkdir ${PRJ}${CSCOPE_DB_PATH}
  fi

  for CPNT in ${CPNT_LIST[*]}
  do 
    cd ${PRJ}
    echo "go to ${PRJ}"
    `find $PWD/$CPNT '(' -name SCCS -o -name BitKeeper -o -name .svn -o \
      -name CVS -o -name .pc -o -name .hg -o -name .git ')' -prune -o '(' \
      -name buildroot -o -name alpha -o -name arm -o -name arm26 -o -name cris \
      -o -name frv -o -name h8300 -o -name ia64 -o -name m32r -o -name m68k \
      -o -name m68knommu -o -name parisc -o -name powerpc -o -name ppc \
      -o -name s390 -o -name sh -o -name sh64 -o -name sparc -o -name sparc64 \
      -o -name v850 -o -name xtensa ')' -prune -o -name '*.[chS]' -type f \
      -print -o -name '*.cc' -type f -print -o -name '*.jsp' -type f -print > \
      ${CSCOPE_DB_PATH}/${CPNT}.files`
    echo "cscope -b -q -k -i${CSCOPE_DB_PATH}/${CPNT}.files -f${CSCOPE_DB_PATH}/${CPNT}.out"
    `cscope -b -q -k -i${CSCOPE_DB_PATH}/${CPNT}.files -f${CSCOPE_DB_PATH}/${CPNT}.out`
  done
done

