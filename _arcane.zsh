
## ----- Arcane aliases/functions section -----

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
## $ cd ${ARCANE_BUILD_DIR}
##
## Install dir:
## $ cd ${ARCANE_INSTALL_DIR}


# ---------------------------------------------------------------
# -------------------------- Aliases ----------------------------
# ---------------------------------------------------------------

alias gitarc='_pzc_coal_eval "cd ${WORK_DIR}/arcane/framework"'
alias gitbenchs='_pzc_coal_eval "cd ${WORK_DIR}/arcane/arcane-benchs"'
alias clonearc='_pzc_coal_eval "mkdir -p ${WORK_DIR}/arcane" ; \
                _pzc_coal_eval "cd ${WORK_DIR}/arcane" ; \
                _pzc_coal_eval "git clone --recurse-submodules https://github.com/arcaneframework/framework" ; \
                gitarc'



# ---------------------------------------------------------------
# ----------------------- Init functions ------------------------
# ---------------------------------------------------------------

initarc()
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

  if [[ -v 2 ]]
  then
    _pzc_ecal_eval "TYPE_BUILD_DIR=${2}"
  else
    _pzc_ecal_eval "TYPE_BUILD_DIR=${ARCANE_TYPE_BUILD}"
  fi

  if [[ -v 3 ]]
  then
    local _PZC_ARCANE_SOURCE_DIR=${3}
  else
    local _PZC_ARCANE_SOURCE_DIR=framework
  fi

  _pzc_ecal_eval "ARCANE_SOURCE_DIR=${WORK_DIR}/arcane/${_PZC_ARCANE_SOURCE_DIR}"
  _pzc_ecal_eval "ARCANE_BUILD_DIR=${BUILD_DIR}/build_${_PZC_ARCANE_SOURCE_DIR}/${TYPE_BUILD_DIR}"
  _pzc_ecal_eval "ARCANE_INSTALL_PATH=${INSTALL_DIR}/install_${_PZC_ARCANE_SOURCE_DIR}/${TYPE_BUILD_DIR}"
  echo ""
  _pzc_ecal_eval "mkdir -p ${ARCANE_BUILD_DIR}"
  _pzc_ecal_eval "mkdir -p ${ARCANE_INSTALL_PATH}"
  echo ""
  _pzc_ecal_eval "cd ${ARCANE_BUILD_DIR}"
  _pzc_pensil_end
}

initap()
{
  if [[ -v 1 ]]
  then
    _pzc_info "Initialize Arcane Project: ${1}"
    AP_PROJECT_NAME=${1}
  else
    _pzc_error "Need project name (first arg)"
    return 1
  fi

  if [[ -v 2 ]]
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

  if [[ -v 3 ]]
  then
    TYPE_BUILD_DIR=${3}
  else
    TYPE_BUILD_DIR=${ARCANE_TYPE_BUILD}
  fi

  local _PZC_EDIT_AP_PATH="${PZC_EDIT_SCRIPTS}/editap_${AP_PROJECT_NAME}_${TYPE_BUILD_DIR}.zsh"

  if [[ -e ${_PZC_EDIT_AP_PATH} ]]
  then
    _pzc_info "The edit script exist. Overwrite default initialization."
    _pzc_coal_eval "source ${_PZC_EDIT_AP_PATH}"

  else
    ARCANE_INSTALL_PATH="${INSTALL_DIR}/install_framework/${TYPE_BUILD_DIR}"
    AP_BUILD_TYPE="${ARCANE_TYPE_BUILD}"
    AP_PROJECT_DIR="${WORK_DIR}/${AP_PROJECT_NAME}"
    AP_SOURCE_DIR="${AP_PROJECT_DIR}"
    AP_BUILD_DIR="${BUILD_DIR}/build_${AP_PROJECT_NAME}/${TYPE_BUILD_DIR}"
    AP_INSTALL_DIR="${INSTALL_DIR}/install_${AP_PROJECT_NAME}/${TYPE_BUILD_DIR}"
  fi

  mkdir -p "${AP_BUILD_DIR}"
  cd "${AP_BUILD_DIR}"

  _pzc_pensil_begin
  echo "AP_PROJECT_NAME=${AP_PROJECT_NAME}"
  echo "ARCANE_TYPE_BUILD=${ARCANE_TYPE_BUILD}"
  echo "TYPE_BUILD_DIR=${TYPE_BUILD_DIR}"
  echo ""
  echo "ARCANE_INSTALL_PATH=${ARCANE_INSTALL_PATH}"
  echo ""
  echo "AP_BUILD_TYPE=${AP_BUILD_TYPE}"
  echo "AP_PROJECT_DIR=${AP_PROJECT_DIR}"
  echo "AP_SOURCE_DIR=${AP_SOURCE_DIR}"
  echo "AP_BUILD_DIR=${AP_BUILD_DIR}"
  echo "AP_INSTALL_DIR=${AP_INSTALL_DIR}"
  echo ""
  echo "mkdir -p ${AP_BUILD_DIR}"
  echo "cd ${AP_BUILD_DIR}"
  _pzc_pensil_end
}



