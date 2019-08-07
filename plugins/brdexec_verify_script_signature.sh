#!/bin/bash

#TODO enable gpg verification based on different gpg versions
return 0
### check script file signature
### check for custom hash
BRDEXEC_SCRIPT_CUSTOM_HASH="$(grep ^#hsh ${BRDEXEC_SCRIPT_TO_RUN} | awk '{print $2}')"
BRDEXEC_SCRIPT_CUSTOM_HASH_VERIFIED="no"
if [ -f etc/hush ]; then
  while read BRDEXEC_SCRIPT_CUSTOM_HASH_ITEM
  do
    if [ "$(echo "${BRDEXEC_SCRIPT_CUSTOM_HASH_ITEM}" | grep ^hsh | awk '{print $2}')" = "${BRDEXEC_SCRIPT_CUSTOM_HASH}" ]; then
      if [ "${BRDEXEC_SCRIPT_CUSTOM_HASH}" != "" 2>/dev/null ]; then
        BRDEXEC_SCRIPT_CUSTOM_HASH_VERIFIED=yes
      fi
    fi
  done < etc/hush
  if [ "${BRDEXEC_SCRIPT_CUSTOM_HASH_VERIFIED}" = "no" ]; then
    gpg --verify "${1}.asc" "${1}" 2>/dev/null
    if [ "$?" -ne 0 ]; then
      display_error "113" 1
    fi
    limit_file_size -m 1 etc/hush
    BRDEXEC_SCRIPT_SIGNATURE_ID="$(gpg --verify "${1}.asc" "${1}" 2>&1 | grep ID | awk -F " key ID " '{print $2}')"
    if [ ! -z "${BRDEXEC_SCRIPT_SIGNATURE_ID}" ]; then
      if [ "$(grep "^gpg " etc/hush | grep -c "${BRDEXEC_SCRIPT_SIGNATURE_ID}")" -eq 0 ]; then
        display_error "114" 1
      fi
    else
      display_error "114" 1
    fi
  fi
else
  display_error "114" 1
fi