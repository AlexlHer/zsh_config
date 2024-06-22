
## --- Export variable section ---



# ---------------------------------------------------------------
# --------------------- Work dirs creation ----------------------
# ---------------------------------------------------------------

export WORK_DIR=${_PZC_LARGE_DIR}/work
export BUILD_DIR=${_PZC_LARGE_DIR}/build_install
export CONTAINER_BUILD_DIR=${BUILD_DIR}/container

_pzc_debug "Creating CCache, work, build and container_build directories"
mkdir -p ${WORK_DIR} ${BUILD_DIR} ${CONTAINER_BUILD_DIR}



# ---------------------------------------------------------------
# ------------------------ Tools config--------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_CMAKE_AVAILABLE} = 1 ]]
then
  local _PZC_CMAKE_VERSION=$(cmake --version | head -1 | cut -f3 -d" ")
  local _PZC_CMAKE_VERSION_MAJOR="${_PZC_CMAKE_VERSION%%.*}"
  local _PZC_CMAKE_VERSION_MINOR="${${_PZC_CMAKE_VERSION#*.}%.*}"
  _pzc_debug "Get CMake version : ${_PZC_CMAKE_VERSION} MAJOR : ${_PZC_CMAKE_VERSION_MAJOR} MINOR : ${_PZC_CMAKE_VERSION_MINOR}"
fi

if [[ ${_PZC_CCACHE_AVAILABLE} = 1 ]]
then
  _pzc_debug "Exporting CCache variables and creating CCache dir"
  export CCACHE_COMPRESS=true
  export CCACHE_COMPRESSLEVEL=6
  export CCACHE_DIR=${BUILD_DIR}/ccache
  export CCACHE_MAXSIZE=20G
  mkdir -p ${CCACHE_DIR}

  _pzc_debug "Set PZC_CMAKE_CXX/CC_COMPILER_LAUNCHER"
  export PZC_CMAKE_CXX_COMPILER_LAUNCHER="-DCMAKE_CXX_COMPILER_LAUNCHER=${_PZC_CCACHE_PATH}"
  export PZC_CMAKE_C_COMPILER_LAUNCHER="-DCMAKE_C_COMPILER_LAUNCHER=${_PZC_CCACHE_PATH}"

fi

if [[ ${_PZC_MOLD_AVAILABLE} = 1 ]]
then
  _pzc_debug "Config Mold linker"

  if [[ ${_PZC_CMAKE_VERSION_MINOR} -gt 28 ]] #>= 3.29
  then
    _pzc_debug "CMake >= 3.29 : Add PZC_CMAKE_LINKER_TYPE var"
    export PZC_CMAKE_LINKER_TYPE="-DCMAKE_LINKER_TYPE=MOLD"

  else
    _pzc_debug "CMake < 3.29 : Set CFLAGS / CXXFLAGS"
    export CFLAGS="${CFLAGS} -fuse-ld=mold"
    export CXXFLAGS="${CXXFLAGS} -fuse-ld=mold"

  fi
fi

if [[ ${_PZC_NINJA_AVAILABLE} = 1 ]]
then
  _pzc_debug "Config Ninja builder"

  _pzc_debug "Add color for Ninja"
  export CFLAGS="${CFLAGS} -fdiagnostics-color=always"
  export CXXFLAGS="${CXXFLAGS} -fdiagnostics-color=always"

  _pzc_debug "Add -GNinja"
  export PZC_CMAKE_GENERATOR="-GNinja"

fi


