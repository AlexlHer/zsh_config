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
# --------------- Create folder for init scripts ----------------
# ---------------------------------------------------------------

export PZC_EDIT_SCRIPTS=${PZC_USER_CONFIG_DIR}/cmake_scripts
mkdir -p ${PZC_EDIT_SCRIPTS}



# ---------------------------------------------------------------
# ----------------------- Init functions ------------------------
# ---------------------------------------------------------------

function pcmp()
{
  if [[ ! -v CMP_SOURCE_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initcmp' command before."
    return 1
  fi

  local _PZC_SAVED_PRESET_PATH="${PZC_EDIT_SCRIPTS}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR_PATH}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

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

  local _PZC_TEMPLATE_PRESET_PATH="${PZC_PZC_DIR}/progs/cmake/preset_templates/generic.json.in"

  if [[ ${PZC_GPU_AVAILABLE} = 1 ]]
  then
    if [[ "${PZC_GPU_DEFAULT_COMPILER}" == "NVCC" ]]
    then
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
      local _PZC_CMAKE_GPU_COMPILER="\"CMAKE_SYCL_COMPILER\": \"${PZC_GPU_COMPILER}\","
    fi
    local _PZC_TEMPLATE_PRESET_PATH="${PZC_PZC_DIR}/progs/cmake/preset_templates/generic_gpu.json.in"
  fi

  if [[ "${CMP_BUILD_TYPE}" == "Check" ]]
  then
    local _PZC_CMAKE_BUILD_TYPE="RelWithDebInfo"
  else
    local _PZC_CMAKE_BUILD_TYPE="${CMP_BUILD_TYPE}"
  fi

  sed -e "s|@TYPE_BUILD_DIR@|${TYPE_BUILD_DIR}|g" \
      -e "s|@PROJECT_NAME@|${CMP_PROJECT_NAME}|g" \
      -e "s|@CMP_BUILD_DIR_PATH@|${CMP_BUILD_DIR_PATH}|g" \
      -e "s|@CMP_INSTALL_DIR_PATH@|${CMP_INSTALL_DIR_PATH}|g" \
      -e "s|@PZC_CMAKE_GENERATOR@|${PZC_CMAKE_GENERATOR}|g" \
      -e "s|@PZC_CMAKE_CXX_COMPILER_LAUNCHER@|${PZC_CMAKE_CXX_COMPILER_LAUNCHER}|g" \
      -e "s|@PZC_CMAKE_C_COMPILER_LAUNCHER@|${PZC_CMAKE_C_COMPILER_LAUNCHER}|g" \
      -e "s|@PZC_CMAKE_LINKER_TYPE@|${PZC_CMAKE_LINKER_TYPE}|g" \
      -e "s|@_PZC_CMAKE_GPU_COMPILER@|${_PZC_CMAKE_GPU_COMPILER}|g" \
      -e "s|@_PZC_CMAKE_GPU_FLAGS@|${_PZC_CMAKE_GPU_FLAGS}|g" \
      -e "s|@_PZC_CMAKE_GPU_ARCH@|${_PZC_CMAKE_GPU_ARCH}|g" \
      -e "s|@PZC_C_COMPILER@|${PZC_C_COMPILER}|g" \
      -e "s|@PZC_CXX_COMPILER@|${PZC_CXX_COMPILER}|g" \
      -e "s|@PZC_GPU_HOST_COMPILER@|${PZC_GPU_HOST_COMPILER}|g" \
      -e "s|@_PZC_CMAKE_BUILD_TYPE@|${_PZC_CMAKE_BUILD_TYPE}|g" \
      ${_PZC_TEMPLATE_PRESET_PATH} > "${_PZC_TMP_PRESET_PATH}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function _pzc_common_initcmp()
{
  if [[ -v 2 ]]
  then
    _pzc_info "Initialize CMake Project: ${2}"
    CMP_PROJECT_NAME=${2}
  else
    _pzc_error "Need project name (first arg)"
    return 1
  fi

  if [[ -v 3 ]] && [[ ${3} != "_" ]] && [[ ${3} != "none" ]]
  then
    if [[ ${3} == "D" ]] || [[ ${3} == "Debug" ]]
    then
      CMP_BUILD_TYPE=Debug
    elif [[ ${3} == "C" ]] || [[ ${3} == "Check" ]]
    then
      CMP_BUILD_TYPE=Check
    elif [[ ${3} == "R" ]] || [[ ${3} == "Release" ]]
    then
      CMP_BUILD_TYPE=Release
    else
      _pzc_error "Invalid 'CMP_BUILD_TYPE' [D or C or R] (second arg)"
      return 1
    fi
  else
    _pzc_info "No argument, defining 'CMP_BUILD_TYPE' to 'Release'"
    CMP_BUILD_TYPE=Release
  fi

  if [[ -v 4 ]] && [[ ${4} != "_" ]] && [[ ${4} != "none" ]]
  then
    TYPE_BUILD_DIR=${CMP_BUILD_TYPE}_${4}
  else
    TYPE_BUILD_DIR=${CMP_BUILD_TYPE}
  fi

  local _PZC_EDIT_CMP_PATH="${PZC_EDIT_SCRIPTS}/editinit_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.zsh"

  if [[ -e ${_PZC_EDIT_CMP_PATH} ]]
  then
    _pzc_info "The edit script exist. Overwrite default initialization."
    _pzc_coal_eval "source ${_PZC_EDIT_CMP_PATH}"

  else
    if [[ -v 1 ]] && [[ ${1} == "1" ]]
    then
      # Pour compatibilité avec l'existant.
      CMP_PROJECT_DIR_PATH="${WORK_DIR}/arcane/${CMP_PROJECT_NAME}"
    else
      CMP_PROJECT_DIR_PATH="${WORK_DIR}/${CMP_PROJECT_NAME}"
    fi
    CMP_SOURCE_DIR_PATH="${CMP_PROJECT_DIR_PATH}"
    CMP_BUILD_DIR_PATH="${BUILD_DIR}/build_${CMP_PROJECT_NAME}/${TYPE_BUILD_DIR}"
    CMP_INSTALL_DIR_PATH="${INSTALL_DIR}/install_${CMP_PROJECT_NAME}/${TYPE_BUILD_DIR}"
  fi

  mkdir -p "${CMP_BUILD_DIR_PATH}"
  mkdir -p "${CMP_INSTALL_DIR_PATH}"

  cd "${CMP_BUILD_DIR_PATH}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function initcmp()
{
  _pzc_common_initcmp 0 ${1} ${2} ${3}

  _pzc_pensil_begin
  echo "CMP_PROJECT_NAME=${CMP_PROJECT_NAME}"
  echo "TYPE_BUILD_DIR=${TYPE_BUILD_DIR}"
  echo ""
  echo "CMP_BUILD_TYPE=${CMP_BUILD_TYPE}"
  echo "CMP_PROJECT_DIR_PATH=${CMP_PROJECT_DIR_PATH}"
  echo "CMP_SOURCE_DIR_PATH=${CMP_SOURCE_DIR_PATH}"
  echo "CMP_BUILD_DIR_PATH=${CMP_BUILD_DIR_PATH}"
  echo "CMP_INSTALL_DIR_PATH=${CMP_INSTALL_DIR_PATH}"
  echo ""
  echo "mkdir -p ${CMP_BUILD_DIR_PATH}"
  echo "cd ${CMP_BUILD_DIR_PATH}"
  _pzc_pensil_end
}



# ---------------------------------------------------------------
# -------------------- Edit init functions ----------------------
# ---------------------------------------------------------------

function editcmp()
{
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initcmp' command before."
    return 1
  fi

  _pzc_info "Edit initialization of CMake Project: ${CMP_PROJECT_NAME}"
  _pzc_info "Type of build to edit: ${CMP_BUILD_TYPE}"
  _pzc_info "Subdir build to edit: ${TYPE_BUILD_DIR}"

  local _PZC_EDIT_CMP_PATH="${PZC_EDIT_SCRIPTS}/editcmp_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.zsh"

  _pzc_info "Location of the edit script: ${_PZC_EDIT_CMP_PATH}"


  if [[ -e ${_PZC_EDIT_CMP_PATH} ]]
  then
    _pzc_info "The edit script exist. Editing it..."
    _pzc_coal_eval "${PZC_FILE_EDITOR} ${_PZC_EDIT_CMP_PATH}"

  else
    _pzc_coal_eval "touch ${_PZC_EDIT_CMP_PATH}"

    _pzc_info "Creating the edit script..."

    echo "# Custom initialisation for the CMake project: ${CMP_PROJECT_NAME}" >> ${_PZC_EDIT_CMP_PATH}
    echo "# Type of build: ${CMP_BUILD_TYPE}" >> ${_PZC_EDIT_CMP_PATH}
    echo "# Subdir of build: ${TYPE_BUILD_DIR}\n" >> ${_PZC_EDIT_CMP_PATH}

    echo "# Type of build for this project:" >> ${_PZC_EDIT_CMP_PATH}
    echo "CMP_BUILD_TYPE=${CMP_BUILD_TYPE}\n" >> ${_PZC_EDIT_CMP_PATH}

    echo "# Directory with the project:" >> ${_PZC_EDIT_CMP_PATH}
    echo "CMP_PROJECT_DIR_PATH=${WORK_DIR}/${CMP_PROJECT_NAME}\n" >> ${_PZC_EDIT_CMP_PATH}

    echo "# Directory with the project source (with the CMakeLists.txt file):" >> ${_PZC_EDIT_CMP_PATH}
    echo "CMP_SOURCE_DIR_PATH=${CMP_PROJECT_DIR_PATH}\n" >> ${_PZC_EDIT_CMP_PATH}

    echo "# Directory needed for the project build:" >> ${_PZC_EDIT_CMP_PATH}
    echo "CMP_BUILD_DIR_PATH=${BUILD_DIR}/build_${CMP_PROJECT_NAME}/${TYPE_BUILD_DIR}\n" >> ${_PZC_EDIT_CMP_PATH}

    echo "# Directory where install the project:" >> ${_PZC_EDIT_CMP_PATH}
    echo "CMP_INSTALL_DIR_PATH=${INSTALL_DIR}/install_${CMP_PROJECT_NAME}/${TYPE_BUILD_DIR}\n" >> ${_PZC_EDIT_CMP_PATH}

    _pzc_coal_eval "${PZC_FILE_EDITOR} ${_PZC_EDIT_CMP_PATH}"
  fi

  echo ""
  _pzc_coal_eval "initcmp ${CMP_PROJECT_NAME} ${CMP_BUILD_TYPE} ${TYPE_BUILD_DIR}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function editcmprm()
{
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initcmp' command before."
    return 1
  fi

  _pzc_info "Remove initialization script of CMake Project: ${CMP_PROJECT_NAME}"
  _pzc_info "Type of build to remove: ${CMP_BUILD_TYPE}"
  _pzc_info "Subdir build to remove: ${TYPE_BUILD_DIR}"


  local _PZC_EDIT_CMP_PATH="${PZC_EDIT_SCRIPTS}/editcmp_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.zsh"

  _pzc_info "Location of the script: ${_PZC_EDIT_CMP_PATH}"

  if [[ -e ${_PZC_EDIT_CMP_PATH} ]]
  then
    _pzc_info "The edit script exist."

    local _PZC_TDIR=$(mktemp -d --tmpdir=${TMP_DIR})
    _pzc_info "Moving ${_PZC_EDIT_CMP_PATH} file in ${_PZC_TDIR} directory..."

    mv ${_PZC_EDIT_CMP_PATH} ${_PZC_TDIR}

    echo ""
    _pzc_coal_eval "initcmp ${CMP_PROJECT_NAME} ${CMP_BUILD_TYPE} ${TYPE_BUILD_DIR}"

  else
    _pzc_warning "The edit script doesn't exist."
    return 1
  fi
}



# ---------------------------------------------------------------
# -------------------- Edit preset functions --------------------
# ---------------------------------------------------------------

function editpcmp()
{
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initcmp' command before."
    return 1
  fi

  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR_PATH}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

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
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initcmp' command before."
    return 1
  fi

  local _PZC_SAVED_PRESET_PATH="${PZC_EDIT_SCRIPTS}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR_PATH}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

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

function _pzc_common_configcmp()
{
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    # _pzc_error "You need to call 'initcmp' command before."
    return 1
  fi
  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR_PATH}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    # _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    # pcmp
    return 2
  fi


  _pzc_info "Generation of CMakeUserPresets.json in ${CMP_PROJECT_NAME} source..."
  echo "{\"version\": 4,\"include\": [\"${_PZC_TMP_PRESET_PATH}\"]}" > "${CMP_SOURCE_DIR_PATH}/CMakeUserPresets.json"


  _pzc_info "Use build preset (${_PZC_TMP_PRESET_PATH})."

  _pzc_pensil_begin

  echo "cmake \\"
  echo "  -S ${CMP_SOURCE_DIR_PATH} \\"
  echo "  --preset ${TYPE_BUILD_DIR}"

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    echo "chmod u+x ${CMP_BUILD_DIR_PATH}/bin/*"
  fi

  _pzc_pensil_end


  cmake \
    -S ${CMP_SOURCE_DIR_PATH} \
    --preset "${TYPE_BUILD_DIR}"

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x "${CMP_BUILD_DIR_PATH}/bin/*"
  fi
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function configcmp()
{
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initcmp' command before."
    return 1
  fi

  _pzc_info "Configure CMake Project: ${CMP_PROJECT_NAME}..."

  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR_PATH}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  _pzc_info "Generation of CMakeUserPresets.json in ${CMP_PROJECT_NAME} source..."
  echo "{\"version\": 4,\"include\": [\"${_PZC_TMP_PRESET_PATH}\"]}" > "${CMP_SOURCE_DIR_PATH}/CMakeUserPresets.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    pcmp
  fi

  _pzc_info "Use build preset (${_PZC_TMP_PRESET_PATH})."

  _pzc_pensil_begin

  echo "cmake \\"
  echo "  -S ${CMP_SOURCE_DIR_PATH} \\"
  echo "  --preset ${TYPE_BUILD_DIR}"

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    echo "chmod u+x ${CMP_BUILD_DIR_PATH}/bin/*"
  fi

  _pzc_pensil_end


  cmake \
    -S ${CMP_SOURCE_DIR_PATH} \
    --preset "${TYPE_BUILD_DIR}"

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x "${CMP_BUILD_DIR_PATH}/bin/*"
  fi
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function configcmpgpu()
{
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initcmp' command before."
    return 1
  fi

  _pzc_info "Configure CMake Project GPU: ${CMP_PROJECT_NAME}..."

  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR_PATH}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  _pzc_info "Generation of CMakeUserPresets.json in ${CMP_PROJECT_NAME} source..."
  echo "{\"version\": 4,\"include\": [\"${_PZC_TMP_PRESET_PATH}\"]}" > "${CMP_SOURCE_DIR_PATH}/CMakeUserPresets.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    pcmp
  fi

  _pzc_info "Use build preset (${_PZC_TMP_PRESET_PATH})."

  _pzc_pensil_begin

  echo "cmake \\"
  echo "  -S ${CMP_SOURCE_DIR_PATH} \\"
  echo "  --preset ${TYPE_BUILD_DIR}_gpu"

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    echo "chmod u+x ${CMP_BUILD_DIR_PATH}/bin/*"
  fi

  _pzc_pensil_end


  cmake \
    -S ${CMP_SOURCE_DIR_PATH} \
    --preset "${TYPE_BUILD_DIR}_gpu"

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x "${CMP_BUILD_DIR_PATH}/bin/*"
  fi
}



# ---------------------------------------------------------------
# ----------------------- Clear functions -----------------------
# ---------------------------------------------------------------

clearcmp()
{
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initcmp' command before."
    return 1
  fi

  _pzc_pensil_begin
  _pzc_ecal_eval "cd ${CMP_BUILD_DIR_PATH}/.."
  _pzc_ecal_eval "rm -r ${CMP_BUILD_DIR_PATH}"
  _pzc_ecal_eval "rm -r ${CMP_INSTALL_DIR_PATH}"
  _pzc_ecal_eval "mkdir ${CMP_BUILD_DIR_PATH}"
  _pzc_ecal_eval "mkdir ${CMP_INSTALL_DIR_PATH}"
  _pzc_ecal_eval "cd ${CMP_BUILD_DIR_PATH}"
  _pzc_pensil_end
}
