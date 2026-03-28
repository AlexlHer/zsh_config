# -*- tab-width: 2; indent-tabs-mode: nil; coding: utf-8 -*-
# ------------------------------------------------------------------------------
# Copyright 2022-2026 Alexandre l'Heritier
# See the top-level LICENSE file for details.
# SPDX-License-Identifier: Apache-2.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# internal_cmake_projects.zsh
#
# Internal functions to configure CMake projects and Arcane.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------



# ---------------------------------------------------------------
# --------------- Create folder for init scripts ----------------
# ---------------------------------------------------------------

export PZC_EDIT_SCRIPTS=${PZC_USER_CONFIG_DIR}/cmake_scripts
mkdir -p ${PZC_EDIT_SCRIPTS}



# ---------------------------------------------------------------
# ------------------ Generate preset functions ------------------
# ---------------------------------------------------------------

function _pzc_common_configure_preset()
{
  if [[ -v 1 ]] && [[ -e "${1}" ]]
  then
    local PZC_TO_CONFIG=${1}
  else
    return 1
  fi

  if [[ -v 2 ]]
  then
    local PZC_TARGET=${2}
  else
    return 2
  fi

  local ARCANE_ACCELERATOR_MODE="null"
  local ARCANE_CXX_SYCL_FLAGS="null"
  local _PZC_CMAKE_PREFIX_PATH=""
  local CMAKE_CUDA_COMPILER="null"
  local CMAKE_CUDA_FLAGS="null"
  local CMAKE_CUDA_ARCHITECTURES="null"
  local CMAKE_SYCL_COMPILER="null"

  if [[ ${PZC_GPU_AVAILABLE} = 1 ]]
  then
    local _PZC_TEMPLATE_NAME="${_PZC_TEMPLATE_NAME}_gpu"
    local _PZC_EMPTY_TEMPLATE_NAME="${_PZC_EMPTY_TEMPLATE_NAME}_gpu"

    if [[ "${PZC_GPU_DEFAULT_COMPILER}" == "NVCC" ]]
    then
      ARCANE_ACCELERATOR_MODE="CUDA"
      CMAKE_CUDA_COMPILER="${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        CMAKE_CUDA_FLAGS="${PZC_GPU_FLAGS}"
      fi
      if [[ -v PZC_GPU_TARGET_ARCH ]]
      then
        CMAKE_CUDA_ARCHITECTURES="${PZC_GPU_TARGET_ARCH}"
      fi

    else
      ARCANE_ACCELERATOR_MODE="SYCL"
      CMAKE_SYCL_COMPILER="${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        ARCANE_CXX_SYCL_FLAGS="${PZC_GPU_FLAGS}"
      fi
    fi
  fi

  if [[ ${CMP_PROJECT_TYPE} = 3 ]]
  then
    _PZC_CMAKE_PREFIX_PATH="${ARCANE_INSTALL_DIR}"
  fi

  sed \
    -e "s|@CMP_PROJECT_NAME@|${CMP_PROJECT_NAME}|g" \
    -e "s|@CMP_SOURCE_DIR@|${CMP_SOURCE_DIR}|g" \
    -e "s|@CMP_BUILD_DIR@|${CMP_BUILD_DIR}|g" \
    -e "s|@CMP_INSTALL_DIR@|${CMP_INSTALL_DIR}|g" \
    -e "s|@CMP_DIR_BUILD_TYPE@|${TYPE_BUILD_DIR}|g" \
    -e "s|@CMP_BUILD_TYPE@|${CMP_BUILD_TYPE}|g" \
    -e "s|@CMP_VARIANT@|${CMP_VARIANT}|g" \
    -e "s|@CMP_CMAKE_BUILD_TYPE@|${PZC_CMAKE_BUILD_TYPE}|g" \
    -e "s|@CMP_CMAKE_GENERATOR@|${PZC_CMAKE_GENERATOR}|g" \
    -e "s|@CMP_CMAKE_C_CXX_COMPILER_LAUNCHER@|${PZC_CMAKE_C_COMPILER_LAUNCHER}|g" \
    -e "s|@CMP_CMAKE_LINKER_TYPE@|${PZC_CMAKE_LINKER_TYPE}|g" \
    -e "s|@CMP_CMAKE_C_COMPILER@|${PZC_C_COMPILER}|g" \
    -e "s|@CMP_CMAKE_CXX_COMPILER@|${PZC_CXX_COMPILER}|g" \
    -e "s|@CMP_GPU_HOST_COMPILER@|${PZC_GPU_HOST_COMPILER}|g" \
    -e "s|@CMP_CMAKE_CUDA_COMPILER@|${CMAKE_CUDA_COMPILER}|g" \
    -e "s|@CMP_CMAKE_CUDA_FLAGS@|${CMAKE_CUDA_FLAGS}|g" \
    -e "s|@CMP_CMAKE_CUDA_ARCHITECTURES@|${CMAKE_CUDA_ARCHITECTURES}|g" \
    -e "s|@CMP_CMAKE_SYCL_COMPILER@|${CMAKE_SYCL_COMPILER}|g" \
    -e "s|@CMP_CMAKE_PREFIX_PATH@|${_PZC_CMAKE_PREFIX_PATH}|g" \
    -e "s|@CMP_ARCANE_CXX_SYCL_FLAGS@|${ARCANE_CXX_SYCL_FLAGS}|g" \
    -e "s|@CMP_ARCANE_ACCELERATOR_MODE@|${ARCANE_ACCELERATOR_MODE}|g" \
    \
    "${1}" > "${2}"

  # Comme les guillemets sont dans le template, on doit faire le remplacement des null dans un second temps.
  sed -i 's|"null"|null|g' "${2}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function _pzc_common_pcmp()
{
  if [[ ! -v CMP_SOURCE_DIR ]]
  then
    return 1
  fi

  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    return 1
  fi

  if [[ ${CMP_PROJECT_TYPE} = 2 ]]
  then
    local _PZC_TEMPLATE_NAME="framework"
  else
    local _PZC_TEMPLATE_NAME="generic"
  fi
  local _PZC_EMPTY_TEMPLATE_NAME="empty"


  local _PZC_SAVED_USER_PRESET_PATH="${PZC_EDIT_SCRIPTS}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_SAVED_USER_PRESET_GENERIC_PATH="${PZC_EDIT_SCRIPTS}/user_${CMP_PROJECT_NAME}_${CMP_VARIANT}.json"

  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR}/generated_default_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  _pzc_info "Generation of default build preset in build dir (${_PZC_TMP_PRESET_PATH})..."

  local _PZC_TEMPLATE_PRESET_PATH="${PZC_PZC_DIR}/progs/cmake/preset_templates/${_PZC_TEMPLATE_NAME}.json.in"
  _pzc_common_configure_preset "${_PZC_TEMPLATE_PRESET_PATH}" "${_PZC_TMP_PRESET_PATH}"
  if [[ $? != 0 ]]
  then
    return $?
  fi

  if [[ -e "${_PZC_TMP_USER_PRESET_PATH}" ]]
  then
    _pzc_info "User build preset found (${_PZC_TMP_USER_PRESET_PATH})."
    return 0
  fi

  if [[ -e "${_PZC_SAVED_USER_PRESET_PATH}" ]]
  then
    _pzc_info "Copying saved user build preset in build dir (${_PZC_SAVED_USER_PRESET_PATH})..."
    cp "${_PZC_SAVED_USER_PRESET_PATH}" "${_PZC_TMP_USER_PRESET_PATH}"
    return 0
  fi

  if [[ -e "${_PZC_SAVED_USER_PRESET_GENERIC_PATH}" ]]
  then
    _pzc_info "Copying saved general user build preset in build dir (${_PZC_SAVED_USER_PRESET_GENERIC_PATH})..."
    cp "${_PZC_SAVED_USER_PRESET_GENERIC_PATH}" "${_PZC_TMP_USER_PRESET_PATH}"
    return 0
  fi

  _pzc_info "Generation of default user build preset in build dir (${_PZC_TMP_USER_PRESET_PATH})..."

  local _PZC_ARCANE_INSTALL_DIR=""

  if [[ ${CMP_PROJECT_TYPE} = 3 ]]
  then
    _PZC_ARCANE_INSTALL_DIR="\"cmpArcaneInstallDir\": \"${ARCANE_INSTALL_DIR}\","
  fi

  local _PZC_EMPTY_TEMPLATE_PRESET_PATH="${PZC_PZC_DIR}/progs/cmake/preset_templates/${_PZC_EMPTY_TEMPLATE_NAME}.json.in"

  sed \
    -e "s|@PZC_CMP_SOURCE_DIR@|${CMP_SOURCE_DIR}|g" \
    -e "s|@PZC_CMP_BUILD_DIR@|${CMP_BUILD_DIR}|g" \
    -e "s|@PZC_CMP_INSTALL_DIR@|${CMP_INSTALL_DIR}|g" \
    -e "s|@PZC_CMP_OTHER_VAR@|${_PZC_ARCANE_INSTALL_DIR}|g" \
    \
    "${_PZC_EMPTY_TEMPLATE_PRESET_PATH}" > "${_PZC_TMP_USER_PRESET_PATH}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function _pzc_common_generate_user_preset()
{
  if [[ ! -v CMP_SOURCE_DIR ]]
  then
    return 1
  fi

  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    return 1
  fi

  if [[ ${CMP_PROJECT_TYPE} = 2 ]]
  then
    local _PZC_TEMPLATE_NAME="framework"
  else
    local _PZC_TEMPLATE_NAME="generic"
  fi
  local _PZC_EMPTY_TEMPLATE_NAME="empty"


  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_GEN_USER_PRESET_PATH="${CMP_BUILD_DIR}/generated_user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  _pzc_info "Generation of user build preset in build dir (${_PZC_TMP_GEN_USER_PRESET_PATH})..."
  _pzc_common_configure_preset "${_PZC_TMP_USER_PRESET_PATH}" "${_PZC_TMP_GEN_USER_PRESET_PATH}"
  if [[ $? != 0 ]]
  then
    return $?
  fi

  jq -r '.vendor.pzc.cmpDependencies[] | @tsv' "${_PZC_TMP_USER_PRESET_PATH}" | while read -r var1 var2 var3
  do
    _pzc_info "Add dependency : ${var1} ${var2} ${var3}"

    local _PZC_TYPE_BUILD_DIR="${var2}"
    if [[ ${var3} != "_" ]]
    then
      _PZC_TYPE_BUILD_DIR=${_PZC_TYPE_BUILD_DIR}_${var3}
    fi

    local _PZC_INSTALL_PRESET="${INSTALL_DIR}/install_${var1}/${_PZC_TYPE_BUILD_DIR}/generated_install_${var1}_${var2}_${var3}.json"
    if [[ ! -e "${_PZC_INSTALL_PRESET}" ]]
    then
      _pzc_error "Dependency install preset not found. Check dependency install dir or execute 'bidep' command (${INSTALL_DIR}/install_${var1}/${_PZC_TYPE_BUILD_DIR}/generated_install_${var1}_${var2}_${var3}.json)."
      return 2
    fi

    jq \
      ".include += [\"${INSTALL_DIR}/install_${var1}/${_PZC_TYPE_BUILD_DIR}/generated_install_${var1}_${var2}_${var3}.json\"]" \
      "${_PZC_TMP_GEN_USER_PRESET_PATH}" > "${_PZC_TMP_GEN_USER_PRESET_PATH}.tmp"
    \mv "${_PZC_TMP_GEN_USER_PRESET_PATH}.tmp" "${_PZC_TMP_GEN_USER_PRESET_PATH}"

    jq \
      ".configurePresets[].inherits += [\"${var1}_${var2}_${var3}\"]" \
      "${_PZC_TMP_GEN_USER_PRESET_PATH}" > "${_PZC_TMP_GEN_USER_PRESET_PATH}.tmp"
    \mv "${_PZC_TMP_GEN_USER_PRESET_PATH}.tmp" "${_PZC_TMP_GEN_USER_PRESET_PATH}"

  done
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function _pzc_common_ipcmp()
{
  if [[ ! -v CMP_SOURCE_DIR ]]
  then
    return 1
  fi

  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    return 1
  fi

  local _PZC_SAVED_INSTALL_PRESET_PATH="${PZC_EDIT_SCRIPTS}/install_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_SAVED_INSTALL_PRESET_GENERIC_PATH="${PZC_EDIT_SCRIPTS}/install_${CMP_PROJECT_NAME}_${CMP_VARIANT}.json"

  local _PZC_TMP_INSTALL_PRESET_PATH="${CMP_BUILD_DIR}/install_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"


  if [[ -e "${_PZC_TMP_INSTALL_PRESET_PATH}" ]]
  then
    _pzc_info "User install preset found (${_PZC_TMP_INSTALL_PRESET_PATH})."
    return 0
  fi

  if [[ -e "${_PZC_SAVED_INSTALL_PRESET_PATH}" ]]
  then
    _pzc_info "Copying saved user install preset in build dir (${_PZC_SAVED_INSTALL_PRESET_PATH})..."
    cp "${_PZC_SAVED_INSTALL_PRESET_PATH}" "${_PZC_TMP_INSTALL_PRESET_PATH}"
    return 0
  fi

  if [[ -e "${_PZC_SAVED_INSTALL_PRESET_GENERIC_PATH}" ]]
  then
    _pzc_info "Copying saved general user install preset in build dir (${_PZC_SAVED_INSTALL_PRESET_GENERIC_PATH})..."
    cp "${_PZC_SAVED_INSTALL_PRESET_GENERIC_PATH}" "${_PZC_TMP_INSTALL_PRESET_PATH}"
    return 0
  fi

  _pzc_info "Generation of default user install preset in build dir (${_PZC_TMP_INSTALL_PRESET_PATH})..."

  local _PZC_EMPTY_TEMPLATE_PRESET_PATH="${PZC_PZC_DIR}/progs/cmake/preset_templates/install.json.in"

  sed \
    -e "s|@PZC_CMP_SOURCE_DIR@|${CMP_SOURCE_DIR}|g" \
    -e "s|@PZC_CMP_BUILD_DIR@|${CMP_BUILD_DIR}|g" \
    -e "s|@PZC_CMP_INSTALL_DIR@|${CMP_INSTALL_DIR}|g" \
    -e "s|@PZC_CMP_OTHER_VAR@|${_PZC_ARCANE_INSTALL_DIR}|g" \
    \
    "${_PZC_EMPTY_TEMPLATE_PRESET_PATH}" > "${_PZC_TMP_INSTALL_PRESET_PATH}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function _pzc_common_generate_install_preset()
{
  if [[ ! -v CMP_SOURCE_DIR ]]
  then
    return 1
  fi

  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    return 1
  fi


  local _PZC_TMP_INSTALL_PRESET_PATH="${CMP_BUILD_DIR}/install_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_GEN_INSTALL_PRESET_PATH="${CMP_INSTALL_DIR}/generated_install_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  _pzc_info "Generation of install build preset in build dir (${_PZC_TMP_GEN_INSTALL_PRESET_PATH})..."

  _pzc_common_configure_preset "${_PZC_TMP_INSTALL_PRESET_PATH}" "${_PZC_TMP_GEN_INSTALL_PRESET_PATH}"
  if [[ $? != 0 ]]
  then
    return $?
  fi
}



# ---------------------------------------------------------------
# ----------------------- Init functions ------------------------
# ---------------------------------------------------------------

function _pzc_common_initcmp()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    return 3
  fi

  if [[ -v 1 ]]
  then
    CMP_PROJECT_NAME=${1}
  else
    _pzc_error "Need project name (first arg)"
    return 1
  fi

  if [[ -v 2 ]] && [[ ${2} != "_" ]] && [[ ${2} != "none" ]]
  then
    if [[ ${2} == "D" ]] || [[ ${2} == "Debug" ]]
    then
      CMP_BUILD_TYPE=Debug
      PZC_CMAKE_BUILD_TYPE="Debug"
    elif [[ ${2} == "C" ]] || [[ ${2} == "Check" ]]
    then
      CMP_BUILD_TYPE=Check
      PZC_CMAKE_BUILD_TYPE="RelWithDebInfo"
    elif [[ ${2} == "R" ]] || [[ ${2} == "Release" ]]
    then
      CMP_BUILD_TYPE=Release
      PZC_CMAKE_BUILD_TYPE="Release"
    else
      _pzc_error "Invalid 'CMP_BUILD_TYPE' [D or C or R] (second arg)"
      return 1
    fi
  else
    _pzc_info "No argument, defining 'CMP_BUILD_TYPE' to 'Release'"
    CMP_BUILD_TYPE=Release
    PZC_CMAKE_BUILD_TYPE="Release"
  fi

  if [[ -v 3 ]] && [[ ${3} != "_" ]] && [[ ${3} != "none" ]]
  then
    CMP_VARIANT=${3}
    TYPE_BUILD_DIR=${CMP_BUILD_TYPE}_${3}
  else
    CMP_VARIANT=""
    TYPE_BUILD_DIR=${CMP_BUILD_TYPE}
  fi

  local _PZC_SAVED_USER_PRESET_PATH="${PZC_EDIT_SCRIPTS}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  # Valeurs par défaut.
  if [[ ${CMP_PROJECT_TYPE} = 2 ]]
  then
    # Pour compatibilité avec l'existant.
    CMP_SOURCE_DIR="${WORK_DIR}/arcane/${CMP_PROJECT_NAME}"
  else
    CMP_SOURCE_DIR="${WORK_DIR}/${CMP_PROJECT_NAME}"
  fi
  CMP_BUILD_DIR="${BUILD_DIR}/build_${CMP_PROJECT_NAME}/${TYPE_BUILD_DIR}"
  CMP_INSTALL_DIR="${INSTALL_DIR}/install_${CMP_PROJECT_NAME}/${TYPE_BUILD_DIR}"

  if [[ ${CMP_PROJECT_TYPE} = 3 ]]
  then
    ARCANE_INSTALL_DIR="${INSTALL_DIR}/install_framework/${TYPE_BUILD_DIR}"
  fi

  # Si le preset contient des infos d'initialisation.
  if [[ -e ${_PZC_SAVED_USER_PRESET_PATH} ]]
  then
    _pzc_info "The edit script exist. Overwrite default initialization."
    local _PZC_CMP_SOURCE_DIR=$(jq -r '.vendor.pzc.cmpSourceDir' ${_PZC_SAVED_USER_PRESET_PATH})
    local _PZC_CMP_BUILD_DIR=$(jq -r '.vendor.pzc.cmpBuildDir' ${_PZC_SAVED_USER_PRESET_PATH})
    local _PZC_CMP_INSTALL_DIR=$(jq -r '.vendor.pzc.cmpInstallDir' ${_PZC_SAVED_USER_PRESET_PATH})
    local _PZC_ARCANE_INSTALL_DIR=$(jq -r '.vendor.pzc.cmpArcaneInstallDir' ${_PZC_SAVED_USER_PRESET_PATH})

    if [[ ${_PZC_CMP_SOURCE_DIR} != "null" ]]
    then
      CMP_SOURCE_DIR=${_PZC_CMP_SOURCE_DIR}
    fi
    if [[ ${_PZC_CMP_BUILD_DIR} != "null" ]]
    then
      CMP_BUILD_DIR=${_PZC_CMP_BUILD_DIR}
    fi
    if [[ ${_PZC_CMP_INSTALL_DIR} != "null" ]]
    then
      CMP_INSTALL_DIR=${_PZC_CMP_INSTALL_DIR}
    fi
    if [[ ${_PZC_ARCANE_INSTALL_DIR} != "null" ]] && [[ ${CMP_PROJECT_TYPE} = 3 ]]
    then
      ARCANE_INSTALL_DIR=${_PZC_ARCANE_INSTALL_DIR}
    fi
  fi

  mkdir -p "${CMP_BUILD_DIR}"
  mkdir -p "${CMP_INSTALL_DIR}"

  cd "${CMP_BUILD_DIR}"
}



# ---------------------------------------------------------------
# ---------------------- Config functions -----------------------
# ---------------------------------------------------------------

function _pzc_common_configcmp()
{
  if [[ ! -v CMP_BUILD_DIR ]]
  then
    return 1
  fi
  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_USER_PRESET_PATH}" ]]
  then
    return 2
  fi

  local _PZC_TMP_GEN_USER_PRESET_PATH="${CMP_BUILD_DIR}/generated_user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  _pzc_info "Generation of user build preset from ${_PZC_TMP_USER_PRESET_PATH}..."
  _pzc_common_generate_user_preset
  if [[ $? != 0 ]]
  then
    return $?
  fi

  _pzc_info "Use user build preset (${_PZC_TMP_GEN_USER_PRESET_PATH})."

  _pzc_info "Generation of CMakeUserPresets.json in ${CMP_PROJECT_NAME} source..."
  echo "{\"version\": 4,\"include\": [\"${_PZC_TMP_GEN_USER_PRESET_PATH}\"]}" > "${CMP_SOURCE_DIR}/CMakeUserPresets.json"

  _pzc_pensil_begin


  if [[ -v 1 ]] && [[ ${1} == "1" ]]
  then
      echo "cmake \\"
      echo "  -S ${CMP_SOURCE_DIR} \\"
      echo "  --preset ${CMP_BUILD_TYPE}_gpu"
  else
      echo "cmake \\"
      echo "  -S ${CMP_SOURCE_DIR} \\"
      echo "  --preset ${CMP_BUILD_TYPE}"
  fi


  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    echo "chmod u+x ${CMP_BUILD_DIR}/bin/*"
  fi

  _pzc_pensil_end

  if [[ -v 1 ]] && [[ ${1} == "1" ]]
  then
    cmake \
      -S ${CMP_SOURCE_DIR} \
      --preset "${CMP_BUILD_TYPE}_gpu"
  else
    cmake \
      -S ${CMP_SOURCE_DIR} \
      --preset "${CMP_BUILD_TYPE}"
  fi


  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x "${CMP_BUILD_DIR}/bin/*"
  fi
}



# ---------------------------------------------------------------
# ----------------------  -----------------------
# ---------------------------------------------------------------

function _pzc_common_depcmp()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    return 3
  fi

  if [[ -v 1 ]]
  then
    local ADD_CMP_PROJECT_NAME=${1}
  else
    _pzc_error "Need dep project name (first arg)"
    return 1
  fi

  if [[ -v 2 ]] && [[ ${2} != "_" ]] && [[ ${2} != "none" ]]
  then
    if [[ ${2} == "D" ]] || [[ ${2} == "Debug" ]]
    then
      local ADD_CMP_BUILD_TYPE=Debug
    elif [[ ${2} == "C" ]] || [[ ${2} == "Check" ]]
    then
      local ADD_CMP_BUILD_TYPE=Check
    elif [[ ${2} == "R" ]] || [[ ${2} == "Release" ]]
    then
      local ADD_CMP_BUILD_TYPE=Release
    else
      _pzc_error "Invalid 'ADD_CMP_BUILD_TYPE' [D or C or R] (second arg)"
      return 1
    fi
  else
    _pzc_info "No argument, defining 'ADD_CMP_BUILD_TYPE' to 'Release'"
    local ADD_CMP_BUILD_TYPE=Release
  fi

  if [[ -v 3 ]] && [[ ${3} != "_" ]] && [[ ${3} != "none" ]]
  then
    local ADD_CMP_VARIANT=${3}
  else
    local ADD_CMP_VARIANT="_"
  fi

  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  if [[ ! -e "${_PZC_TMP_USER_PRESET_PATH}" ]]
  then
    return 2
  fi

  if [[ -v 4 ]]
  then
    if [[ ${4} == 1 ]]
    then
      # Ajout
      jq \
        ".vendor.pzc.cmpDependencies += [[\"${ADD_CMP_PROJECT_NAME}\", \"${ADD_CMP_BUILD_TYPE}\", \"${ADD_CMP_VARIANT}\"]]" \
        "${_PZC_TMP_USER_PRESET_PATH}" > "${_PZC_TMP_USER_PRESET_PATH}.tmp"
    elif [[ ${4} == 2 ]]
    then
      # Suppression
      jq \
        ".vendor.pzc.cmpDependencies -= [[\"${ADD_CMP_PROJECT_NAME}\", \"${ADD_CMP_BUILD_TYPE}\", \"${ADD_CMP_VARIANT}\"]]" \
        "${_PZC_TMP_USER_PRESET_PATH}" > "${_PZC_TMP_USER_PRESET_PATH}.tmp"
    fi
  else
    return 4
  fi

  \mv "${_PZC_TMP_USER_PRESET_PATH}.tmp" "${_PZC_TMP_USER_PRESET_PATH}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function _pzc_common_bidep()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    return 3
  fi

  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  if [[ ! -e "${_PZC_TMP_USER_PRESET_PATH}" ]]
  then
    return 2
  fi

  local ACTUAL_CMP_PROJECT_TYPE=${CMP_PROJECT_TYPE}
  local ACTUAL_CMP_PROJECT_NAME=${CMP_PROJECT_NAME}
  local ACTUAL_CMP_BUILD_TYPE=${CMP_BUILD_TYPE}
  local ACTUAL_CMP_VARIANT=${CMP_VARIANT}

  # Dépendences uniquement de type 1.
  CMP_PROJECT_TYPE=1

  jq -r '.vendor.pzc.cmpDependencies[] | @tsv' "${_PZC_TMP_USER_PRESET_PATH}" | while read -r var1 var2 var3
  do
    _pzc_info "Build install ${var1} ${var2} ${var3}"
    _pzc_common_initcmp ${var1} ${var2} ${var3}

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

    if [[ $? != 0 ]]
    then
      return 1
    fi

    _pzc_info "${CMP_PROJECT_NAME} is installed in dir: \"${CMP_INSTALL_DIR}\""
    _pzc_common_generate_install_preset
    if [[ $? != 0 ]]
    then
      return $?
    fi

  done

  CMP_PROJECT_TYPE=${ACTUAL_CMP_PROJECT_TYPE}

  _pzc_info "Reload project ${ACTUAL_CMP_PROJECT_NAME} ${ACTUAL_CMP_BUILD_TYPE} ${ACTUAL_CMP_VARIANT}"
  # Attention : ACTUAL_CMP_VARIANT peut être vide.
  _pzc_common_initcmp ${ACTUAL_CMP_PROJECT_NAME} ${ACTUAL_CMP_BUILD_TYPE} ${ACTUAL_CMP_VARIANT}
}
