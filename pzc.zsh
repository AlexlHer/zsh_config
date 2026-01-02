# -*- tab-width: 2; indent-tabs-mode: nil; coding: utf-8 -*-
# ------------------------------------------------------------------------------
# Copyright 2022-2026 Alexandre l'Heritier
# See the top-level LICENSE file for details.
# SPDX-License-Identifier: Apache-2.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# pzc.zsh
#
# Main part.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------



local _PZC_PZCRC_DIR=${HOME}

_PZC_CONFIG_STEP=1
# TODO : Bloquer les scripts si _PZC_CONFIG_STEP == 0 ou unset.

source ${PZC_PZC_DIR}/_internal.zsh

_pzc_main()
{
  source ${PZC_PZC_DIR}/_version.zsh

  if [[ ! -e ${_PZC_PZCRC_DIR}/.pzcrc ]]
  then
    PZC_LOG_INFO=1
    _pzc_info "Configuration file not found. Creating this file..."
    cp ${PZC_PZC_DIR}/template.pzcrc ${_PZC_PZCRC_DIR}/.pzcrc
    _pzc_info "Your configuration file is available here: ${_PZC_PZCRC_DIR}/.pzcrc"
    _pzc_info "You can edit it with your favorite editor and relaunching zsh after."
    read -s -k $'?Press any key to continue.\n'
    return 0
  fi

  source ${_PZC_PZCRC_DIR}/.pzcrc

  # Check update...
  source ${PZC_PZC_DIR}/_pzc_update.zsh
  _pzc_check_update
  if [[ ${_PZC_FATAL_ERROR} = 1 ]]
  then
    return 0
  fi
  unfunction _pzc_check_update


  # Configuration done. Launching PZC...
  source ${PZC_PZC_DIR}/_launcher.zsh

  _pzc_sources
  if [[ ${_PZC_FATAL_ERROR} = 1 ]]
  then
    return 0
  fi

  _pzc_welcome

  _pzc_prompt
  if [[ ${_PZC_FATAL_ERROR} = 1 ]]
  then
    return 0
  fi

  unfunction _pzc_sources
  unfunction _pzc_welcome
  unfunction _pzc_prompt
}

_PZC_FATAL_ERROR=0
_pzc_main

if [[ ${_PZC_FATAL_ERROR} = 1 ]]
then
  echo ""
  echo "\033[0;101m\033[30m   Error: A fatal error have been detected in PZC configuration. Check previous messages to fix it. Minimal execution. \033[0m"
  setopt PROMPT_SUBST
  NEWLINE=$'\n'
  PROMPT="[RET=%?][%*]${NEWLINE}${NEWLINE}[%n][%m]${NEWLINE}[%~]${NEWLINE}> "
fi

unset _PZC_FATAL_ERROR
unset _PZC_CONFIG_STEP
unfunction _pzc_main
