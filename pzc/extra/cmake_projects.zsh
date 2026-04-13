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
# ----------------------- Error functions -----------------------
# ---------------------------------------------------------------

#! \brief Fonction permettant de décrire le code erreur.
#!
#! Code 0 : Ok.
#! Code 1 : Erreur avec message.
#! Code 2 : Erreur interne.
#! Code 10 : Projet non initialisé.
#! Code 11 : Le fichier d'entrée n'est pas spécifié ou n'existe pas.
#! Code 12 : Le fichier de sortie n'est pas spécifié.
#! Code 13 : Preset de configuration utilisateur 1/2 "user_" non trouvé.
#! Code 14 : Preset de configuration utilisateur 2/2 "generated_user_" non trouvé.
#! Code 15 : Preset d'installation utilisateur 1/2 "install_" non trouvé.
#! Code 16 : Preset d'installation utilisateur 2/2 "generated_install_" d'une dep non trouvé (avec message).
function _pzc_cmp_error_message()
{
  _pzc_debug "Error code : ${1}"
  if [[ ! -v 1 ]] || [[ ${1} == 2 ]] || [[ ${1} == 11 ]] || [[ ${1} == 12 ]]
  then
    _pzc_error "Internal error"
    return 1

  elif [[ ${1} == 1 ]] || [[ ${1} == 16 ]]
  then
    return 1

  elif [[ ${1} == 10 ]]
  then
    _pzc_error "You need to call initialisation command before ('initarc' for Arcane, 'initap' for Arcane project, 'initcmp' for CMake project)."
    return 1

  elif [[ ${1} == 13 ]]
  then
    _pzc_error "Configuration user preset not found. Call 'configcmp' or 'pcmp' command before."
    return 1

  elif [[ ${1} == 14 ]]
  then
    _pzc_error "Final configuration user preset not generated. Call 'configcmp' or 'pcmp' command before."
    return 1

  elif [[ ${1} == 15 ]]
  then
    _pzc_error "Installation user preset not found. Call 'configcmp' or 'pcmp' command before."
    return 1

  fi
}



# ---------------------------------------------------------------
# ----------------------- Init functions ------------------------
# ---------------------------------------------------------------

function initcmp()
{
  _pzc_info "Setting up CMake project development environment: ${CMP_PROJECT_NAME}"

  CMP_PROJECT_TYPE=1

  _pzc_common_initcmp ${1} ${2} ${3}
  local RET_CODE=$?
  if [[ ${RET_CODE} != 0 ]]
  then
    _pzc_cmp_error_message ${RET_CODE}
    return $?
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
  if [[ ${RET_CODE} != 0 ]]
  then
    _pzc_cmp_error_message ${RET_CODE}
    return $?
  fi

  _pzc_common_ipcmp
  local RET_CODE=$?
  if [[ ${RET_CODE} != 0 ]]
  then
    _pzc_cmp_error_message ${RET_CODE}
    return $?
  fi
}



# ---------------------------------------------------------------
# -------------------- Edit preset functions --------------------
# ---------------------------------------------------------------

function editpcmp()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    _pzc_cmp_error_message 10
    return $?
  fi

  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_USER_PRESET_PATH}" ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_USER_PRESET_PATH}). Generation..."

    _pzc_common_pcmp
    local RET_CODE=$?
    if [[ ${RET_CODE} != 0 ]]
    then
      _pzc_cmp_error_message ${RET_CODE}
      return $?
    fi
  fi
  
  _pzc_coal_eval "${PZC_FILE_EDITOR} ${_PZC_TMP_USER_PRESET_PATH}"

  _pzc_info "Build preset edited. You can save it in ${PZC_EDIT_SCRIPTS} with 'savepcmp' command."
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function editipcmp()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    _pzc_cmp_error_message 10
    return $?
  fi

  local _PZC_TMP_INSTALL_PRESET_PATH="${CMP_BUILD_DIR}/install_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_INSTALL_PRESET_PATH}" ]]
  then
    _pzc_info "Install preset not found (${_PZC_TMP_INSTALL_PRESET_PATH}). Generation..."

    _pzc_common_ipcmp
    local RET_CODE=$?
    if [[ ${RET_CODE} != 0 ]]
    then
      _pzc_cmp_error_message ${RET_CODE}
      return $?
    fi
  fi
  
  _pzc_coal_eval "${PZC_FILE_EDITOR} ${_PZC_TMP_INSTALL_PRESET_PATH}"

  _pzc_info "Install preset edited. You can save it in ${PZC_EDIT_SCRIPTS} with 'saveipcmp' command."
}


