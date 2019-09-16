#!/bin/bash

###BRDEXEC_DEPENDENCIES brdexec_menu_hostlists

#check if dialog is installed
which dialog >/dev/null 2>&1
if [ "$?" -ne 0 ]; then
  echo "ERROR: Dialog not installed. Disable plugin brdexec_dialog_gui by removing it from config file or install dialog."
fi

#tell broadexec that dialog is running
BRDEXEC_DIALOG=yes

dialog_run_selection_of_hostfiles () {

  local BRDEXEC_DIALOG_MENU_OPTIONS
  local BRDEXEC_DIALOG_CMD
  local BRDEXEC_DIALOG_CHOICE

  BRDEXEC_HOSTLIST_SELECT_ID=0
  for BRDEXEC_HOSTLIST_CHOSEN_ITEM in ${BRDEXEC_LIST_OF_FULL_HOSTSFILES}
  do
    ((BRDEXEC_HOSTLIST_SELECT_ID++))
    BRDEXEC_DIALOG_MENU_OPTIONS=" ${BRDEXEC_DIALOG_MENU_OPTIONS} ${BRDEXEC_HOSTLIST_SELECT_ID} ${BRDEXEC_HOSTLIST_CHOSEN_ITEM}"
  done
  BRDEXEC_DIALOG_CMD=(dialog --menu "Select hostlist:" 22 76 16)
  BRDEXEC_DIALOG_MENU_OPTIONS=(${BRDEXEC_DIALOG_MENU_OPTIONS})
  BRDEXEC_DIALOG_CHOICE=$("${BRDEXEC_DIALOG_CMD[@]}" "${BRDEXEC_DIALOG_MENU_OPTIONS[@]}" 2>&1 >/dev/tty)
  BRDEXEC_HOSTLIST_SELECT_ID=0
  BRDEXEC_HOSTLIST_CHOSEN_ITEM="$(echo "${BRDEXEC_LIST_OF_FULL_HOSTSFILES}" | awk -v field="$BRDEXEC_DIALOG_CHOICE" '{print $field}')"
}