if [[ ${_PZC_C_CXX_AVAILABLE} = 1 ]]
then
  if [[ ${_PZC_C_CXX_DEFAULT_COMPILER} = "GCC" ]]
  then
    if [[ ${_PZC_GCC_AVAILABLE} = 1 ]]
    then
      _pzc_debug "Default C/CXX compiler : GCC"
      export PZC_C_COMPILER="${PZC_C_GCC_BIN}"
      export PZC_CXX_COMPILER="${PZC_CXX_GCC_BIN}"

    elif [[ ${_PZC_CLANG_AVAILABLE} = 1 ]]
    then
      _pzc_error "GCC is not available. Set CLANG to default C/CXX compiler."
      export PZC_C_COMPILER="${PZC_C_CLANG_BIN}"
      export PZC_CXX_COMPILER="${PZC_CXX_CLANG_BIN}"
      local _PZC_C_CXX_DEFAULT_COMPILER="CLANG"

    else
      _pzc_error "GCC and CLANG are not available."
    fi

  else
    if [[ ${_PZC_CLANG_AVAILABLE} = 1 ]]
    then
      _pzc_debug "Default C/CXX compiler : CLANG"
      export PZC_C_COMPILER="${PZC_C_CLANG_BIN}"
      export PZC_CXX_COMPILER="${PZC_CXX_CLANG_BIN}"

    elif [[ ${_PZC_GCC_AVAILABLE} = 1 ]]
    then
      _pzc_error "CLANG is not available. Set GCC to default C/CXX compiler."
      export PZC_C_COMPILER="${PZC_C_GCC_BIN}"
      export PZC_CXX_COMPILER="${PZC_CXX_GCC_BIN}"
      local _PZC_C_CXX_DEFAULT_COMPILER="GCC"

    else
      _pzc_error "GCC and CLANG are not available."
    fi
  fi
else
  _pzc_debug "No C/CXX default compiler"
fi

if [[ ${_PZC_GPU_AVAILABLE} = 1 ]]
then
  if [[ ${_PZC_GPU_DEFAULT_COMPILER} = "NVCC" ]]
  then
    if [[ ${_PZC_NVCC_BIN_AVAILABLE} = 1 ]]
    then
      _pzc_debug "Default GPU compiler : NVCC"
      export PZC_GPU_HOST_COMPILER="${PZC_NVCC_HOST_COMPILER_BIN}"
      export PZC_GPU_COMPILER="${PZC_NVCC_BIN}"
      if [[ -v _PZC_GPU_TARGET_ARCH ]]
      then
        export PZC_GPU_FLAGS="'-gencode arch=compute_${_PZC_GPU_TARGET_ARCH},code=sm_${_PZC_GPU_TARGET_ARCH}'"
      fi

    elif [[ ${_PZC_SYCL_BIN_AVAILABLE} = 1 ]]
    then
      _pzc_error "NVCC is not available. Set SYCL to default GPU compiler."
      export PZC_GPU_HOST_COMPILER="${PZC_SYCL_BIN}"
      export PZC_GPU_COMPILER="${PZC_SYCL_BIN}"
      if [[ -v _PZC_GPU_TARGET_ARCH ]]
      then
        export PZC_GPU_FLAGS="'--acpp-targets=cuda:sm_${_PZC_GPU_TARGET_ARCH}'"
      fi

      local _PZC_GPU_DEFAULT_COMPILER="SYCL"

    else
      _pzc_error "NVCC and SYCL are not available."
    fi

  else
    if [[ ${_PZC_SYCL_BIN_AVAILABLE} = 1 ]]
    then
      _pzc_debug "Default GPU compiler : SYCL"
      export PZC_GPU_HOST_COMPILER="${PZC_SYCL_BIN}"
      export PZC_GPU_COMPILER="${PZC_SYCL_BIN}"
      if [[ -v _PZC_GPU_TARGET_ARCH ]]
      then
        export PZC_GPU_FLAGS="'--acpp-targets=cuda:sm_${_PZC_GPU_TARGET_ARCH}'"
      fi

    elif [[ ${_PZC_NVCC_BIN_AVAILABLE} = 1 ]]
    then
      _pzc_error "SYCL is not available. Set NVCC to default GPU compiler."
      export PZC_GPU_HOST_COMPILER="${PZC_NVCC_HOST_COMPILER_BIN}"
      export PZC_GPU_COMPILER="${PZC_NVCC_BIN}"
      if [[ -v _PZC_GPU_TARGET_ARCH ]]
      then
        export PZC_GPU_FLAGS="'-gencode arch=compute_${_PZC_GPU_TARGET_ARCH},code=sm_${_PZC_GPU_TARGET_ARCH}'"
      fi

      local _PZC_GPU_DEFAULT_COMPILER="NVCC"

    else
      _pzc_error "NVCC and SYCL are not available."
    fi
  fi
else
  _pzc_debug "No GPU default compiler"
fi



# ---------------------------------------------------------------
# --------------------- OpenMPI variables -----------------------
# ---------------------------------------------------------------

export OMPI_MCA_rmaps_base_oversubscribe=true

