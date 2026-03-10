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
  elif [[ ${CMP_PROJECT_TYPE} = 3 ]]
  then
    local _PZC_TEMPLATE_NAME="arcane_project"
  else
    local _PZC_TEMPLATE_NAME="generic"
  fi

  local _PZC_SAVED_PRESET_PATH="${PZC_EDIT_SCRIPTS}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    _pzc_info "Build preset found (${_PZC_TMP_PRESET_PATH})."
    return 0
  fi

  if [[ -e "${_PZC_SAVED_PRESET_PATH}" ]]
  then
    _pzc_info "Copying saved preset (${_PZC_SAVED_PRESET_PATH}) in build dir..."
    cp "${_PZC_SAVED_PRESET_PATH}" "${_PZC_TMP_PRESET_PATH}"
    return 0
  fi

  _pzc_info "Generation of preset in build dir..."

  local _PZC_TEMPLATE_PRESET_PATH="${PZC_PZC_DIR}/progs/cmake/preset_templates/${_PZC_TEMPLATE_NAME}.json.in"

  if [[ ${PZC_GPU_AVAILABLE} = 1 ]]
  then
    if [[ "${PZC_GPU_DEFAULT_COMPILER}" == "NVCC" ]]
    then
      local _PZC_ARCANE_ACCELERATOR_MODE="\"ARCANE_ACCELERATOR_MODE\": \"CUDA\","
      local _PZC_CMAKE_GPU_COMPILER="\"CMAKE_CUDA_COMPILER\": \"${PZC_GPU_COMPILER}\","
      if [[ -v PZC_GPU_FLAGS ]]
      then
        local _PZC_CMAKE_GPU_FLAGS="\"CMAKE_CUDA_FLAGS\": \"${PZC_GPU_FLAGS}\","
      fi
      if [[ -v PZC_GPU_TARGET_ARCH ]]
      then
        local _PZC_CMAKE_GPU_ARCH="\"CMAKE_CUDA_ARCHITECTURES\": \"${PZC_GPU_TARGET_ARCH}\","
      fi

    else
      local _PZC_ARCANE_ACCELERATOR_MODE="\"ARCANE_ACCELERATOR_MODE\": \"SYCL\","
      local _PZC_CMAKE_GPU_COMPILER="\"CMAKE_SYCL_COMPILER\": \"${PZC_GPU_COMPILER}\","
      if [[ -v PZC_GPU_FLAGS ]]
      then
        local _PZC_CMAKE_GPU_FLAGS="\"ARCANE_CXX_SYCL_FLAGS\": \"${PZC_GPU_FLAGS}\","
      fi
    fi
    local _PZC_TEMPLATE_PRESET_PATH="${PZC_PZC_DIR}/progs/cmake/preset_templates/${_PZC_TEMPLATE_NAME}_gpu.json.in"
  fi

  sed -e "s|@TYPE_BUILD_DIR@|${TYPE_BUILD_DIR}|g" \
      -e "s|@PROJECT_NAME@|${CMP_PROJECT_NAME}|g" \
      -e "s|@CMP_SOURCE_DIR@|${CMP_SOURCE_DIR}|g" \
      -e "s|@CMP_BUILD_DIR@|${CMP_BUILD_DIR}|g" \
      -e "s|@CMP_INSTALL_DIR@|${CMP_INSTALL_DIR}|g" \
      -e "s|@PZC_CMAKE_GENERATOR@|${PZC_CMAKE_GENERATOR}|g" \
      -e "s|@PZC_CMAKE_CXX_COMPILER_LAUNCHER@|${PZC_CMAKE_CXX_COMPILER_LAUNCHER}|g" \
      -e "s|@PZC_CMAKE_C_COMPILER_LAUNCHER@|${PZC_CMAKE_C_COMPILER_LAUNCHER}|g" \
      -e "s|@PZC_CMAKE_LINKER_TYPE@|${PZC_CMAKE_LINKER_TYPE}|g" \
      -e "s|@_PZC_ARCANE_ACCELERATOR_MODE@|${_PZC_ARCANE_ACCELERATOR_MODE}|g" \
      -e "s|@_PZC_CMAKE_GPU_COMPILER@|${_PZC_CMAKE_GPU_COMPILER}|g" \
      -e "s|@_PZC_CMAKE_GPU_FLAGS@|${_PZC_CMAKE_GPU_FLAGS}|g" \
      -e "s|@_PZC_CMAKE_GPU_ARCH@|${_PZC_CMAKE_GPU_ARCH}|g" \
      -e "s|@PZC_C_COMPILER@|${PZC_C_COMPILER}|g" \
      -e "s|@PZC_CXX_COMPILER@|${PZC_CXX_COMPILER}|g" \
      -e "s|@PZC_GPU_HOST_COMPILER@|${PZC_GPU_HOST_COMPILER}|g" \
      -e "s|@CMP_BUILD_TYPE@|${CMP_BUILD_TYPE}|g" \
      -e "s|@PZC_CMAKE_BUILD_TYPE@|${PZC_CMAKE_BUILD_TYPE}|g" \
      -e "s|@ARCANE_INSTALL_DIR@|${ARCANE_INSTALL_DIR}|g" \
      ${_PZC_TEMPLATE_PRESET_PATH} > "${_PZC_TMP_PRESET_PATH}"
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
    _pzc_info "Initialize CMake Project: ${1}"
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
    TYPE_BUILD_DIR=${CMP_BUILD_TYPE}_${3}
  else
    TYPE_BUILD_DIR=${CMP_BUILD_TYPE}
  fi

  local _PZC_SAVED_PRESET_PATH="${PZC_EDIT_SCRIPTS}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ -e ${_PZC_SAVED_PRESET_PATH} ]]
  then
    _pzc_info "The edit script exist. Overwrite default initialization."
    CMP_SOURCE_DIR=$(jq -r '.vendor.pzc.cmpSourceDir' ${_PZC_SAVED_PRESET_PATH})
    CMP_BUILD_DIR=$(jq -r '.vendor.pzc.cmpBuildDir' ${_PZC_SAVED_PRESET_PATH})
    CMP_INSTALL_DIR=$(jq -r '.vendor.pzc.cmpInstallDir' ${_PZC_SAVED_PRESET_PATH})

    if [[ ${CMP_PROJECT_TYPE} = 3 ]]
    then
      ARCANE_INSTALL_DIR=$(jq -r '.vendor.pzc.cmpArcaneInstallDir' ${_PZC_SAVED_PRESET_PATH})
    fi

    if [[ ${CMP_SOURCE_DIR} == "null" ]]
    then
      _pzc_error "Invalid saved preset, check vendor part (${_PZC_SAVED_PRESET_PATH}). Remove it to regenerate correct preset."
      return 2
    fi

  else
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
  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    return 2
  fi


  _pzc_info "Generation of CMakeUserPresets.json in ${CMP_PROJECT_NAME} source..."
  echo "{\"version\": 4,\"include\": [\"${_PZC_TMP_PRESET_PATH}\"]}" > "${CMP_SOURCE_DIR}/CMakeUserPresets.json"


  _pzc_info "Use build preset (${_PZC_TMP_PRESET_PATH})."

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
