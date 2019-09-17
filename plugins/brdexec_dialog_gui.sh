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
  for BRDEXEC_HOSTLIST_CHOSEN_ITEM in ${BRDEXEC_LIST_OF_FULL_HOSTSFILES}; do
    ((BRDEXEC_HOSTLIST_SELECT_ID++))
    BRDEXEC_DIALOG_MENU_OPTIONS=" ${BRDEXEC_DIALOG_MENU_OPTIONS} ${BRDEXEC_HOSTLIST_SELECT_ID} ${BRDEXEC_HOSTLIST_CHOSEN_ITEM}"
  done
  BRDEXEC_DIALOG_CMD=(dialog --menu "Select hostlist:" 22 76 16)
  BRDEXEC_DIALOG_MENU_OPTIONS=(${BRDEXEC_DIALOG_MENU_OPTIONS})
  BRDEXEC_DIALOG_CHOICE=$("${BRDEXEC_DIALOG_CMD[@]}" "${BRDEXEC_DIALOG_MENU_OPTIONS[@]}" 2>&1 >/dev/tty)
  BRDEXEC_HOSTLIST_SELECT_ID=0 # useless now?
  BRDEXEC_HOSTLIST_CHOSEN_ITEM="$(echo "${BRDEXEC_LIST_OF_FULL_HOSTSFILES}" | awk -v field="$BRDEXEC_DIALOG_CHOICE" '{print $field}')"
}

brdexec_dialog_gui_hostlist_filter_selection () {

  local BRDEXEC_DIALOG_MENU_OPTIONS
  local BRDEXEC_DIALOG_CMD
  local BRDEXEC_DIALOG_CHOICE

  BRDEXEC_FILTER_SELECT_ID=0
  for BRDEXEC_HOSTS_FILTER_SELECT_ITEM in ${BRDEXEC_HOSTS_FILTER_LIST}; do
    ((BRDEXEC_FILTER_SELECT_ID++))
    BRDEXEC_DIALOG_MENU_OPTIONS=" ${BRDEXEC_DIALOG_MENU_OPTIONS} ${BRDEXEC_FILTER_SELECT_ID} ${BRDEXEC_HOSTS_FILTER_SELECT_ITEM}"
  done
  BRDEXEC_DIALOG_CMD=(dialog --menu "Select hostlist filter:" 22 76 16)
  BRDEXEC_DIALOG_MENU_OPTIONS=(${BRDEXEC_DIALOG_MENU_OPTIONS})
  BRDEXEC_DIALOG_CHOICE=$("${BRDEXEC_DIALOG_CMD[@]}" "${BRDEXEC_DIALOG_MENU_OPTIONS[@]}" 2>&1 >/dev/tty)
  BRDEXEC_HOSTS_FILTER_SELECT_ITEM="$(echo "${BRDEXEC_HOSTS_FILTER_LIST}" | awk -v field="$BRDEXEC_DIALOG_CHOICE" '{print $field}')"
}

brdexec_dialog_gui_scripts_select () {

  local BRDEXEC_DIALOG_MENU_OPTIONS
  local BRDEXEC_DIALOG_CMD
  local BRDEXEC_DIALOG_CHOICE
  BRDEXEC_SCRIPT_SELECT_ID=0
  for BRDEXEC_SCRIPT_SELECT_ITEM in ${BRDEXEC_LIST_OF_PREDEFINED_SCRIPTS}; do
    ((BRDEXEC_SCRIPT_SELECT_ID++))
    BRDEXEC_DIALOG_MENU_OPTIONS=" ${BRDEXEC_DIALOG_MENU_OPTIONS} ${BRDEXEC_SCRIPT_SELECT_ID} ${BRDEXEC_SCRIPT_SELECT_ITEM}"
  done
  BRDEXEC_DIALOG_CMD=(dialog --menu "Select script:" 22 76 16)
  BRDEXEC_DIALOG_MENU_OPTIONS=(${BRDEXEC_DIALOG_MENU_OPTIONS})
  BRDEXEC_DIALOG_CHOICE=$("${BRDEXEC_DIALOG_CMD[@]}" "${BRDEXEC_DIALOG_MENU_OPTIONS[@]}" 2>&1 >/dev/tty)
  BRDEXEC_PREDEFINED_SCRIPTS_ITEM="$(echo "${BRDEXEC_LIST_OF_PREDEFINED_SCRIPTS}" | awk -v field="$BRDEXEC_DIALOG_CHOICE" '{print $field}')"
}

brdexec_dialog_gui_info_about_parameters () {

  dialog --title "Broadexec generated parameters" --msgbox "To skip menu selection you can run broadexec next time with following parameters: \n./broadexec.sh ${BRDEXEC_PARAMETERS_BACKUP}${BRDEXEC_SELECTED_PARAMETERS_INFO}\n" 22 76
}
