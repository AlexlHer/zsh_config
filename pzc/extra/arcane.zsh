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
## $ cd ${ARCANE_BUILD_DIR_PATH}
##
## Install dir:
## $ cd ${ARCANE_INSTALL_DIR}


# ---------------------------------------------------------------
# -------------------------- Aliases ----------------------------
# ---------------------------------------------------------------

alias clonearc='_pzc_coal_eval "mkdir -p ${WORK_DIR}/arcane" ; \
                _pzc_coal_eval "cd ${WORK_DIR}/arcane" ; \
                _pzc_coal_eval "git clone --recurse-submodules https://github.com/arcaneframework/framework" ; \
                gitarc'

function gitarc()
{
  local ARCANE_SOURCE_DIR_PATH="${WORK_DIR}/arcane/framework"
  if [[ -v 1 ]]
  then
    # TODO : Regex
    if [[ ${1} == "1" ]]
    then
      ARCANE_SOURCE_DIR_PATH="${WORK_DIR}/arcane/framework_wt1"
    else
      ARCANE_SOURCE_DIR_PATH="${WORK_DIR}/arcane/framework_${1}"
    fi
  fi
  _pzc_coal_eval "cd ${ARCANE_SOURCE_DIR_PATH}"
}



# ---------------------------------------------------------------
# ----------------------- Init functions ------------------------
# ---------------------------------------------------------------

