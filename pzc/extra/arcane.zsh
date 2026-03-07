# -*- tab-width: 2; indent-tabs-mode: nil; coding: utf-8 -*-
# ------------------------------------------------------------------------------
# Copyright 2022-2026 Alexandre l'Heritier
# See the top-level LICENSE file for details.
# SPDX-License-Identifier: Apache-2.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# arcane.zsh
#
# Specific functions and aliases to work in/with the Framework Arcane.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------



## With these functions, you can clone, compile and install Arcane like this:
## $ clonearc    # First time only
## $ initarc R   # R for Release, C for Check, D for Debug
## $ configarc   # If cmake config needed
## $ biarc
##
## Source dir:
## $ gitarc
##
## Build dir:
## $ cd ${CMP_BUILD_DIR}
##
## Install dir:
## $ cd ${CMP_INSTALL_DIR}


# ---------------------------------------------------------------
# -------------------------- Aliases ----------------------------
# ---------------------------------------------------------------

alias clonearc='_pzc_coal_eval "mkdir -p ${WORK_DIR}/arcane" ; \
                _pzc_coal_eval "cd ${WORK_DIR}/arcane" ; \
                _pzc_coal_eval "git clone --recurse-submodules https://github.com/arcaneframework/framework" ; \
                gitarc'

function gitarc()
{
  local CMP_SOURCE_DIR="${WORK_DIR}/arcane/framework"
  if [[ -v 1 ]]
  then
    # TODO : Regex
    if [[ ${1} == "1" ]]
    then
      CMP_SOURCE_DIR="${WORK_DIR}/arcane/framework_wt1"
    else
      CMP_SOURCE_DIR="${WORK_DIR}/arcane/framework_${1}"
    fi
  fi
  _pzc_coal_eval "cd ${CMP_SOURCE_DIR}"
}



# ---------------------------------------------------------------
# ------------------ Generate preset functions ------------------
# ---------------------------------------------------------------

