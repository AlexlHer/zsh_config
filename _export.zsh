
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

mkdir -p ${CCACHE_DIR} ${WORK_DIR} ${BUILD_DIR} ${CONTAINER_BUILD_DIR}



# ---------------------------------------------------------------
# --------------------- OpenMPI variables -----------------------
# ---------------------------------------------------------------

export OMPI_MCA_rmaps_base_oversubscribe=true