function parc()
{
  if [[ ! -v ARCANE_SOURCE_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  local _PZC_SAVED_PRESET_PATH="${PZC_EDIT_SCRIPTS}/${ARCANE_SOURCE_DIR}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_PRESET_PATH="${ARCANE_BUILD_DIR_PATH}/${ARCANE_SOURCE_DIR}_${TYPE_BUILD_DIR}.json"

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

  local _PZC_TEMPLATE_PRESET_PATH="${PZC_PZC_DIR}/progs/cmake/preset_templates/framework.json.in"

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
    local _PZC_TEMPLATE_PRESET_PATH="${PZC_PZC_DIR}/progs/cmake/preset_templates/framework_gpu.json.in"
  fi
  if [[ "${ARCANE_TYPE_BUILD}" == "Check" ]]
  then
    local _PZC_CMAKE_BUILD_TYPE="RelWithDebInfo"
  else
    local _PZC_CMAKE_BUILD_TYPE="${ARCANE_TYPE_BUILD}"
  fi

  sed -e "s|@TYPE_BUILD_DIR@|${TYPE_BUILD_DIR}|g" \
      -e "s|@BUILD_DIR_PATH@|${ARCANE_BUILD_DIR_PATH}|g" \
      -e "s|@INSTALL_DIR_PATH@|${ARCANE_INSTALL_DIR_PATH}|g" \
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
      -e "s|@ARCANE_TYPE_BUILD@|${ARCANE_TYPE_BUILD}|g" \
      -e "s|@_PZC_CMAKE_BUILD_TYPE@|${_PZC_CMAKE_BUILD_TYPE}|g" \
      ${_PZC_TEMPLATE_PRESET_PATH} > "${_PZC_TMP_PRESET_PATH}"

}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function pap()
{
  if [[ ! -v AP_SOURCE_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1
  fi

  local _PZC_SAVED_PRESET_PATH="${PZC_EDIT_SCRIPTS}/${AP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_PRESET_PATH="${AP_BUILD_DIR_PATH}/${AP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

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

  local _PZC_TEMPLATE_PRESET_PATH="${PZC_PZC_DIR}/progs/cmake/preset_templates/arcane_project.json.in"

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
      if [[ -v PZC_GPU_FLAGS ]]
      then
        local _PZC_CMAKE_GPU_FLAGS="\"ARCANE_CXX_SYCL_FLAGS\": \"${PZC_GPU_FLAGS}\","
      fi
    fi
    local _PZC_TEMPLATE_PRESET_PATH="${PZC_PZC_DIR}/progs/cmake/preset_templates/arcane_project_gpu.json.in"
  fi
  if [[ "${AP_BUILD_TYPE}" == "Check" ]]
  then
    local _PZC_CMAKE_BUILD_TYPE="RelWithDebInfo"
  else
    local _PZC_CMAKE_BUILD_TYPE="${AP_BUILD_TYPE}"
  fi

  sed -e "s|@TYPE_BUILD_DIR@|${TYPE_BUILD_DIR}|g" \
      -e "s|@PROJECT_NAME@|${AP_PROJECT_NAME}|g" \
      -e "s|@BUILD_DIR_PATH@|${AP_BUILD_DIR_PATH}|g" \
      -e "s|@INSTALL_DIR_PATH@|${AP_INSTALL_DIR_PATH}|g" \
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
      -e "s|@ARCANE_INSTALL_DIR_PATH@|${ARCANE_INSTALL_DIR_PATH}|g" \
      -e "s|@_PZC_CMAKE_BUILD_TYPE@|${_PZC_CMAKE_BUILD_TYPE}|g" \
      ${_PZC_TEMPLATE_PRESET_PATH} > "${_PZC_TMP_PRESET_PATH}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function initarc()
{
  _pzc_pensil_begin

  if [[ -v 1 ]]
  then
    if [[ ${1} == "D" ]] || [[ ${1} == "Debug" ]]
    then
      _pzc_ecal_eval "ARCANE_TYPE_BUILD=Debug"
    elif [[ ${1} == "C" ]] || [[ ${1} == "Check" ]]
    then
      _pzc_ecal_eval "ARCANE_TYPE_BUILD=Check"
    elif [[ ${1} == "R" ]] || [[ ${1} == "Release" ]]
    then
      _pzc_ecal_eval "ARCANE_TYPE_BUILD=Release"
    else
      _pzc_pensil_end
      _pzc_error "Invalid 'ARCANE_TYPE_BUILD' [D or C or R] (first arg)."
      return 1
    fi
  else
    _pzc_info "No argument, defining 'ARCANE_TYPE_BUILD' to 'Release'..."
    _pzc_ecal_eval "ARCANE_TYPE_BUILD=Release"
  fi

  if [[ -v 2 ]] && [[ ${2} != "_" ]] && [[ ${2} != "none" ]]
  then
    _pzc_ecal_eval "TYPE_BUILD_DIR=${ARCANE_TYPE_BUILD}_${2}"
  else
    _pzc_ecal_eval "TYPE_BUILD_DIR=${ARCANE_TYPE_BUILD}"
  fi

  if [[ -v 3 ]] && [[ ${3} != "_" ]] && [[ ${3} != "none" ]]
  then
    ARCANE_SOURCE_DIR=framework_${3}
  else
    ARCANE_SOURCE_DIR=framework
  fi

  _pzc_ecal_eval "ARCANE_SOURCE_DIR_PATH=${WORK_DIR}/arcane/${ARCANE_SOURCE_DIR}"
  _pzc_ecal_eval "ARCANE_BUILD_DIR_PATH=${BUILD_DIR}/build_${ARCANE_SOURCE_DIR}/${TYPE_BUILD_DIR}"
  _pzc_ecal_eval "ARCANE_INSTALL_DIR_PATH=${INSTALL_DIR}/install_${ARCANE_SOURCE_DIR}/${TYPE_BUILD_DIR}"
  echo ""
  _pzc_ecal_eval "mkdir -p ${ARCANE_BUILD_DIR_PATH}"
  _pzc_ecal_eval "mkdir -p ${ARCANE_INSTALL_DIR_PATH}"
  echo ""
  _pzc_ecal_eval "cd ${ARCANE_BUILD_DIR_PATH}"
  _pzc_pensil_end
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function initap()
{
  if [[ -v 1 ]]
  then
    _pzc_info "Initialize Arcane Project: ${1}"
    AP_PROJECT_NAME=${1}
  else
    _pzc_error "Need project name (first arg)"
    return 1
  fi

  if [[ -v 2 ]] && [[ ${2} != "_" ]] && [[ ${2} != "none" ]]
  then
    if [[ ${2} == "D" ]] || [[ ${2} == "Debug" ]]
    then
      ARCANE_TYPE_BUILD=Debug
    elif [[ ${2} == "C" ]] || [[ ${2} == "Check" ]]
    then
      ARCANE_TYPE_BUILD=Check
    elif [[ ${2} == "R" ]] || [[ ${2} == "Release" ]]
    then
      ARCANE_TYPE_BUILD=Release
    else
      _pzc_error "Invalid 'ARCANE_TYPE_BUILD' (second arg)"
      return 1
    fi
  else
    _pzc_info "No argument, defining 'ARCANE_TYPE_BUILD' to 'Release'"
    ARCANE_TYPE_BUILD=Release
  fi

  if [[ -v 3 ]] && [[ ${3} != "_" ]] && [[ ${3} != "none" ]]
  then
    TYPE_BUILD_DIR=${ARCANE_TYPE_BUILD}_${3}
  else
    TYPE_BUILD_DIR=${ARCANE_TYPE_BUILD}
  fi

  local _PZC_EDIT_AP_PATH="${PZC_EDIT_SCRIPTS}/editap_${AP_PROJECT_NAME}_${TYPE_BUILD_DIR}.zsh"

  if [[ -e ${_PZC_EDIT_AP_PATH} ]]
  then
    _pzc_info "The edit script exist. Overwrite default initialization."
    _pzc_coal_eval "source ${_PZC_EDIT_AP_PATH}"

  else
    ARCANE_INSTALL_DIR_PATH="${INSTALL_DIR}/install_framework/${TYPE_BUILD_DIR}"
    AP_BUILD_TYPE="${ARCANE_TYPE_BUILD}"
    AP_PROJECT_DIR_PATH="${WORK_DIR}/${AP_PROJECT_NAME}"
    AP_SOURCE_DIR_PATH="${AP_PROJECT_DIR_PATH}"
    AP_BUILD_DIR_PATH="${BUILD_DIR}/build_${AP_PROJECT_NAME}/${TYPE_BUILD_DIR}"
    AP_INSTALL_DIR_PATH="${INSTALL_DIR}/install_${AP_PROJECT_NAME}/${TYPE_BUILD_DIR}"
  fi

  mkdir -p "${AP_BUILD_DIR_PATH}"
  cd "${AP_BUILD_DIR_PATH}"

  _pzc_pensil_begin
  echo "AP_PROJECT_NAME=${AP_PROJECT_NAME}"
  echo "ARCANE_TYPE_BUILD=${ARCANE_TYPE_BUILD}"
  echo "TYPE_BUILD_DIR=${TYPE_BUILD_DIR}"
  echo ""
  echo "ARCANE_INSTALL_DIR_PATH=${ARCANE_INSTALL_DIR_PATH}"
  echo ""
  echo "AP_BUILD_TYPE=${AP_BUILD_TYPE}"
  echo "AP_PROJECT_DIR_PATH=${AP_PROJECT_DIR_PATH}"
  echo "AP_SOURCE_DIR_PATH=${AP_SOURCE_DIR_PATH}"
  echo "AP_BUILD_DIR_PATH=${AP_BUILD_DIR_PATH}"
  echo "AP_INSTALL_DIR_PATH=${AP_INSTALL_DIR_PATH}"
  echo ""
  echo "mkdir -p ${AP_BUILD_DIR_PATH}"
  echo "cd ${AP_BUILD_DIR_PATH}"
  _pzc_pensil_end
}



# ---------------------------------------------------------------
# -------------------- Edit init functions ----------------------
# ---------------------------------------------------------------

function editap()
{
  if [[ ! -v AP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1
  fi

  _pzc_info "Edit initialization of Arcane Project: ${AP_PROJECT_NAME}"
  _pzc_info "Type of build to edit: ${ARCANE_TYPE_BUILD}"
  _pzc_info "Subdir build to edit: ${TYPE_BUILD_DIR}"

  local _PZC_EDIT_AP_PATH="${PZC_EDIT_SCRIPTS}/editap_${AP_PROJECT_NAME}_${TYPE_BUILD_DIR}.zsh"

  _pzc_info "Location of the edit script: ${_PZC_EDIT_AP_PATH}"


  if [[ -e ${_PZC_EDIT_AP_PATH} ]]
  then
    _pzc_info "The edit script exist. Editing it..."
    _pzc_coal_eval "${PZC_FILE_EDITOR} ${_PZC_EDIT_AP_PATH}"

  else
    _pzc_coal_eval "touch ${_PZC_EDIT_AP_PATH}"

    _pzc_info "Creating the edit script..."

    echo "# Custom initialisation for the Arcane project: ${AP_PROJECT_NAME}" >> ${_PZC_EDIT_AP_PATH}
    echo "# Type of build: ${ARCANE_TYPE_BUILD}" >> ${_PZC_EDIT_AP_PATH}
    echo "# Subdir of build: ${TYPE_BUILD_DIR}\n" >> ${_PZC_EDIT_AP_PATH}

    echo "# Arcane install path:" >> ${_PZC_EDIT_AP_PATH}
    echo "ARCANE_INSTALL_DIR_PATH=${INSTALL_DIR}/install_framework/${TYPE_BUILD_DIR}\n" >> ${_PZC_EDIT_AP_PATH}

    echo "# Type of build for this project:" >> ${_PZC_EDIT_AP_PATH}
    echo "AP_BUILD_TYPE=${ARCANE_TYPE_BUILD}\n" >> ${_PZC_EDIT_AP_PATH}

    echo "# Directory with the project:" >> ${_PZC_EDIT_AP_PATH}
    echo "AP_PROJECT_DIR_PATH=${WORK_DIR}/${AP_PROJECT_NAME}\n" >> ${_PZC_EDIT_AP_PATH}

    echo "# Directory with the project source (with the CMakeLists.txt file):" >> ${_PZC_EDIT_AP_PATH}
    echo "AP_SOURCE_DIR_PATH=${AP_PROJECT_DIR_PATH}\n" >> ${_PZC_EDIT_AP_PATH}

    echo "# Directory needed for the project build:" >> ${_PZC_EDIT_AP_PATH}
    echo "AP_BUILD_DIR_PATH=${BUILD_DIR}/build_${AP_PROJECT_NAME}/${TYPE_BUILD_DIR}\n" >> ${_PZC_EDIT_AP_PATH}

    echo "# Directory where install the project:" >> ${_PZC_EDIT_AP_PATH}
    echo "AP_INSTALL_DIR_PATH=${INSTALL_DIR}/install_${AP_PROJECT_NAME}/${TYPE_BUILD_DIR}\n" >> ${_PZC_EDIT_AP_PATH}

    _pzc_coal_eval "${PZC_FILE_EDITOR} ${_PZC_EDIT_AP_PATH}"
  fi

  echo ""
  _pzc_coal_eval "initap ${AP_PROJECT_NAME} ${ARCANE_TYPE_BUILD} ${TYPE_BUILD_DIR}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function editaprm()
{
  if [[ ! -v AP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1
  fi

  _pzc_info "Remove initialization script of Arcane Project: ${AP_PROJECT_NAME}"
  _pzc_info "Type of build to remove: ${ARCANE_TYPE_BUILD}"
  _pzc_info "Subdir build to remove: ${TYPE_BUILD_DIR}"


  local _PZC_EDIT_AP_PATH="${PZC_EDIT_SCRIPTS}/editap_${AP_PROJECT_NAME}_${TYPE_BUILD_DIR}.zsh"

  _pzc_info "Location of the script: ${_PZC_EDIT_AP_PATH}"

  if [[ -e ${_PZC_EDIT_AP_PATH} ]]
  then
    _pzc_info "The edit script exist."

    local _PZC_TDIR=$(mktemp -d --tmpdir=${TMP_DIR})
    _pzc_info "Moving ${_PZC_EDIT_AP_PATH} file in ${_PZC_TDIR} directory..."

    mv ${_PZC_EDIT_AP_PATH} ${_PZC_TDIR}

    echo ""
    _pzc_coal_eval "initap ${AP_PROJECT_NAME} ${ARCANE_TYPE_BUILD} ${TYPE_BUILD_DIR}"

  else
    _pzc_warning "The edit script doesn't exist."
    return 1
  fi
}



# ---------------------------------------------------------------
# -------------------- Edit preset functions --------------------
# ---------------------------------------------------------------

function editparc()
{
  if [[ ! -v ARCANE_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  local _PZC_TMP_PRESET_PATH="${ARCANE_BUILD_DIR_PATH}/${ARCANE_SOURCE_DIR}_${TYPE_BUILD_DIR}.json"

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
  if [[ ! -v AP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1
  fi

  local _PZC_TMP_PRESET_PATH="${AP_BUILD_DIR_PATH}/${AP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

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
  if [[ ! -v ARCANE_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  local _PZC_SAVED_PRESET_PATH="${PZC_EDIT_SCRIPTS}/${ARCANE_SOURCE_DIR}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_PRESET_PATH="${ARCANE_BUILD_DIR_PATH}/${ARCANE_SOURCE_DIR}_${TYPE_BUILD_DIR}.json"

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
  if [[ ! -v AP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1
  fi

  local _PZC_SAVED_PRESET_PATH="${PZC_EDIT_SCRIPTS}/${AP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_PRESET_PATH="${AP_BUILD_DIR_PATH}/${AP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

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
  if [[ ! -v ARCANE_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  _pzc_info "Configure Arcane Framework..."

  local _PZC_TMP_PRESET_PATH="${ARCANE_BUILD_DIR_PATH}/${ARCANE_SOURCE_DIR}_${TYPE_BUILD_DIR}.json"

  _pzc_info "Generation of CMakeUserPresets.json in Arcane source..."
  echo "{\"version\": 4,\"include\": [\"${_PZC_TMP_PRESET_PATH}\"]}" > "${ARCANE_SOURCE_DIR_PATH}/CMakeUserPresets.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    parc
  fi
  
  _pzc_info "Use build preset (${_PZC_TMP_PRESET_PATH})."

  _pzc_pensil_begin

  echo "cmake \\"
  echo "  -S ${ARCANE_SOURCE_DIR_PATH} \\"
  echo "  --preset ${TYPE_BUILD_DIR}"

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    echo "chmod u+x ${ARCANE_BUILD_DIR_PATH}/bin/*"
  fi

  _pzc_pensil_end


  cmake \
    -S ${ARCANE_SOURCE_DIR_PATH} \
    --preset "${TYPE_BUILD_DIR}"

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x "${ARCANE_BUILD_DIR_PATH}/bin/*"
  fi
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function configarcgpu()
{
  if [[ ! -v ARCANE_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  _pzc_info "Configure Arcane Framework GPU..."

  local _PZC_TMP_PRESET_PATH="${ARCANE_BUILD_DIR_PATH}/${ARCANE_SOURCE_DIR}_${TYPE_BUILD_DIR}.json"

  _pzc_info "Generation of CMakeUserPresets.json in Arcane source..."
  echo "{\"version\": 4,\"include\": [\"${_PZC_TMP_PRESET_PATH}\"]}" > "${ARCANE_SOURCE_DIR_PATH}/CMakeUserPresets.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    parc
  fi

  _pzc_info "Use build preset (${_PZC_TMP_PRESET_PATH})."

  _pzc_pensil_begin

  echo "cmake \\"
  echo "  -S ${ARCANE_SOURCE_DIR_PATH} \\"
  echo "  --preset ${TYPE_BUILD_DIR}_gpu"

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    echo "chmod u+x ${ARCANE_BUILD_DIR_PATH}/bin/*"
  fi

  _pzc_pensil_end


  cmake \
    -S ${ARCANE_SOURCE_DIR_PATH} \
    --preset "${TYPE_BUILD_DIR}_gpu"

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x "${ARCANE_BUILD_DIR_PATH}/bin/*"
  fi
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function configap()
{
  if [[ ! -v AP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1
  fi

  _pzc_info "Configure Arcane Project: ${AP_PROJECT_NAME}..."

  local _PZC_TMP_PRESET_PATH="${AP_BUILD_DIR_PATH}/${AP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  _pzc_info "Generation of CMakeUserPresets.json in ${AP_PROJECT_NAME} source..."
  echo "{\"version\": 4,\"include\": [\"${_PZC_TMP_PRESET_PATH}\"]}" > "${AP_SOURCE_DIR_PATH}/CMakeUserPresets.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    pap
  fi
  
  _pzc_info "Use build preset (${_PZC_TMP_PRESET_PATH})."

  _pzc_pensil_begin

  echo "cmake \\"
  echo "  -S ${AP_SOURCE_DIR_PATH} \\"
  echo "  --preset ${TYPE_BUILD_DIR}"

  _pzc_pensil_end


  cmake \
    -S ${AP_SOURCE_DIR_PATH} \
    --preset "${TYPE_BUILD_DIR}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function configapgpu()
{
  if [[ ! -v AP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1
  fi

  _pzc_info "Configure Arcane Project GPU: ${AP_PROJECT_NAME}..."

  local _PZC_TMP_PRESET_PATH="${AP_BUILD_DIR_PATH}/${AP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  _pzc_info "Generation of CMakeUserPresets.json in ${AP_PROJECT_NAME} source..."
  echo "{\"version\": 4,\"include\": [\"${_PZC_TMP_PRESET_PATH}\"]}" > "${AP_SOURCE_DIR_PATH}/CMakeUserPresets.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    pap
  fi
  
  _pzc_info "Use build preset (${_PZC_TMP_PRESET_PATH})."

  _pzc_pensil_begin

  echo "cmake \\"
  echo "  -S ${AP_SOURCE_DIR_PATH} \\"
  echo "  --preset ${TYPE_BUILD_DIR}_gpu"

  _pzc_pensil_end


  cmake \
    -S ${AP_SOURCE_DIR_PATH} \
    --preset "${TYPE_BUILD_DIR}_gpu"
}



# ---------------------------------------------------------------
# ------------------- Build/Install functions -------------------
# ---------------------------------------------------------------

function biarc()
{
  if [[ ! -v ARCANE_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x ${ARCANE_BUILD_DIR_PATH}/bin/*
  fi
  cmake --build ${ARCANE_BUILD_DIR_PATH} --target install
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function docarc()
{
  if [[ ! -v ARCANE_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x ${ARCANE_BUILD_DIR_PATH}/bin/*
  fi
  cmake --build ${ARCANE_BUILD_DIR_PATH}
  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x ${ARCANE_BUILD_DIR_PATH}/bin/*
  fi
  cmake --build ${ARCANE_BUILD_DIR_PATH} --target ${1}doc
}



# ---------------------------------------------------------------
# ----------------------- Clear functions -----------------------
# ---------------------------------------------------------------

function cleararc()
{
  if [[ ! -v ARCANE_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi
  
  _pzc_pensil_begin
  _pzc_ecal_eval "cd ${ARCANE_BUILD_DIR_PATH}/.."
  _pzc_ecal_eval "rm -r ${ARCANE_BUILD_DIR_PATH}"
  _pzc_ecal_eval "rm -r ${ARCANE_INSTALL_DIR_PATH}"
  _pzc_ecal_eval "mkdir ${ARCANE_BUILD_DIR_PATH}"
  _pzc_ecal_eval "mkdir ${ARCANE_INSTALL_DIR_PATH}"
  _pzc_ecal_eval "cd ${ARCANE_BUILD_DIR_PATH}"
  _pzc_pensil_end
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function clearap()
{
  if [[ ! -v AP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1
  fi

  _pzc_pensil_begin
  _pzc_ecal_eval "cd ${AP_BUILD_DIR_PATH}/.."
  _pzc_ecal_eval "rm -r ${AP_BUILD_DIR_PATH}"
  _pzc_ecal_eval "rm -r ${AP_INSTALL_DIR_PATH}"
  _pzc_ecal_eval "mkdir ${AP_BUILD_DIR_PATH}"
  _pzc_ecal_eval "mkdir ${AP_INSTALL_DIR_PATH}"
  _pzc_ecal_eval "cd ${AP_BUILD_DIR_PATH}"
  _pzc_pensil_end
}