# ---------------------------------------------------------------
# -------------------- Save preset functions --------------------
# ---------------------------------------------------------------

function savepcmp()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    _pzc_cmp_error_message 10
    return $?
  fi

  local _PZC_SAVED_USER_PRESET_PATH="${PZC_EDIT_SCRIPTS}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_USER_PRESET_PATH}" ]]
  then
    _pzc_cmp_error_message 13
    return $?
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
# ---------------------------------------------------------------

function savepcmpg()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    _pzc_cmp_error_message 10
    return $?
  fi


  local _PZC_SAVED_USER_PRESET_PATH="${PZC_EDIT_SCRIPTS}/user_${CMP_PROJECT_NAME}_${CMP_VARIANT}.json"
  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_USER_PRESET_PATH}" ]]
  then
    _pzc_cmp_error_message 13
    return $?
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

  _pzc_warning "Removing cmpBuildDir/cmpInstallDir if present..."

  jq \
    'del(.vendor.pzc.cmpBuildDir, .vendor.pzc.cmpInstallDir, .vendor.pzc.cmpArcaneInstallDir)' \
    ${_PZC_TMP_USER_PRESET_PATH} > ${_PZC_TMP_USER_PRESET_PATH}.tmp

  \mv ${_PZC_TMP_USER_PRESET_PATH}.tmp ${_PZC_TMP_USER_PRESET_PATH}

  _pzc_coal_eval "cp ${_PZC_TMP_USER_PRESET_PATH} ${_PZC_SAVED_USER_PRESET_PATH}"
}


# ---------------------------------------------------------------
# ---------------------------------------------------------------

function savepcmpgg()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    _pzc_cmp_error_message 10
    return $?
  fi


  local _PZC_SAVED_USER_PRESET_PATH="${PZC_EDIT_SCRIPTS}/user_${CMP_PROJECT_NAME}.json"
  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_USER_PRESET_PATH}" ]]
  then
    _pzc_cmp_error_message 13
    return $?
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

  _pzc_warning "Removing cmpBuildDir/cmpInstallDir if present..."

  jq \
    'del(.vendor.pzc.cmpBuildDir, .vendor.pzc.cmpInstallDir, .vendor.pzc.cmpArcaneInstallDir)' \
    ${_PZC_TMP_USER_PRESET_PATH} > ${_PZC_TMP_USER_PRESET_PATH}.tmp

  \mv ${_PZC_TMP_USER_PRESET_PATH}.tmp ${_PZC_TMP_USER_PRESET_PATH}

  _pzc_coal_eval "cp ${_PZC_TMP_USER_PRESET_PATH} ${_PZC_SAVED_USER_PRESET_PATH}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function saveipcmp()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    _pzc_cmp_error_message 10
    return $?
  fi

  local _PZC_SAVED_USER_PRESET_PATH="${PZC_EDIT_SCRIPTS}/install_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/install_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_USER_PRESET_PATH}" ]]
  then
    _pzc_cmp_error_message 15
    return $?
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
# ---------------------------------------------------------------

function saveipcmpg()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    _pzc_cmp_error_message 10
    return $?
  fi


  local _PZC_SAVED_USER_PRESET_PATH="${PZC_EDIT_SCRIPTS}/install_${CMP_PROJECT_NAME}_${CMP_VARIANT}.json"
  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/install_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_USER_PRESET_PATH}" ]]
  then
    _pzc_cmp_error_message 15
    return $?
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
# ---------------------------------------------------------------