# ---------------------------------------------------------------
# -------------------- Edit init functions ----------------------
# ---------------------------------------------------------------

editap()
{
  if [[ ! -v AP_BUILD_DIR ]]
  then
    _pzc_error "Lancer initap avant."
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
    echo "ARCANE_INSTALL_PATH=${INSTALL_DIR}/install_framework/${TYPE_BUILD_DIR}\n" >> ${_PZC_EDIT_AP_PATH}

    echo "# Type of build for this project:" >> ${_PZC_EDIT_AP_PATH}
    echo "AP_BUILD_TYPE=${ARCANE_TYPE_BUILD}\n" >> ${_PZC_EDIT_AP_PATH}

    echo "# Directory with the project:" >> ${_PZC_EDIT_AP_PATH}
    echo "AP_PROJECT_DIR=${WORK_DIR}/${AP_PROJECT_NAME}\n" >> ${_PZC_EDIT_AP_PATH}

    echo "# Directory with the project source (with the CMakeLists.txt file):" >> ${_PZC_EDIT_AP_PATH}
    echo "AP_SOURCE_DIR=${AP_PROJECT_DIR}\n" >> ${_PZC_EDIT_AP_PATH}

    echo "# Directory needed for the project build:" >> ${_PZC_EDIT_AP_PATH}
    echo "AP_BUILD_DIR=${BUILD_DIR}/build_${AP_PROJECT_NAME}/${TYPE_BUILD_DIR}\n" >> ${_PZC_EDIT_AP_PATH}

    echo "# Directory where install the project:" >> ${_PZC_EDIT_AP_PATH}
    echo "AP_INSTALL_DIR=${INSTALL_DIR}/install_${AP_PROJECT_NAME}/${TYPE_BUILD_DIR}\n" >> ${_PZC_EDIT_AP_PATH}

    _pzc_coal_eval "${PZC_FILE_EDITOR} ${_PZC_EDIT_AP_PATH}"
  fi

  echo ""
  _pzc_coal_eval "initap ${AP_PROJECT_NAME} ${ARCANE_TYPE_BUILD} ${TYPE_BUILD_DIR}"
}