function parc()
{
  _pzc_common_pcmp "framework"

  local RET_CODE=$?

  if [[ $RET_CODE = 1 ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  elif [[ $RET_CODE = 2 ]]
  then
    _pzc_error "Internal error"
    return 1
  fi
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function pap()
{
  _pzc_common_pcmp "arcane_project"

  local RET_CODE=$?

  if [[ $RET_CODE = 1 ]]
  then
    _pzc_error "You need to call 'initap' command before."
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

function initarc()
{

  if [[ -v 3 ]] && [[ ${3} != "_" ]] && [[ ${3} != "none" ]]
  then
    CMP_PROJECT_NAME=framework_${3}
  else
    CMP_PROJECT_NAME=framework
  fi

  _pzc_common_initcmp 1 ${CMP_PROJECT_NAME} ${1} ${2}


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
# ---------------------------------------------------------------

function initap()
{
  _pzc_common_initcmp 0 ${1} ${2} ${3}

  if [[ ! -v ARCANE_INSTALL_DIR ]]
  then
    ARCANE_INSTALL_DIR="${INSTALL_DIR}/install_framework/${TYPE_BUILD_DIR}"
  fi

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
  echo "ARCANE_INSTALL_DIR=${ARCANE_INSTALL_DIR}"
  echo ""
  echo "mkdir -p ${CMP_BUILD_DIR}"
  echo "cd ${CMP_BUILD_DIR}"
  _pzc_pensil_end
}



# ---------------------------------------------------------------
# -------------------- Edit init functions ----------------------
# ---------------------------------------------------------------

function editap()
{
  _pzc_common_editcmp 1

  local RET_CODE=$?

  if [[ $RET_CODE = 1 ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1
  fi

  echo ""
  _pzc_coal_eval "initap ${CMP_PROJECT_NAME} ${CMP_BUILD_TYPE} ${TYPE_BUILD_DIR}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function editaprm()
{
  _pzc_common_editcmprm

  local RET_CODE=$?

  if [[ $RET_CODE = 1 ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1

  elif [[ $RET_CODE = 2 ]]
  then
    _pzc_warning "The edit script doesn't exist."
    return 1
  fi

  echo ""
  _pzc_coal_eval "initap ${CMP_PROJECT_NAME} ${CMP_BUILD_TYPE} ${TYPE_BUILD_DIR}"
}



# ---------------------------------------------------------------
# -------------------- Edit preset functions --------------------
# ---------------------------------------------------------------

function editparc()
{
  if [[ ! -v CMP_BUILD_DIR ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    parc
  fi
  
  _pzc_coal_eval "${PZC_FILE_EDITOR} ${_PZC_TMP_PRESET_PATH}"

  _pzc_info "Build preset edited. You can save it in ${PZC_EDIT_SCRIPTS} with 'saveparc' command."
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function editpap()
{
  if [[ ! -v CMP_BUILD_DIR ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1
  fi

  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    pap
  fi
  
  _pzc_coal_eval "${PZC_FILE_EDITOR} ${_PZC_TMP_PRESET_PATH}"

  _pzc_info "Build preset edited. You can save it in ${PZC_EDIT_SCRIPTS} with 'savepap' command."
}



# ---------------------------------------------------------------
# -------------------- Save preset functions --------------------
# ---------------------------------------------------------------

function saveparc()
{
  if [[ ! -v CMP_BUILD_DIR ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  local _PZC_SAVED_PRESET_PATH="${PZC_EDIT_SCRIPTS}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    _pzc_error "Build preset not found (${_PZC_TMP_PRESET_PATH}). Call 'configarc' or 'parc' command before."
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
# ---------------------------------------------------------------

function savepap()
{
  if [[ ! -v CMP_BUILD_DIR ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1
  fi

  local _PZC_SAVED_PRESET_PATH="${PZC_EDIT_SCRIPTS}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    _pzc_error "Build preset not found (${_PZC_TMP_PRESET_PATH}). Call 'configap' or 'pap' command before."
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

function configarc()
{
  _pzc_info "Configure Arcane Framework..."

  _pzc_common_configcmp

  local RET_CODE=$?

  if [[ $RET_CODE = 1 ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1

  elif [[ $RET_CODE = 2 ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    parc
    _pzc_common_configcmp
  fi
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function configarcgpu()
{
  _pzc_info "Configure Arcane Framework GPU..."

  _pzc_common_configcmp 1

  local RET_CODE=$?

  if [[ $RET_CODE = 1 ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1

  elif [[ $RET_CODE = 2 ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    parc
    _pzc_common_configcmp 1
  fi
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function configap()
{
  _pzc_info "Configure Arcane Project: ${CMP_PROJECT_NAME}..."

  _pzc_common_configcmp

  local RET_CODE=$?

  if [[ $RET_CODE = 1 ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1

  elif [[ $RET_CODE = 2 ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    pap
    _pzc_common_configcmp
  fi
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function configapgpu()
{
  _pzc_info "Configure Arcane Project GPU: ${CMP_PROJECT_NAME}..."

  _pzc_common_configcmp 1

  local RET_CODE=$?

  if [[ $RET_CODE = 1 ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1

  elif [[ $RET_CODE = 2 ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    pap
    _pzc_common_configcmp 1
  fi
}



# ---------------------------------------------------------------
# ------------------- Build/Install functions -------------------
# ---------------------------------------------------------------

function biarc()
{
  if [[ ! -v CMP_BUILD_DIR ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x ${CMP_BUILD_DIR}/bin/*
  fi
  cmake --build ${CMP_BUILD_DIR} --target install
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function docarc()
{
  if [[ ! -v CMP_BUILD_DIR ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x ${CMP_BUILD_DIR}/bin/*
  fi
  cmake --build ${CMP_BUILD_DIR}
  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x ${CMP_BUILD_DIR}/bin/*
  fi
  cmake --build ${CMP_BUILD_DIR} --target ${1}doc
}



# ---------------------------------------------------------------
# ----------------------- Clear functions -----------------------
# ---------------------------------------------------------------

function cleararc()
{
  if [[ ! -v CMP_BUILD_DIR ]]
  then
    _pzc_error "You need to call 'initarc' command before."
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

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function clearap()
{
  if [[ ! -v CMP_BUILD_DIR ]]
  then
    _pzc_error "You need to call 'initap' command before."
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
