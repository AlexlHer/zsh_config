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
# ----------------------- Init functions ------------------------
# ---------------------------------------------------------------

function initcmp()
{
  _pzc_info "Setting up CMake project development environment: ${CMP_PROJECT_NAME}"

  CMP_PROJECT_TYPE=1

  _pzc_common_initcmp ${1} ${2} ${3}
  local RET_CODE=$?

  if [[ $RET_CODE != 0 ]]
  then
    return 1
  fi
  
  _pzc_pensil_begin
  echo "CMP_PROJECT_NAME=${CMP_PROJECT_NAME}"
  echo "TYPE_BUILD_DIR=${TYPE_BUILD_DIR}"
  echo ""
  echo "CMP_BUILD_TYPE=${CMP_BUILD_TYPE}"
  echo "CMP_SOURCE_DIR=${CMP_SOURCE_DIR}"
  echo "CMP_BUILD_DIR=${CMP_BUILD_DIR}"
  echo "CMP_INSTALL_DIR=${CMP_INSTALL_DIR}"
  echo ""
  echo "mkdir -p ${CMP_BUILD_DIR}"
  echo "cd ${CMP_BUILD_DIR}"
  _pzc_pensil_end
}



# ---------------------------------------------------------------
# ------------------ Generate preset functions ------------------
# ---------------------------------------------------------------

function pcmp()
{
  _pzc_common_pcmp

  local RET_CODE=$?

  if [[ $RET_CODE = 1 ]]
  then
    _pzc_error "You need to call initialisation command before ('initarc' for Arcane, 'initap' for Arcane project, 'initcmp' for CMake project)."
    return 1
  fi
}



# ---------------------------------------------------------------
# -------------------- Edit preset functions --------------------
# ---------------------------------------------------------------

function editpcmp()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    _pzc_error "You need to call initialisation command before ('initarc' for Arcane, 'initap' for Arcane project, 'initcmp' for CMake project)."
    return 1
  fi

  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_USER_PRESET_PATH}" ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_USER_PRESET_PATH}). Generation..."
    pcmp
  fi
  
  _pzc_coal_eval "${PZC_FILE_EDITOR} ${_PZC_TMP_USER_PRESET_PATH}"

  _pzc_info "Build preset edited. You can save it in ${PZC_EDIT_SCRIPTS} with 'savepcmp' command."
}



# ---------------------------------------------------------------
# -------------------- Save preset functions --------------------
# ---------------------------------------------------------------

function savepcmp()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    _pzc_error "You need to call initialisation command before ('initarc' for Arcane, 'initap' for Arcane project, 'initcmp' for CMake project)."
    return 1
  fi

  local _PZC_SAVED_USER_PRESET_PATH="${PZC_EDIT_SCRIPTS}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_USER_PRESET_PATH}" ]]
  then
    _pzc_error "Build preset not found (${_PZC_TMP_USER_PRESET_PATH}). Call 'configcmp' or 'pcmp' command before."
    return 1
  fi

  if [[ -e "${_PZC_SAVED_USER_PRESET_PATH}" ]]
  then
    _pzc_error "Saved preset found (${_PZC_SAVED_USER_PRESET_PATH}). Do you want to override it ?"
    read -q "REPLY?(y/n)"
    echo ""
    if [[ ${REPLY} != "y" ]]
    then
      unset REPLY
      return 1
    fi
    unset REPLY
  fi
  
  _pzc_coal_eval "cp ${_PZC_TMP_USER_PRESET_PATH} ${_PZC_SAVED_USER_PRESET_PATH}"
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
    _pzc_error "You need to call initialisation command before ('initarc' for Arcane, 'initap' for Arcane project, 'initcmp' for CMake project)."
    return 1

  elif [[ $RET_CODE = 2 ]]
  then
    _pzc_info "Build preset not found. Generation..."
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
    _pzc_error "You need to call initialisation command before ('initarc' for Arcane, 'initap' for Arcane project, 'initcmp' for CMake project)."
    return 1

  elif [[ $RET_CODE = 2 ]]
  then
    _pzc_info "Build preset not found. Generation..."
    pcmp
    _pzc_common_configcmp 1
  fi
}



# ---------------------------------------------------------------
# ------------------- Build/Install functions -------------------
# ---------------------------------------------------------------

function bicmp()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    _pzc_error "You need to call initialisation command before ('initarc' for Arcane, 'initap' for Arcane project, 'initcmp' for CMake project)."
    return 1
  fi

  if [[ ! -e "${CMP_BUILD_DIR}/CMakeCache.txt" ]]
  then
    _pzc_info "CMakeCache.txt not found. Calling 'configcmp' before build..."
    configcmp
    if [[ $? != 0 ]]
    then
      return 1
    fi
  fi

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x ${CMP_BUILD_DIR}/bin/*
  fi
  cmake --build ${CMP_BUILD_DIR} --target install

  local RET_CODE=$?
  if [[ $RET_CODE != 0 ]]
  then
    return 1
  fi

  _pzc_info "${CMP_PROJECT_NAME} is installed in dir: \"${CMP_INSTALL_DIR}\""
}



# ---------------------------------------------------------------
# ----------------------- Clear functions -----------------------
# ---------------------------------------------------------------

clearcmp()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    _pzc_error "You need to call initialisation command before ('initarc' for Arcane, 'initap' for Arcane project, 'initcmp' for CMake project)."
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