function saveipcmpgg()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    _pzc_cmp_error_message 10
    return $?
  fi


  local _PZC_SAVED_USER_PRESET_PATH="${PZC_EDIT_SCRIPTS}/install_${CMP_PROJECT_NAME}.json"
  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/install_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_USER_PRESET_PATH}" ]]
  then
    _pzc_cmp_error_message 15
    return $?
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

  _pzc_common_generate_and_configcmp 0
  local RET_CODE=$?
  if [[ ${RET_CODE} != 0 ]]
  then
    _pzc_cmp_error_message ${RET_CODE}
    return $?
  fi
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function configcmpgpu()
{
  _pzc_info "Configure CMake Project GPU: ${CMP_PROJECT_NAME}..."

  _pzc_common_generate_and_configcmp 1
  local RET_CODE=$?
  if [[ ${RET_CODE} != 0 ]]
  then
    _pzc_cmp_error_message ${RET_CODE}
    return $?
  fi
}



# ---------------------------------------------------------------
# ------------------- Build/Install functions -------------------
# ---------------------------------------------------------------

function bicmp()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    _pzc_cmp_error_message 10
    return $?
  fi

  if [[ ! -e "${CMP_BUILD_DIR}/CMakeCache.txt" ]]
  then
    _pzc_info "CMakeCache.txt not found. Calling 'configcmp' before build..."

    _pzc_common_generate_and_configcmp 0
    local RET_CODE=$?
    if [[ ${RET_CODE} != 0 ]]
    then
      _pzc_cmp_error_message ${RET_CODE}
      return $?
    fi

  fi

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x ${CMP_BUILD_DIR}/bin/*
  fi

  cmake --build ${CMP_BUILD_DIR} --target install
  if [[ $? != 0 ]]
  then
    return 1
  fi

  _pzc_info "${CMP_PROJECT_NAME} is installed in dir: \"${CMP_INSTALL_DIR}\""

  _pzc_common_generate_install_preset
  local RET_CODE=$?
  if [[ ${RET_CODE} = 11 ]]
  then
    _pzc_info "Installation user preset not found. Generation..."

    _pzc_common_ipcmp
    local RET_CODE2=$?
    if [[ ${RET_CODE2} != 0 ]]
    then
      return ${RET_CODE2}
    fi

    _pzc_common_generate_install_preset
    local RET_CODE2=$?
    if [[ ${RET_CODE2} != 0 ]]
    then
      return ${RET_CODE2}
    fi

  elif [[ ${RET_CODE} != 0 ]]
  then
    _pzc_cmp_error_message ${RET_CODE}
    return $?
  fi
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function bidep()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    _pzc_cmp_error_message 10
    return $?
  fi

  _pzc_common_bidep
  local RET_CODE=$?
  if [[ ${RET_CODE} != 0 ]]
  then
    _pzc_cmp_error_message ${RET_CODE}
    return $?
  fi
}



# ---------------------------------------------------------------
# ----------------------- Clear functions -----------------------
# ---------------------------------------------------------------

function clearcmp()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    _pzc_cmp_error_message 10
    return $?
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
# ------------------- Dependencies functions --------------------
# ---------------------------------------------------------------

function adepcmp()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    _pzc_cmp_error_message 10
    return $?
  fi

  if [[ ! -v 1 ]] || [[ ! -v 2 ]] || [[ ! -v 3 ]]
  then
    _pzc_info "adepcmp [dependency project name] [dependency build type OR '_'] [dependency variant name OR '_']"
    return 0
  fi
  

  _pzc_common_depcmp ${1} ${2} ${3} 1
  local RET_CODE=$?
  if [[ ${RET_CODE} != 0 ]]
  then
    _pzc_cmp_error_message ${RET_CODE}
    return $?
  fi
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function rdepcmp()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    _pzc_cmp_error_message 10
    return $?
  fi

  if [[ ! -v 1 ]] || [[ ! -v 2 ]] || [[ ! -v 3 ]]
  then
    _pzc_info "rdepcmp [dependency project name] [dependency build type OR '_'] [dependency variant name OR '_']"
    return 0
  fi
  

  _pzc_common_depcmp ${1} ${2} ${3} 2
  local RET_CODE=$?
  if [[ ${RET_CODE} != 0 ]]
  then
    _pzc_cmp_error_message ${RET_CODE}
    return $?
  fi
}
