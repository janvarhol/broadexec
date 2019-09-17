#!/bin/bash

BRDEXEC_MENU_HOSTLISTS=yes

brdexec_menu_hostlists_select () {

  echo -e "\nAvailable hostlists:"
  BRDEXEC_HOSTLIST_SELECT_ID=0
  for BRDEXEC_HOSTLIST_CHOSEN_ITEM in ${BRDEXEC_LIST_OF_FULL_HOSTSFILES}
  do
    ((BRDEXEC_HOSTLIST_SELECT_ID++))
    echo "${BRDEXEC_HOSTLIST_SELECT_ID}) ${BRDEXEC_HOSTLIST_CHOSEN_ITEM}"
  done

  ### display prompt
  if [ ! -z "${BRDEXEC_DEFAULT_HOSTS_FILE_PATH}" ]; then
    if [ -f "${BRDEXEC_DEFAULT_HOSTS_FILE_PATH}" ]; then
      echo -ne "\nSelect hostslist # [${BRDEXEC_DEFAULT_HOSTS_FILE_PATH}] "
    else
      echo -ne "\nSelect hostslist # "
    fi
  else
    echo -ne "\nSelect hostslist # "
  fi
  verbose 182 1

  unset BRDEXEC_HOSTLIST_CHOSEN_ITEM
  read BRDEXEC_HOSTLIST_CHOSEN_ITEM
  if [ "${BRDEXEC_HOSTLIST_CHOSEN_ITEM}" = "" 2>/dev/null ]; then
    if [ -f "${BRDEXEC_DEFAULT_HOSTS_FILE_PATH}" ]; then
      BRDEXEC_HOSTLIST_CHOSEN_ITEM="${BRDEXEC_DEFAULT_HOSTS_FILE_PATH}"
      brdexec_display_output "Default hostlist ${BRDEXEC_HOSTLIST_CHOSEN_ITEM} was selected\n" 255
    else
      display_error "183" 1
    fi
  elif ! [ "${BRDEXEC_HOSTLIST_CHOSEN_ITEM}" -eq "${BRDEXEC_HOSTLIST_CHOSEN_ITEM}" 2>/dev/null ]; then
    display_error "183" 1
  elif [ "$(echo "${BRDEXEC_LIST_OF_FULL_HOSTSFILES}" | wc -w)" -lt "${BRDEXEC_HOSTLIST_CHOSEN_ITEM}" 2>/dev/null ]; then
    display_error "183" 1
  elif [ "${BRDEXEC_HOSTLIST_CHOSEN_ITEM}" -lt 1 2>/dev/null ]; then
    display_error "183" 1
  else
    BRDEXEC_HOSTLIST_SELECT_ID="${BRDEXEC_HOSTLIST_CHOSEN_ITEM}"
    BRDEXEC_HOSTLIST_CHOSEN_ITEM="$(echo "${BRDEXEC_LIST_OF_FULL_HOSTSFILES}" | awk -v field="$BRDEXEC_HOSTLIST_CHOSEN_ITEM" '{print $field}')"
    brdexec_display_output "${BRDEXEC_HOSTLIST_SELECT_ID}) ${BRDEXEC_HOSTLIST_CHOSEN_ITEM} was selected\n" 255
  fi
}
