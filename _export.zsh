
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



# ---------------------------------------------------------------
# --------------------- OpenMPI variables -----------------------
# ---------------------------------------------------------------

export OMPI_MCA_rmaps_base_oversubscribe=true