editaprm()
{
  if [[ ! -v AP_BUILD_DIR ]]
  then
    _pzc_error "Lancer initap avant."
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
# ---------------------- Config functions -----------------------
# ---------------------------------------------------------------

pconfigarc()
{
  if [[ -v ARCANE_BUILD_DIR ]]
  then

    if [[ "${ARCANE_TYPE_BUILD}" == "Check" ]]
    then
      CMAKE_BUILD_TYPE="RelWithDebInfo"
    else
      CMAKE_BUILD_TYPE="${ARCANE_TYPE_BUILD}"
    fi

    _pzc_pensil_begin
    echo "cmake \\"
    echo "  -S ${ARCANE_SOURCE_DIR} \\"
    echo "  -B ${ARCANE_BUILD_DIR} \\"
    echo "  -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \\"
    echo "  -DCMAKE_CXX_COMPILER=${PZC_CXX_COMPILER} \\"
    echo "  ${PZC_CMAKE_GENERATOR} \\"
    echo "  ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \\"
    echo "  ${PZC_CMAKE_C_COMPILER_LAUNCHER} \\"
    echo "  ${PZC_CMAKE_LINKER_TYPE} \\"
    echo "  ${_PZC_CMAKE_CODE_COVERAGE} \\"
    echo "  -DCMAKE_INSTALL_PREFIX=${ARCANE_INSTALL_PATH} \\"
    echo "  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \\"
    echo "  -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \\"
    echo "  -DARCCORE_BUILD_MODE=${ARCANE_TYPE_BUILD} \\"
    echo "  -DARCCORE_CXX_STANDARD=23 \\"
    echo "  -DARCANEFRAMEWORK_BUILD_COMPONENTS=Arcane"
    if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
    then
      echo "chmod u+x ${ARCANE_BUILD_DIR}/bin/*"
    fi
    _pzc_pensil_end

  else
    _pzc_error "Un appel à la fonction initarc est nécessaire avant."
    return 1
  fi
}

configarc()
{
  if [[ -v ARCANE_BUILD_DIR ]]
  then
    pconfigarc

    if [[ "${ARCANE_TYPE_BUILD}" == "Check" ]]
    then
      CMAKE_BUILD_TYPE="RelWithDebInfo"
    else
      CMAKE_BUILD_TYPE="${ARCANE_TYPE_BUILD}"
    fi

    cmake \
      -S ${ARCANE_SOURCE_DIR} \
      -B ${ARCANE_BUILD_DIR} \
      -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \
      -DCMAKE_CXX_COMPILER=${PZC_CXX_COMPILER} \
      ${PZC_CMAKE_GENERATOR} \
      ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \
      ${PZC_CMAKE_C_COMPILER_LAUNCHER} \
      ${PZC_CMAKE_LINKER_TYPE} \
      ${_PZC_CMAKE_CODE_COVERAGE} \
      -DCMAKE_INSTALL_PREFIX=${ARCANE_INSTALL_PATH} \
      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
      -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \
      -DARCCORE_BUILD_MODE=${ARCANE_TYPE_BUILD} \
      -DARCCORE_CXX_STANDARD=23 \
      -DARCANEFRAMEWORK_BUILD_COMPONENTS=Arcane
  
    if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
    then
      chmod u+x ${ARCANE_BUILD_DIR}/bin/*
    fi

  else
    _pzc_error "Un appel à la fonction initarc est nécessaire avant."
    return 1
  fi
}

pconfigarcgpu()
{
  if [[ -v ARCANE_BUILD_DIR ]]
  then

    if [[ "${ARCANE_TYPE_BUILD}" == "Check" ]]
    then
      CMAKE_BUILD_TYPE="RelWithDebInfo"
    else
      CMAKE_BUILD_TYPE="${ARCANE_TYPE_BUILD}"
    fi

    if [[ "${PZC_GPU_DEFAULT_COMPILER}" == "NVCC" ]]
    then
      _PZC_ARCANE_ACCELERATOR_MODE="-DARCANE_ACCELERATOR_MODE=CUDA"
      _PZC_CMAKE_GPU_COMPILER="-DCMAKE_CUDA_COMPILER=${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        _PZC_CMAKE_GPU_FLAGS="-DCMAKE_CUDA_FLAGS=${PZC_GPU_FLAGS}"
      fi
      if [[ -v PZC_GPU_TARGET_ARCH ]]
      then
        _PZC_CMAKE_GPU_ARCH="-DCMAKE_CUDA_ARCHITECTURES=${PZC_GPU_TARGET_ARCH}"
      fi

    else
      _PZC_ARCANE_ACCELERATOR_MODE="-DARCANE_ACCELERATOR_MODE=SYCL"
      _PZC_CMAKE_GPU_COMPILER="-DCMAKE_SYCL_COMPILER=${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        _PZC_CMAKE_GPU_FLAGS="-DARCANE_CXX_SYCL_FLAGS=${PZC_GPU_FLAGS}"
      fi
    fi

    _pzc_pensil_begin
    echo "cmake \\"
    echo "  -S ${ARCANE_SOURCE_DIR} \\"
    echo "  -B ${ARCANE_BUILD_DIR} \\"
    echo "  -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \\"
    echo "  -DCMAKE_CXX_COMPILER=${PZC_GPU_HOST_COMPILER} \\"
    echo "  ${PZC_CMAKE_GENERATOR} \\"
    echo "  ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \\"
    echo "  ${PZC_CMAKE_C_COMPILER_LAUNCHER} \\"
    echo "  ${PZC_CMAKE_LINKER_TYPE} \\"
    echo "  ${_PZC_CMAKE_CODE_COVERAGE} \\"
    echo "  ${_PZC_ARCANE_ACCELERATOR_MODE} \\"
    echo "  ${_PZC_CMAKE_GPU_COMPILER} \\"
    echo "  ${_PZC_CMAKE_GPU_FLAGS} \\"
    echo "  ${_PZC_CMAKE_GPU_ARCH} \\"
    echo "  -DCMAKE_INSTALL_PREFIX=${ARCANE_INSTALL_PATH} \\"
    echo "  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \\"
    echo "  -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \\"
    echo "  -DARCCORE_BUILD_MODE=${ARCANE_TYPE_BUILD} \\"
    echo "  -DARCCORE_CXX_STANDARD=20 \\"
    echo "  -DARCANEFRAMEWORK_BUILD_COMPONENTS=Arcane"

    if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
    then
      echo "chmod u+x ${ARCANE_BUILD_DIR}/bin/*"
    fi
    _pzc_pensil_end

  else
    _pzc_error "Un appel à la fonction initarc est nécessaire avant."
    return 1
  fi
}

configarcgpu()
{
  if [[ -v ARCANE_BUILD_DIR ]]
  then
    pconfigarcgpu

    if [[ "${ARCANE_TYPE_BUILD}" == "Check" ]]
    then
      CMAKE_BUILD_TYPE="RelWithDebInfo"
    else
      CMAKE_BUILD_TYPE="${ARCANE_TYPE_BUILD}"
    fi

    if [[ "${PZC_GPU_DEFAULT_COMPILER}" == "NVCC" ]]
    then
      _PZC_ARCANE_ACCELERATOR_MODE="-DARCANE_ACCELERATOR_MODE=CUDA"
      _PZC_CMAKE_GPU_COMPILER="-DCMAKE_CUDA_COMPILER=${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        _PZC_CMAKE_GPU_FLAGS="-DCMAKE_CUDA_FLAGS=${PZC_GPU_FLAGS}"
      fi
      if [[ -v PZC_GPU_TARGET_ARCH ]]
      then
        _PZC_CMAKE_GPU_ARCH="-DCMAKE_CUDA_ARCHITECTURES=${PZC_GPU_TARGET_ARCH}"
      fi

    else
      _PZC_ARCANE_ACCELERATOR_MODE="-DARCANE_ACCELERATOR_MODE=SYCL"
      _PZC_CMAKE_GPU_COMPILER="-DCMAKE_SYCL_COMPILER=${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        _PZC_CMAKE_GPU_FLAGS="-DARCANE_CXX_SYCL_FLAGS=${PZC_GPU_FLAGS}"
      fi
    fi

    cmake \
      -S ${ARCANE_SOURCE_DIR} \
      -B ${ARCANE_BUILD_DIR} \
      -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \
      -DCMAKE_CXX_COMPILER=${PZC_GPU_HOST_COMPILER} \
      ${PZC_CMAKE_GENERATOR} \
      ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \
      ${PZC_CMAKE_C_COMPILER_LAUNCHER} \
      ${PZC_CMAKE_LINKER_TYPE} \
      ${_PZC_CMAKE_CODE_COVERAGE} \
      ${_PZC_ARCANE_ACCELERATOR_MODE} \
      ${_PZC_CMAKE_GPU_COMPILER} \
      ${_PZC_CMAKE_GPU_FLAGS} \
      ${_PZC_CMAKE_GPU_ARCH} \
      -DCMAKE_INSTALL_PREFIX=${ARCANE_INSTALL_PATH} \
      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
      -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \
      -DARCCORE_BUILD_MODE=${ARCANE_TYPE_BUILD} \
      -DARCCORE_CXX_STANDARD=20 \
      -DARCANEFRAMEWORK_BUILD_COMPONENTS=Arcane

    if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
    then
      chmod u+x ${ARCANE_BUILD_DIR}/bin/*
    fi

  else
    _pzc_error "Un appel à la fonction initarc est nécessaire avant."
    return 1
  fi
}

pconfigap()
{
  if [[ -v AP_BUILD_DIR ]]
  then

    if [[ "${AP_BUILD_TYPE}" == "Check" ]]
    then
      CMAKE_BUILD_TYPE="RelWithDebInfo"
    else
      CMAKE_BUILD_TYPE="${AP_BUILD_TYPE}"
    fi

    _pzc_pensil_begin
    echo "cmake \\"
    echo "  -S ${AP_SOURCE_DIR} \\"
    echo "  -B ${AP_BUILD_DIR} \\"
    echo "  -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \\"
    echo "  -DCMAKE_CXX_COMPILER=${PZC_CXX_COMPILER} \\"
    echo "  ${PZC_CMAKE_GENERATOR} \\"
    echo "  ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \\"
    echo "  ${PZC_CMAKE_C_COMPILER_LAUNCHER} \\"
    echo "  ${PZC_CMAKE_LINKER_TYPE} \\"
    echo "  -DCMAKE_INSTALL_PREFIX=${AP_INSTALL_DIR} \\"
    echo "  -DCMAKE_PREFIX_PATH=${ARCANE_INSTALL_PATH} \\"
    echo "  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
    _pzc_pensil_end
      
  else
    _pzc_error "Lancer initap avant."
    return 1
  fi
}

configap()
{
  if [[ -v AP_BUILD_DIR ]]
  then
    _pzc_info "Configure Arcane Project: ${AP_PROJECT_NAME}"
    pconfigap

    if [[ "${AP_BUILD_TYPE}" == "Check" ]]
    then
      CMAKE_BUILD_TYPE="RelWithDebInfo"
    else
      CMAKE_BUILD_TYPE="${AP_BUILD_TYPE}"
    fi

    cmake \
      -S ${AP_SOURCE_DIR} \
      -B ${AP_BUILD_DIR} \
      -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \
      -DCMAKE_CXX_COMPILER=${PZC_CXX_COMPILER} \
      ${PZC_CMAKE_GENERATOR} \
      ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \
      ${PZC_CMAKE_C_COMPILER_LAUNCHER} \
      ${PZC_CMAKE_LINKER_TYPE} \
      -DCMAKE_INSTALL_PREFIX=${AP_INSTALL_DIR} \
      -DCMAKE_PREFIX_PATH=${ARCANE_INSTALL_PATH} \
      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
      
  else
    _pzc_error "Lancer initap avant."
    return 1
  fi
}

pconfigapgpu()
{
  if [[ -v AP_BUILD_DIR ]]
  then

    if [[ "${AP_BUILD_TYPE}" == "Check" ]]
    then
      CMAKE_BUILD_TYPE="RelWithDebInfo"
    else
      CMAKE_BUILD_TYPE="${AP_BUILD_TYPE}"
    fi

    if [[ "${PZC_GPU_DEFAULT_COMPILER}" == "NVCC" ]]
    then
      _PZC_CMAKE_GPU_COMPILER="-DCMAKE_CUDA_COMPILER=${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        _PZC_CMAKE_GPU_FLAGS="-DCMAKE_CUDA_FLAGS=${PZC_GPU_FLAGS}"
      fi
      if [[ -v PZC_GPU_TARGET_ARCH ]]
      then
        _PZC_CMAKE_GPU_ARCH="-DCMAKE_CUDA_ARCHITECTURES=${PZC_GPU_TARGET_ARCH}"
      fi

    else
      _PZC_CMAKE_GPU_COMPILER="-DCMAKE_SYCL_COMPILER=${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        _PZC_CMAKE_GPU_FLAGS="-DARCANE_CXX_SYCL_FLAGS=${PZC_GPU_FLAGS}"
      fi
    fi

    _pzc_pensil_begin
    echo "cmake \\"
    echo "  -S ${AP_SOURCE_DIR} \\"
    echo "  -B ${AP_BUILD_DIR} \\"
    echo "  -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \\"
    echo "  -DCMAKE_CXX_COMPILER=${PZC_GPU_HOST_COMPILER} \\"
    echo "  ${PZC_CMAKE_GENERATOR} \\"
    echo "  ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \\"
    echo "  ${PZC_CMAKE_C_COMPILER_LAUNCHER} \\"
    echo "  ${PZC_CMAKE_LINKER_TYPE} \\"
    echo "  ${_PZC_CMAKE_GPU_COMPILER} \\"
    echo "  ${_PZC_CMAKE_GPU_FLAGS} \\"
    echo "  ${_PZC_CMAKE_GPU_ARCH} \\"
    echo "  -DCMAKE_INSTALL_PREFIX=${AP_INSTALL_DIR} \\"
    echo "  -DCMAKE_PREFIX_PATH=${ARCANE_INSTALL_PATH} \\"
    echo "  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \\"
    echo "  -DWANT_PROF_ACC=TRUE"
    _pzc_pensil_end

  else
    _pzc_error "Lancer initap avant."
    return 1
  fi
}

configapgpu()
{
  if [[ -v AP_BUILD_DIR ]]
  then
    _pzc_info "Configure Arcane Project GPU: ${AP_PROJECT_NAME}"
    pconfigapgpu

    if [[ "${AP_BUILD_TYPE}" == "Check" ]]
    then
      CMAKE_BUILD_TYPE="RelWithDebInfo"
    else
      CMAKE_BUILD_TYPE="${AP_BUILD_TYPE}"
    fi

    if [[ "${PZC_GPU_DEFAULT_COMPILER}" == "NVCC" ]]
    then
      _PZC_CMAKE_GPU_COMPILER="-DCMAKE_CUDA_COMPILER=${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        _PZC_CMAKE_GPU_FLAGS="-DCMAKE_CUDA_FLAGS=${PZC_GPU_FLAGS}"
      fi
      if [[ -v PZC_GPU_TARGET_ARCH ]]
      then
        _PZC_CMAKE_GPU_ARCH="-DCMAKE_CUDA_ARCHITECTURES=${PZC_GPU_TARGET_ARCH}"
      fi

    else
      _PZC_CMAKE_GPU_COMPILER="-DCMAKE_SYCL_COMPILER=${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        _PZC_CMAKE_GPU_FLAGS="-DARCANE_CXX_SYCL_FLAGS=${PZC_GPU_FLAGS}"
      fi
    fi

    cmake \
      -S ${AP_SOURCE_DIR} \
      -B ${AP_BUILD_DIR} \
      -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \
      -DCMAKE_CXX_COMPILER=${PZC_GPU_HOST_COMPILER} \
      ${PZC_CMAKE_GENERATOR} \
      ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \
      ${PZC_CMAKE_C_COMPILER_LAUNCHER} \
      ${PZC_CMAKE_LINKER_TYPE} \
      ${_PZC_CMAKE_GPU_COMPILER} \
      ${_PZC_CMAKE_GPU_FLAGS} \
      ${_PZC_CMAKE_GPU_ARCH} \
      -DCMAKE_INSTALL_PREFIX=${AP_INSTALL_DIR} \
      -DCMAKE_PREFIX_PATH=${ARCANE_INSTALL_PATH} \
      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
      -DWANT_PROF_ACC=TRUE

  else
    _pzc_error "Lancer initap avant."
    return 1
  fi
}



# ---------------------------------------------------------------
# ------------------- Build/Install functions -------------------
# ---------------------------------------------------------------

pbiarc()
{
  if [[ -v ARCANE_BUILD_DIR ]]
  then
    _pzc_pensil_begin
    if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
    then
      echo "chmod u+x ${ARCANE_BUILD_DIR}/bin/*"
    fi
    echo "cmake --build ${ARCANE_BUILD_DIR} --target install"
    _pzc_pensil_end

  else
    _pzc_error "Un appel à la fonction initarc est nécessaire avant."
    return 1
  fi
}

biarc()
{
  if [[ -v ARCANE_BUILD_DIR ]]
  then
    pbiarc

    if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
    then
      chmod u+x ${ARCANE_BUILD_DIR}/bin/*
    fi
    cmake --build ${ARCANE_BUILD_DIR} --target install

  else
    _pzc_error "Un appel à la fonction initarc est nécessaire avant."
    return 1
  fi
}

pdocarc()
{
  if [[ -v ARCANE_BUILD_DIR ]]
  then
    _pzc_pensil_begin
    if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
    then
      echo "chmod u+x ${ARCANE_BUILD_DIR}/bin/*"
    fi
    echo "cmake --build ${ARCANE_BUILD_DIR}"
    if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
    then
      echo "chmod u+x ${ARCANE_BUILD_DIR}/bin/*"
    fi
    echo "cmake --build ${ARCANE_BUILD_DIR} --target ${1}doc"
    _pzc_pensil_end

  else
    _pzc_error "Un appel à la fonction initarc est nécessaire avant."
    return 1
  fi
}

docarc()
{
  if [[ -v ARCANE_BUILD_DIR ]]
  then
    pdocarc

    if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
    then
      chmod u+x ${ARCANE_BUILD_DIR}/bin/*
    fi
    cmake --build ${ARCANE_BUILD_DIR}
    if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
    then
      chmod u+x ${ARCANE_BUILD_DIR}/bin/*
    fi
    cmake --build ${ARCANE_BUILD_DIR} --target ${1}doc

  else
    _pzc_error "Un appel à la fonction initarc est nécessaire avant."
    return 1
  fi
}



# ---------------------------------------------------------------
# ----------------------- Clear functions -----------------------
# ---------------------------------------------------------------

cleararc()
{
  if [[ -v ARCANE_BUILD_DIR ]]
  then
    _pzc_pensil_begin
    _pzc_ecal_eval "cd ${ARCANE_BUILD_DIR}/.."
    _pzc_ecal_eval "rm -r ${ARCANE_BUILD_DIR}"
    _pzc_ecal_eval "rm -r ${ARCANE_INSTALL_PATH}"
    _pzc_ecal_eval "mkdir ${ARCANE_BUILD_DIR}"
    _pzc_ecal_eval "mkdir ${ARCANE_INSTALL_PATH}"
    _pzc_ecal_eval "cd ${ARCANE_BUILD_DIR}"
    _pzc_pensil_end

  else
    _pzc_error "Un appel à la fonction initarc est nécessaire avant."
    return 1
  fi
}

clearap()
{
  if [[ -v AP_BUILD_DIR ]]
  then
    _pzc_pensil_begin
    _pzc_ecal_eval "cd ${AP_BUILD_DIR}/.."
    _pzc_ecal_eval "rm -r ${AP_BUILD_DIR}"
    _pzc_ecal_eval "rm -r ${AP_INSTALL_DIR}"
    _pzc_ecal_eval "mkdir ${AP_BUILD_DIR}"
    _pzc_ecal_eval "mkdir ${AP_INSTALL_DIR}"
    _pzc_ecal_eval "cd ${AP_BUILD_DIR}"
    _pzc_pensil_end

  else
    _pzc_error "Un appel à la fonction initap est nécessaire avant."
    return 1
  fi
}
