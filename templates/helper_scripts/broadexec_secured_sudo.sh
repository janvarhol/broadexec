#!/bin/bash

### Broadexec helper to run scripts in case sudo is allowed only to run one command/script

if [ "$(ls -1 ./*.parameters | wc -w)" -eq 1 ]; then
  PARAMETERS_FILE="$(ls -1 ./*.parameters)"
fi

if [ "$(ls -1 ./*.sh | wc -w)" -eq 1 ]; then
  sh $(ls -1 ./*.sh) $(cat ${PARAMETERS_FILE})
else
  echo "Broadexec helper ERROR: Cannot find proper script to run!"
fi

