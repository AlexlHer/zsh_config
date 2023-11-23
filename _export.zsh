
## --- Export variable section ---



# ---------------------------------------------------------------
# ---------------------- Export variables -----------------------
# ---------------------------------------------------------------

export WORK_DIR=${HOME}/work
export BUILD_DIR=${HOME}/build_install
export CONTAINER_BUILD_DIR=${BUILD_DIR}/container

export CCACHE_COMPRESS=true
export CCACHE_COMPRESSLEVEL=6
export CCACHE_DIR=${BUILD_DIR}/ccache
export CCACHE_MAXSIZE=20G

_pzc_debug "Creating CCache, work, build and container_build directories"
mkdir -p ${CCACHE_DIR} ${WORK_DIR} ${BUILD_DIR} ${CONTAINER_BUILD_DIR}

_pzc_debug "Exporting C/CXX to use GCC"
export CC=gcc
export CXX=g++
if [[ ${_PZC_MOLD_AVAILABLE} = 1 ]]
then
  _pzc_debug "Exporting C/CXX flags to use Mold linker"
  export CFLAGS="-fuse-ld=${_PZC_MOLD_PATH}"
  export CXXFLAGS="-fuse-ld=${_PZC_MOLD_PATH}"
fi



# ---------------------------------------------------------------
# --------------------- OpenMPI variables -----------------------
# ---------------------------------------------------------------

export OMPI_MCA_rmaps_base_oversubscribe=true

