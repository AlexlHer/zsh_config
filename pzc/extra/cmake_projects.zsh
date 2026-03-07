# -*- tab-width: 2; indent-tabs-mode: nil; coding: utf-8 -*-
# ------------------------------------------------------------------------------
# Copyright 2022-2026 Alexandre l'Heritier
# See the top-level LICENSE file for details.
# SPDX-License-Identifier: Apache-2.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# cmake_projects.zsh
#
# General functions to configure CMake projects.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------



# ---------------------------------------------------------------
# ------------------ Generate preset functions ------------------
# ---------------------------------------------------------------

function pcmp()
{
  _pzc_common_pcmp "generic"

  local RET_CODE=$?

  if [[ $RET_CODE = 1 ]]
  then
    _pzc_error "You need to call 'initcmp' command before."
    return 1
  elif [[ $RET_CODE = 2 ]]
  then
    _pzc_error "Internal error"
    return 1
  fi
}



# ---------------------------------------------------------------
# ----------------------- Init functions ------------------------
# ---------------------------------------------------------------

function initcmp()
{
  _pzc_common_initcmp 0 ${1} ${2} ${3}

  _pzc_pensil_begin
  echo "CMP_PROJECT_NAME=${CMP_PROJECT_NAME}"
  echo "TYPE_BUILD_DIR=${TYPE_BUILD_DIR}"
  echo ""
  echo "CMP_BUILD_TYPE=${CMP_BUILD_TYPE}"
  echo "CMP_PROJECT_DIR=${CMP_PROJECT_DIR}"
  echo "CMP_SOURCE_DIR=${CMP_SOURCE_DIR}"
  echo "CMP_BUILD_DIR=${CMP_BUILD_DIR}"
  echo "CMP_INSTALL_DIR=${CMP_INSTALL_DIR}"
  echo ""
  echo "mkdir -p ${CMP_BUILD_DIR}"
  echo "cd ${CMP_BUILD_DIR}"
  _pzc_pensil_end
}



# ---------------------------------------------------------------
# -------------------- Edit init functions ----------------------
# ---------------------------------------------------------------

function editcmp()
{
  _pzc_common_editcmp

  local RET_CODE=$?

  if [[ $RET_CODE = 1 ]]
  then
    _pzc_error "You need to call 'initcmp' command before."
    return 1
  fi

  echo ""
  _pzc_coal_eval "initcmp ${CMP_PROJECT_NAME} ${CMP_BUILD_TYPE} ${TYPE_BUILD_DIR}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function editcmprm()
{
  _pzc_common_editcmprm

  local RET_CODE=$?

  if [[ $RET_CODE = 1 ]]
  then
    _pzc_error "You need to call 'initcmp' command before."
    return 1

  elif [[ $RET_CODE = 2 ]]
  then
    _pzc_warning "The edit script doesn't exist."
    return 1
  fi

  echo ""
  _pzc_coal_eval "initcmp ${CMP_PROJECT_NAME} ${CMP_BUILD_TYPE} ${TYPE_BUILD_DIR}"
}



# ---------------------------------------------------------------
# -------------------- Edit preset functions --------------------
# ---------------------------------------------------------------

function editpcmp()
{
  if [[ ! -v CMP_BUILD_DIR ]]
  then
    _pzc_error "You need to call 'initcmp' command before."
    return 1
  fi

  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    pcmp
  fi
  
  _pzc_coal_eval "${PZC_FILE_EDITOR} ${_PZC_TMP_PRESET_PATH}"

  _pzc_info "Build preset edited. You can save it in ${PZC_EDIT_SCRIPTS} with 'savepcmp' command."
}



# ---------------------------------------------------------------
# -------------------- Save preset functions --------------------
# ---------------------------------------------------------------

function savepcmp()
{
  if [[ ! -v CMP_BUILD_DIR ]]
  then
    _pzc_error "You need to call 'initcmp' command before."
    return 1
  fi

  local _PZC_SAVED_PRESET_PATH="${PZC_EDIT_SCRIPTS}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    _pzc_error "Build preset not found (${_PZC_TMP_PRESET_PATH}). Call 'configcmp' or 'pcmp' command before."
    return 1
  fi

  if [[ -e "${_PZC_SAVED_PRESET_PATH}" ]]
  then
    _pzc_error "Saved preset found (${_PZC_SAVED_PRESET_PATH}). Do you want to override it ?"
    read -q "REPLY?(y/n)"
    echo ""
    if [[ ${REPLY} != "y" ]]
    then
      unset REPLY
      return 1
    fi
    unset REPLY
  fi
  
  _pzc_coal_eval "cp ${_PZC_TMP_PRESET_PATH} ${_PZC_SAVED_PRESET_PATH}"
}



# ---------------------------------------------------------------
# ---------------------- Config functions -----------------------
# ---------------------------------------------------------------

function configcmp()
{
  _pzc_info "Configure CMake Project: ${CMP_PROJECT_NAME}..."

  _pzc_common_configcmp

  local RET_CODE=$?

  if [[ $RET_CODE = 1 ]]
  then
    _pzc_error "You need to call 'initcmp' command before."
    return 1

  elif [[ $RET_CODE = 2 ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    pcmp
    _pzc_common_configcmp
  fi
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function configcmpgpu()
{
  _pzc_info "Configure CMake Project GPU: ${CMP_PROJECT_NAME}..."

  _pzc_common_configcmp 1

  local RET_CODE=$?

  if [[ $RET_CODE = 1 ]]
  then
    _pzc_error "You need to call 'initcmp' command before."
    return 1

  elif [[ $RET_CODE = 2 ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    pcmp
    _pzc_common_configcmp 1
  fi
}



# ---------------------------------------------------------------
# ----------------------- Clear functions -----------------------
# ---------------------------------------------------------------

clearcmp()
{
  if [[ ! -v CMP_BUILD_DIR ]]
  then
    _pzc_error "You need to call 'initcmp' command before."
    return 1
  fi

  _pzc_pensil_begin
  _pzc_ecal_eval "cd ${CMP_BUILD_DIR}/.."
  _pzc_ecal_eval "rm -r ${CMP_BUILD_DIR}"
  _pzc_ecal_eval "rm -r ${CMP_INSTALL_DIR}"
  _pzc_ecal_eval "mkdir ${CMP_BUILD_DIR}"
  _pzc_ecal_eval "mkdir ${CMP_INSTALL_DIR}"
  _pzc_ecal_eval "cd ${CMP_BUILD_DIR}"
  _pzc_pensil_end
}
