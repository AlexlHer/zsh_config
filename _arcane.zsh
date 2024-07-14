
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

  _pzc_ecal_eval "ARCANE_SOURCE_DIR=${WORK_DIR}/arcane/framework"
  _pzc_ecal_eval "ARCANE_BUILD_DIR=${BUILD_DIR}/build_framework/${TYPE_BUILD_DIR}"
  _pzc_ecal_eval "ARCANE_INSTALL_PATH=${INSTALL_DIR}/install_framework/${TYPE_BUILD_DIR}"
  echo ""
  _pzc_ecal_eval "mkdir -p ${ARCANE_BUILD_DIR}"
  _pzc_ecal_eval "mkdir -p ${ARCANE_INSTALL_PATH}"
  echo ""
  _pzc_ecal_eval "cd ${ARCANE_BUILD_DIR}"
  _pzc_pensil_end
}

initarcfork()
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
      _pzc_error "Invalid 'ARCANE_TYPE_BUILD' (first arg)"
      return 1
    fi
  else
    _pzc_info "No argument, defining 'ARCANE_TYPE_BUILD' to 'Release'"
    _pzc_ecal_eval "ARCANE_TYPE_BUILD=Release"
  fi

  if [[ -v 2 ]]
  then
    _pzc_ecal_eval "TYPE_BUILD_DIR=${2}"
  else
    _pzc_ecal_eval "TYPE_BUILD_DIR=${ARCANE_TYPE_BUILD}"
  fi

  _pzc_ecal_eval "ARCANE_SOURCE_DIR=${WORK_DIR}/arcane/forks/framework"
  _pzc_ecal_eval "ARCANE_BUILD_DIR=${BUILD_DIR}/build_framework_fork/${TYPE_BUILD_DIR}"
  _pzc_ecal_eval "ARCANE_INSTALL_PATH=${INSTALL_DIR}/install_framework_fork/${TYPE_BUILD_DIR}"
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
    _pzc_pensil_begin
    _pzc_ecal_eval "AP_PROJECT_NAME=${1}"
  else
    _pzc_error "Need project name (first arg)"
    return 1
  fi

  if [[ -v 2 ]]
  then
    if [[ ${2} == "D" ]] || [[ ${2} == "Debug" ]]
    then
      _pzc_ecal_eval "ARCANE_TYPE_BUILD=Debug"
    elif [[ ${2} == "C" ]] || [[ ${2} == "Check" ]]
    then
      _pzc_ecal_eval "ARCANE_TYPE_BUILD=Check"
    elif [[ ${2} == "R" ]] || [[ ${2} == "Release" ]]
    then
      _pzc_ecal_eval "ARCANE_TYPE_BUILD=Release"
    else
      _pzc_pensil_end
      _pzc_error "Invalid 'ARCANE_TYPE_BUILD' (second arg)"
      return 1
    fi
  else
    _pzc_info "No argument, defining 'ARCANE_TYPE_BUILD' to 'Release'"
    _pzc_ecal_eval "ARCANE_TYPE_BUILD=Release"
  fi

  if [[ -v 3 ]]
  then
    _pzc_ecal_eval "TYPE_BUILD_DIR=${3}"
  else
    _pzc_ecal_eval "TYPE_BUILD_DIR=${ARCANE_TYPE_BUILD}"
  fi

  _pzc_ecal_eval "ARCANE_INSTALL_PATH=${BUILD_DIR}/install_framework/${TYPE_BUILD_DIR}"
  echo ""
  _pzc_ecal_eval "AP_BUILD_TYPE=${ARCANE_TYPE_BUILD}"
  _pzc_ecal_eval "AP_PROJECT_DIR=${WORK_DIR}/${AP_PROJECT_NAME}"
  _pzc_ecal_eval "AP_SOURCE_DIR=${AP_PROJECT_DIR}"
  _pzc_ecal_eval "AP_BUILD_DIR=${BUILD_DIR}/build_${AP_PROJECT_NAME}/${TYPE_BUILD_DIR}"
  _pzc_ecal_eval "AP_INSTALL_DIR=${INSTALL_DIR}/install_${AP_PROJECT_NAME}/${TYPE_BUILD_DIR}"
  echo ""
  _pzc_ecal_eval "mkdir -p ${AP_BUILD_DIR}"
  echo ""
  _pzc_ecal_eval "cd ${AP_BUILD_DIR}"

  _pzc_pensil_end
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

    if [[ "${ARCANE_TYPE_BUILD}" == "Debug" ]] && [[ "${_PZC_C_CXX_DEFAULT_COMPILER}" == "GCC" ]]
    then
      _PZC_CMAKE_CODE_COVERAGE="-DARCCORE_ENABLE_CODE_COVERAGE=ON"
    fi

    _pzc_pensil_begin
    echo "cmake \\"
    echo "  ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \\"
    echo "  ${PZC_CMAKE_C_COMPILER_LAUNCHER} \\"
    echo "  -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \\"
    echo "  -DCMAKE_CXX_COMPILER=${PZC_CXX_COMPILER} \\"
    echo "  ${PZC_CMAKE_LINKER_TYPE} \\"
    echo "  ${PZC_CMAKE_GENERATOR} \\"
    echo "  ${_PZC_CMAKE_CODE_COVERAGE} \\"
    echo "  -S ${ARCANE_SOURCE_DIR} \\"
    echo "  -B ${ARCANE_BUILD_DIR} \\"
    echo "  -DCMAKE_INSTALL_PREFIX=${ARCANE_INSTALL_PATH} \\"
    echo "  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \\"
    echo "  -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \\"
    echo "  -DARCCORE_BUILD_MODE=${ARCANE_TYPE_BUILD} \\"
    echo "  -DARCCORE_CXX_STANDARD=23"
    if [[ ${_PZC_CHMOD_COMPILING} = 1 ]]
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

    if [[ "${ARCANE_TYPE_BUILD}" == "Debug" ]] && [[ "${_PZC_C_CXX_DEFAULT_COMPILER}" == "GCC" ]]
    then
      _PZC_CMAKE_CODE_COVERAGE="-DARCCORE_ENABLE_CODE_COVERAGE=ON"
    fi

    cmake \
      ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \
      ${PZC_CMAKE_C_COMPILER_LAUNCHER} \
      -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \
      -DCMAKE_CXX_COMPILER=${PZC_CXX_COMPILER} \
      ${PZC_CMAKE_LINKER_TYPE} \
      ${PZC_CMAKE_GENERATOR} \
      ${_PZC_CMAKE_CODE_COVERAGE} \
      -S ${ARCANE_SOURCE_DIR} \
      -B ${ARCANE_BUILD_DIR} \
      -DCMAKE_INSTALL_PREFIX=${ARCANE_INSTALL_PATH} \
      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
      -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \
      -DARCCORE_BUILD_MODE=${ARCANE_TYPE_BUILD} \
      -DARCCORE_CXX_STANDARD=23
  
    if [[ ${_PZC_CHMOD_COMPILING} = 1 ]]
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

    if [[ "${ARCANE_TYPE_BUILD}" == "Debug" ]] && [[ "${_PZC_C_CXX_DEFAULT_COMPILER}" == "GCC" ]]
    then
      _PZC_CMAKE_CODE_COVERAGE="-DARCCORE_ENABLE_CODE_COVERAGE=ON"
    fi

    if [[ "${_PZC_GPU_DEFAULT_COMPILER}" == "NVCC" ]]
    then
      _PZC_ARCANE_ACCELERATOR_MODE="-DARCANE_ACCELERATOR_MODE=CUDANVCC"
      _PZC_CMAKE_GPU_COMPILER="-DCMAKE_CUDA_COMPILER=${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        _PZC_CMAKE_GPU_FLAGS="-DCMAKE_CUDA_FLAGS=${PZC_GPU_FLAGS}"
      fi

    else
      _PZC_ARCANE_ACCELERATOR_MODE="-DARCANE_ACCELERATOR_MODE=SYCLDPCPP"
      _PZC_CMAKE_GPU_COMPILER="-DCMAKE_SYCL_COMPILER=${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        _PZC_CMAKE_GPU_FLAGS="-DARCANE_CXX_SYCL_FLAGS=${PZC_GPU_FLAGS}"
      fi
    fi

    _pzc_pensil_begin
    echo "cmake \\"
    echo "  ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \\"
    echo "  ${PZC_CMAKE_C_COMPILER_LAUNCHER} \\"
    echo "  -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \\"
    echo "  -DCMAKE_CXX_COMPILER=${PZC_GPU_HOST_COMPILER} \\"
    echo "  ${PZC_CMAKE_LINKER_TYPE} \\"
    echo "  ${PZC_CMAKE_GENERATOR} \\"
    echo "  ${_PZC_CMAKE_CODE_COVERAGE} \\"
    echo "  ${_PZC_ARCANE_ACCELERATOR_MODE} \\"
    echo "  ${_PZC_CMAKE_GPU_COMPILER} \\"
    echo "  ${_PZC_CMAKE_GPU_FLAGS} \\"
    echo "  -S ${ARCANE_SOURCE_DIR} \\"
    echo "  -B ${ARCANE_BUILD_DIR} \\"
    echo "  -DCMAKE_INSTALL_PREFIX=${ARCANE_INSTALL_PATH} \\"
    echo "  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \\"
    echo "  -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \\"
    echo "  -DARCCORE_BUILD_MODE=${ARCANE_TYPE_BUILD} \\"
    echo "  -DARCCORE_CXX_STANDARD=20"

    if [[ ${_PZC_CHMOD_COMPILING} = 1 ]]
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

    if [[ "${ARCANE_TYPE_BUILD}" == "Debug" ]] && [[ "${_PZC_C_CXX_DEFAULT_COMPILER}" == "GCC" ]]
    then
      _PZC_CMAKE_CODE_COVERAGE="-DARCCORE_ENABLE_CODE_COVERAGE=ON"
    fi

    if [[ "${_PZC_GPU_DEFAULT_COMPILER}" == "NVCC" ]]
    then
      _PZC_ARCANE_ACCELERATOR_MODE="-DARCANE_ACCELERATOR_MODE=CUDANVCC"
      _PZC_CMAKE_GPU_COMPILER="-DCMAKE_CUDA_COMPILER=${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        _PZC_CMAKE_GPU_FLAGS="-DCMAKE_CUDA_FLAGS=${PZC_GPU_FLAGS}"
      fi

    else
      _PZC_ARCANE_ACCELERATOR_MODE="-DARCANE_ACCELERATOR_MODE=SYCLDPCPP"
      _PZC_CMAKE_GPU_COMPILER="-DCMAKE_SYCL_COMPILER=${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        _PZC_CMAKE_GPU_FLAGS="-DARCANE_CXX_SYCL_FLAGS=${PZC_GPU_FLAGS}"
      fi
    fi

    cmake \
      ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \
      ${PZC_CMAKE_C_COMPILER_LAUNCHER} \
      -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \
      -DCMAKE_CXX_COMPILER=${PZC_GPU_HOST_COMPILER} \
      ${PZC_CMAKE_LINKER_TYPE} \
      ${PZC_CMAKE_GENERATOR} \
      ${_PZC_CMAKE_CODE_COVERAGE} \
      ${_PZC_ARCANE_ACCELERATOR_MODE} \
      ${_PZC_CMAKE_GPU_COMPILER} \
      ${_PZC_CMAKE_GPU_FLAGS} \
      -S ${ARCANE_SOURCE_DIR} \
      -B ${ARCANE_BUILD_DIR} \
      -DCMAKE_INSTALL_PREFIX=${ARCANE_INSTALL_PATH} \
      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
      -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \
      -DARCCORE_BUILD_MODE=${ARCANE_TYPE_BUILD} \
      -DARCCORE_CXX_STANDARD=20

    if [[ ${_PZC_CHMOD_COMPILING} = 1 ]]
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
    echo "  ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \\"
    echo "  ${PZC_CMAKE_C_COMPILER_LAUNCHER} \\"
    echo "  -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \\"
    echo "  -DCMAKE_CXX_COMPILER=${PZC_CXX_COMPILER} \\"
    echo "  ${PZC_CMAKE_LINKER_TYPE} \\"
    echo "  ${PZC_CMAKE_GENERATOR} \\"
    echo "  -S ${AP_SOURCE_DIR} \\"
    echo "  -B ${AP_BUILD_DIR} \\"
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
      ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \
      ${PZC_CMAKE_C_COMPILER_LAUNCHER} \
      -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \
      -DCMAKE_CXX_COMPILER=${PZC_CXX_COMPILER} \
      ${PZC_CMAKE_LINKER_TYPE} \
      ${PZC_CMAKE_GENERATOR} \
      -S ${AP_SOURCE_DIR} \
      -B ${AP_BUILD_DIR} \
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

    if [[ "${_PZC_GPU_DEFAULT_COMPILER}" == "NVCC" ]]
    then
      _PZC_CMAKE_GPU_COMPILER="-DCMAKE_CUDA_COMPILER=${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        _PZC_CMAKE_GPU_FLAGS="-DCMAKE_CUDA_FLAGS=${PZC_GPU_FLAGS}"
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
    echo "  ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \\"
    echo "  ${PZC_CMAKE_C_COMPILER_LAUNCHER} \\"
    echo "  -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \\"
    echo "  -DCMAKE_CXX_COMPILER=${PZC_GPU_HOST_COMPILER} \\"
    echo "  ${PZC_CMAKE_LINKER_TYPE} \\"
    echo "  ${PZC_CMAKE_GENERATOR} \\"
    echo "  ${_PZC_CMAKE_GPU_COMPILER} \\"
    echo "  ${_PZC_CMAKE_GPU_FLAGS} \\"
    echo "  -S ${AP_SOURCE_DIR} \\"
    echo "  -B ${AP_BUILD_DIR} \\"
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

    if [[ "${_PZC_GPU_DEFAULT_COMPILER}" == "NVCC" ]]
    then
      _PZC_CMAKE_GPU_COMPILER="-DCMAKE_CUDA_COMPILER=${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        _PZC_CMAKE_GPU_FLAGS="-DCMAKE_CUDA_FLAGS=${PZC_GPU_FLAGS}"
      fi

    else
      _PZC_CMAKE_GPU_COMPILER="-DCMAKE_SYCL_COMPILER=${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        _PZC_CMAKE_GPU_FLAGS="-DARCANE_CXX_SYCL_FLAGS=${PZC_GPU_FLAGS}"
      fi
    fi

    cmake \
      ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \
      ${PZC_CMAKE_C_COMPILER_LAUNCHER} \
      -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \
      -DCMAKE_CXX_COMPILER=${PZC_GPU_HOST_COMPILER} \
      ${PZC_CMAKE_LINKER_TYPE} \
      ${PZC_CMAKE_GENERATOR} \
      ${_PZC_CMAKE_GPU_COMPILER} \
      ${_PZC_CMAKE_GPU_FLAGS} \
      -S ${AP_SOURCE_DIR} \
      -B ${AP_BUILD_DIR} \
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
    if [[ ${_PZC_CHMOD_COMPILING} = 1 ]]
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

    if [[ ${_PZC_CHMOD_COMPILING} = 1 ]]
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
    if [[ ${_PZC_CHMOD_COMPILING} = 1 ]]
    then
      echo "chmod u+x ${ARCANE_BUILD_DIR}/bin/*"
    fi
    echo "cmake --build ${ARCANE_BUILD_DIR}"
    if [[ ${_PZC_CHMOD_COMPILING} = 1 ]]
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

    if [[ ${_PZC_CHMOD_COMPILING} = 1 ]]
    then
      chmod u+x ${ARCANE_BUILD_DIR}/bin/*
    fi
    cmake --build ${ARCANE_BUILD_DIR}
    if [[ ${_PZC_CHMOD_COMPILING} = 1 ]]
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
