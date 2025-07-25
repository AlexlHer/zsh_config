
## --- Export variable section ---



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
  export CCACHE_MAXSIZE=20G

  if [[ -v CCACHE_DIR ]]
  then
    _pzc_debug "CCACHE_DIR is set. CCACHE_DIR = ${CCACHE_DIR}."

  else
    export CCACHE_DIR=${BUILD_DIR}/ccache
    _pzc_debug "CCACHE_DIR is not set. CCACHE_DIR = ${CCACHE_DIR}."
  fi

  mkdir -p ${CCACHE_DIR}

  _pzc_debug "Set PZC_CMAKE_CXX/CC_COMPILER_LAUNCHER"
  export PZC_CMAKE_CXX_COMPILER_LAUNCHER="-DCMAKE_CXX_COMPILER_LAUNCHER=${PZC_CCACHE_BIN}"
  export PZC_CMAKE_C_COMPILER_LAUNCHER="-DCMAKE_C_COMPILER_LAUNCHER=${PZC_CCACHE_BIN}"

fi

if [[ ${_PZC_MOLD_AVAILABLE} = 1 ]]
then
  _pzc_debug "Config Mold linker"

  if [[ ${_PZC_CMAKE_VERSION_MINOR} -gt 28 ]] || [[ ${_PZC_CMAKE_VERSION_MAJOR} -gt 3 ]] #>= 3.29
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
  PZC_CMAKE_GENERATOR="-GNinja"

  _pzc_debug "Customize status message"
  export NINJA_STATUS="-> %p [%f/%t][%r] "

fi


if [[ ${_PZC_C_CXX_AVAILABLE} = 1 ]]
then
  if [[ ${_PZC_C_CXX_DEFAULT_COMPILER} = "GCC" ]]
  then
    if [[ ${_PZC_GCC_AVAILABLE} = 1 ]]
    then
      _pzc_debug "Default C/CXX compiler : GCC"
      PZC_C_COMPILER="${PZC_C_GCC_BIN}"
      PZC_CXX_COMPILER="${PZC_CXX_GCC_BIN}"

    elif [[ ${_PZC_CLANG_AVAILABLE} = 1 ]]
    then
      _pzc_error "GCC is not available. Set CLANG to default C/CXX compiler."
      PZC_C_COMPILER="${PZC_C_CLANG_BIN}"
      PZC_CXX_COMPILER="${PZC_CXX_CLANG_BIN}"

    else
      _pzc_error "GCC and CLANG are not available."
    fi

  else
    if [[ ${_PZC_CLANG_AVAILABLE} = 1 ]]
    then
      _pzc_debug "Default C/CXX compiler : CLANG"
      PZC_C_COMPILER="${PZC_C_CLANG_BIN}"
      PZC_CXX_COMPILER="${PZC_CXX_CLANG_BIN}"

    elif [[ ${_PZC_GCC_AVAILABLE} = 1 ]]
    then
      _pzc_error "CLANG is not available. Set GCC to default C/CXX compiler."
      PZC_C_COMPILER="${PZC_C_GCC_BIN}"
      PZC_CXX_COMPILER="${PZC_CXX_GCC_BIN}"

    else
      _pzc_error "GCC and CLANG are not available."
    fi
  fi
else
  _pzc_debug "No C/CXX default compiler"
fi

if [[ ${_PZC_GPU_AVAILABLE} = 1 ]]
then
  if [[ ${PZC_GPU_DEFAULT_COMPILER} = "NVCC" ]]
  then
    if [[ ${_PZC_NVCC_BIN_AVAILABLE} = 1 ]]
    then
      _pzc_debug "Default GPU compiler : NVCC"
      PZC_GPU_HOST_COMPILER="${PZC_NVCC_HOST_COMPILER_BIN}"
      PZC_GPU_COMPILER="${PZC_NVCC_BIN}"

    elif [[ ${_PZC_SYCL_BIN_AVAILABLE} = 1 ]]
    then
      _pzc_error "NVCC is not available. Set SYCL to default GPU compiler."
      PZC_GPU_HOST_COMPILER="${PZC_SYCL_BIN}"
      PZC_GPU_COMPILER="${PZC_SYCL_BIN}"
      if [[ -v PZC_GPU_TARGET_ARCH ]]
      then
        PZC_GPU_FLAGS="'--acpp-targets=cuda:sm_${PZC_GPU_TARGET_ARCH}'"
      fi

      PZC_GPU_DEFAULT_COMPILER="SYCL"

    else
      _pzc_error "NVCC and SYCL are not available."
    fi

  else
    if [[ ${_PZC_SYCL_BIN_AVAILABLE} = 1 ]]
    then
      _pzc_debug "Default GPU compiler : SYCL"
      PZC_GPU_HOST_COMPILER="${PZC_SYCL_BIN}"
      PZC_GPU_COMPILER="${PZC_SYCL_BIN}"
      if [[ -v PZC_GPU_TARGET_ARCH ]]
      then
        PZC_GPU_FLAGS="'--acpp-targets=cuda:sm_${PZC_GPU_TARGET_ARCH}'"
      fi

    elif [[ ${_PZC_NVCC_BIN_AVAILABLE} = 1 ]]
    then
      _pzc_error "SYCL is not available. Set NVCC to default GPU compiler."
      PZC_GPU_HOST_COMPILER="${PZC_NVCC_HOST_COMPILER_BIN}"
      PZC_GPU_COMPILER="${PZC_NVCC_BIN}"

      PZC_GPU_DEFAULT_COMPILER="NVCC"

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

