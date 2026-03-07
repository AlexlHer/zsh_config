# -*- tab-width: 2; indent-tabs-mode: nil; coding: utf-8 -*-
# ------------------------------------------------------------------------------
# Copyright 2022-2026 Alexandre l'Heritier
# See the top-level LICENSE file for details.
# SPDX-License-Identifier: Apache-2.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# pzc_config.zsh
#
# Config config dir.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------



if [[ ! -v PZC_PZC_CONFIG_DIR ]]
then
  PZC_PZC_CONFIG_DIR=${HOME}/.config/pzc
fi

PZC_PZC_CONFIG_FILE=${PZC_PZC_CONFIG_DIR}/pzcrc


function _pzc_config()
{
  if [[ ! -e "${PZC_PZC_CONFIG_DIR}" ]]
  then
    mkdir -p "${PZC_PZC_CONFIG_DIR}"
    if [[ $? != 0 ]]
    then
      _pzc_error "Error mkdir config dir"
      _PZC_FATAL_ERROR=1
      return 0
    fi
  fi


  if [[ ! -e "${PZC_PZC_CONFIG_FILE}" ]]
  then
    if [[ -e "${HOME}/.pzcrc" ]]
    then
      _pzc_info "Welcome to PZC v7 ! The .pzcrc config file is moved to the XDG config dir (${HOME}/.config/pzc)."
      _pzc_info "Your config file will be copied in the new location. You can delete old config file at '${HOME}/.pzcrc'."
      cp "${HOME}/.pzcrc" "${PZC_PZC_CONFIG_FILE}"
      if [[ $? != 0 ]]
      then
        _pzc_error "Error cp config dir"
        _PZC_FATAL_ERROR=1
        return 0
      fi
    else
      _pzc_info "Configuration file not found. Creating this file..."
      cp ${PZC_PZC_DIR}/template.pzcrc ${PZC_PZC_CONFIG_FILE}
      _pzc_info "Your configuration file is available here: ${PZC_PZC_CONFIG_FILE}"
      _pzc_info "You can edit it with 'pzc_config' command."
      read -s -k $'?Press any key to continue.\n'
    fi
  fi
}
