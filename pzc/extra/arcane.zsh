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
## $ cd ${CMP_BUILD_DIR_PATH}
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
  local CMP_SOURCE_DIR_PATH="${WORK_DIR}/arcane/framework"
  if [[ -v 1 ]]
  then
    # TODO : Regex
    if [[ ${1} == "1" ]]
    then
      CMP_SOURCE_DIR_PATH="${WORK_DIR}/arcane/framework_wt1"
    else
      CMP_SOURCE_DIR_PATH="${WORK_DIR}/arcane/framework_${1}"
    fi
  fi
  _pzc_coal_eval "cd ${CMP_SOURCE_DIR_PATH}"
}



# ---------------------------------------------------------------
# ----------------------- Init functions ------------------------
# ---------------------------------------------------------------

function parc()
{
  if [[ ! -v CMP_SOURCE_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initarc' command before."
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
  if [[ "${CMP_BUILD_TYPE}" == "Check" ]]
  then
    local _PZC_CMAKE_BUILD_TYPE="RelWithDebInfo"
  else
    local _PZC_CMAKE_BUILD_TYPE="${CMP_BUILD_TYPE}"
  fi

  sed -e "s|@TYPE_BUILD_DIR@|${TYPE_BUILD_DIR}|g" \
      -e "s|@CMP_BUILD_DIR_PATH@|${CMP_BUILD_DIR_PATH}|g" \
      -e "s|@CMP_INSTALL_DIR_PATH@|${CMP_INSTALL_DIR_PATH}|g" \
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
      -e "s|@_PZC_CMAKE_BUILD_TYPE@|${_PZC_CMAKE_BUILD_TYPE}|g" \
      ${_PZC_TEMPLATE_PRESET_PATH} > "${_PZC_TMP_PRESET_PATH}"

}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function pap()
{
  if [[ ! -v CMP_SOURCE_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initap' command before."
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
      -e "s|@ARCANE_INSTALL_DIR_PATH@|${ARCANE_INSTALL_DIR_PATH}|g" \
      ${_PZC_TEMPLATE_PRESET_PATH} > "${_PZC_TMP_PRESET_PATH}"
}

# ---------------------------------------------------------------
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
# ---------------------------------------------------------------

function initap()
{
  _pzc_common_initcmp 0 ${1} ${2} ${3}

  if [[ ! -v ARCANE_INSTALL_DIR_PATH ]]
  then
    ARCANE_INSTALL_DIR_PATH="${INSTALL_DIR}/install_framework/${TYPE_BUILD_DIR}"
  fi

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
  echo "ARCANE_INSTALL_DIR_PATH=${ARCANE_INSTALL_DIR_PATH}"
  echo ""
  echo "mkdir -p ${CMP_BUILD_DIR_PATH}"
  echo "cd ${CMP_BUILD_DIR_PATH}"
  _pzc_pensil_end
}



# ---------------------------------------------------------------
# -------------------- Edit init functions ----------------------
# ---------------------------------------------------------------

function editap()
{
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1
  fi

  _pzc_info "Edit initialization of Arcane Project: ${CMP_PROJECT_NAME}"
  _pzc_info "Type of build to edit: ${CMP_BUILD_TYPE}"
  _pzc_info "Subdir build to edit: ${TYPE_BUILD_DIR}"

  local _PZC_EDIT_CMP_PATH="${PZC_EDIT_SCRIPTS}/editinit_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.zsh"

  _pzc_info "Location of the edit script: ${_PZC_EDIT_CMP_PATH}"


  if [[ -e ${_PZC_EDIT_CMP_PATH} ]]
  then
    _pzc_info "The edit script exist. Editing it..."
    _pzc_coal_eval "${PZC_FILE_EDITOR} ${_PZC_EDIT_CMP_PATH}"

  else
    _pzc_coal_eval "touch ${_PZC_EDIT_CMP_PATH}"

    _pzc_info "Creating the edit script..."

    echo "# Custom initialisation for the Arcane project: ${CMP_PROJECT_NAME}" >> ${_PZC_EDIT_CMP_PATH}
    echo "# Type of build: ${CMP_BUILD_TYPE}" >> ${_PZC_EDIT_CMP_PATH}
    echo "# Subdir of build: ${TYPE_BUILD_DIR}\n" >> ${_PZC_EDIT_CMP_PATH}

    echo "# Arcane install path:" >> ${_PZC_EDIT_CMP_PATH}
    echo "ARCANE_INSTALL_DIR_PATH=${INSTALL_DIR}/install_framework/${TYPE_BUILD_DIR}\n" >> ${_PZC_EDIT_CMP_PATH}

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
  _pzc_coal_eval "initap ${CMP_PROJECT_NAME} ${CMP_BUILD_TYPE} ${TYPE_BUILD_DIR}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function editaprm()
{
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1
  fi

  _pzc_info "Remove initialization script of Arcane Project: ${CMP_PROJECT_NAME}"
  _pzc_info "Type of build to remove: ${CMP_BUILD_TYPE}"
  _pzc_info "Subdir build to remove: ${TYPE_BUILD_DIR}"


  local _PZC_EDIT_CMP_PATH="${PZC_EDIT_SCRIPTS}/editinit_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.zsh"

  _pzc_info "Location of the script: ${_PZC_EDIT_CMP_PATH}"

  if [[ -e ${_PZC_EDIT_CMP_PATH} ]]
  then
    _pzc_info "The edit script exist."

    local _PZC_TDIR=$(mktemp -d --tmpdir=${TMP_DIR})
    _pzc_info "Moving ${_PZC_EDIT_CMP_PATH} file in ${_PZC_TDIR} directory..."

    mv ${_PZC_EDIT_CMP_PATH} ${_PZC_TDIR}

    echo ""
    _pzc_coal_eval "initap ${CMP_PROJECT_NAME} ${CMP_BUILD_TYPE} ${TYPE_BUILD_DIR}"

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
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR_PATH}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

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
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1
  fi

  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR_PATH}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

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
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  local _PZC_SAVED_PRESET_PATH="${PZC_EDIT_SCRIPTS}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR_PATH}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

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
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1
  fi

  local _PZC_SAVED_PRESET_PATH="${PZC_EDIT_SCRIPTS}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR_PATH}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

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
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  _pzc_info "Configure Arcane Framework..."

  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR_PATH}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  _pzc_info "Generation of CMakeUserPresets.json in Arcane source..."
  echo "{\"version\": 4,\"include\": [\"${_PZC_TMP_PRESET_PATH}\"]}" > "${CMP_SOURCE_DIR_PATH}/CMakeUserPresets.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    parc
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

function configarcgpu()
{
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  _pzc_info "Configure Arcane Framework GPU..."

  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR_PATH}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  _pzc_info "Generation of CMakeUserPresets.json in Arcane source..."
  echo "{\"version\": 4,\"include\": [\"${_PZC_TMP_PRESET_PATH}\"]}" > "${CMP_SOURCE_DIR_PATH}/CMakeUserPresets.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    parc
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
# ---------------------------------------------------------------

function configap()
{
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1
  fi

  _pzc_info "Configure Arcane Project: ${CMP_PROJECT_NAME}..."

  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR_PATH}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  _pzc_info "Generation of CMakeUserPresets.json in ${CMP_PROJECT_NAME} source..."
  echo "{\"version\": 4,\"include\": [\"${_PZC_TMP_PRESET_PATH}\"]}" > "${CMP_SOURCE_DIR_PATH}/CMakeUserPresets.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    pap
  fi
  
  _pzc_info "Use build preset (${_PZC_TMP_PRESET_PATH})."

  _pzc_pensil_begin

  echo "cmake \\"
  echo "  -S ${CMP_SOURCE_DIR_PATH} \\"
  echo "  --preset ${TYPE_BUILD_DIR}"

  _pzc_pensil_end


  cmake \
    -S ${CMP_SOURCE_DIR_PATH} \
    --preset "${TYPE_BUILD_DIR}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function configapgpu()
{
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initap' command before."
    return 1
  fi

  _pzc_info "Configure Arcane Project GPU: ${CMP_PROJECT_NAME}..."

  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR_PATH}/${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  _pzc_info "Generation of CMakeUserPresets.json in ${CMP_PROJECT_NAME} source..."
  echo "{\"version\": 4,\"include\": [\"${_PZC_TMP_PRESET_PATH}\"]}" > "${CMP_SOURCE_DIR_PATH}/CMakeUserPresets.json"

  if [[ ! -e "${_PZC_TMP_PRESET_PATH}" ]]
  then
    _pzc_info "Build preset not found (${_PZC_TMP_PRESET_PATH}). Generation..."
    pap
  fi
  
  _pzc_info "Use build preset (${_PZC_TMP_PRESET_PATH})."

  _pzc_pensil_begin

  echo "cmake \\"
  echo "  -S ${CMP_SOURCE_DIR_PATH} \\"
  echo "  --preset ${TYPE_BUILD_DIR}_gpu"

  _pzc_pensil_end


  cmake \
    -S ${CMP_SOURCE_DIR_PATH} \
    --preset "${TYPE_BUILD_DIR}_gpu"
}



# ---------------------------------------------------------------
# ------------------- Build/Install functions -------------------
# ---------------------------------------------------------------

function biarc()
{
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x ${CMP_BUILD_DIR_PATH}/bin/*
  fi
  cmake --build ${CMP_BUILD_DIR_PATH} --target install
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function docarc()
{
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x ${CMP_BUILD_DIR_PATH}/bin/*
  fi
  cmake --build ${CMP_BUILD_DIR_PATH}
  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x ${CMP_BUILD_DIR_PATH}/bin/*
  fi
  cmake --build ${CMP_BUILD_DIR_PATH} --target ${1}doc
}



# ---------------------------------------------------------------
# ----------------------- Clear functions -----------------------
# ---------------------------------------------------------------

function cleararc()
{
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initarc' command before."
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

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function clearap()
{
  if [[ ! -v CMP_BUILD_DIR_PATH ]]
  then
    _pzc_error "You need to call 'initap' command before."
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
