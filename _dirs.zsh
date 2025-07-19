
## --- Dirs creation section ---



# ---------------------------------------------------------------
# --------------------- Work dirs creation ----------------------
# ---------------------------------------------------------------

if [[ ! -v _PZC_LARGE_DIR ]]
then
  _pzc_debug "_PZC_LARGE_DIR is not set. Default directory is set to '${HOME}'."
  local _PZC_LARGE_DIR=${HOME}
fi



if [[ -v TMP_DIR ]]
then
  _pzc_debug "TMP_DIR is set. TMP_DIR = ${TMP_DIR}."

else
  export TMP_DIR=/tmp/pzc
  _pzc_debug "TMP_DIR is not set. TMP_DIR = ${TMP_DIR}."

fi



if [[ -v WORK_DIR ]]
then
  _pzc_debug "WORK_DIR is set. WORK_DIR = ${WORK_DIR}."

else
  export WORK_DIR=${_PZC_LARGE_DIR}/work
  _pzc_debug "WORK_DIR is not set. WORK_DIR = ${WORK_DIR}."

fi



if [[ -v BUILD_DIR ]]
then
  _pzc_debug "BUILD_DIR is set. BUILD_DIR = ${BUILD_DIR}."

else
  export BUILD_DIR=${_PZC_LARGE_DIR}/build
  _pzc_debug "BUILD_DIR is not set. BUILD_DIR = ${BUILD_DIR}."

fi



if [[ -v INSTALL_DIR ]]
then
  _pzc_debug "INSTALL_DIR is set. INSTALL_DIR = ${INSTALL_DIR}."

else
  export INSTALL_DIR=${_PZC_LARGE_DIR}/install
  _pzc_debug "INSTALL_DIR is not set. INSTALL_DIR = ${INSTALL_DIR}."

fi



if [[ -v ENVI_DIR ]]
then
  _pzc_debug "ENVI_DIR is set. ENVI_DIR = ${ENVI_DIR}."

else
  export ENVI_DIR=${_PZC_LARGE_DIR}/environment
  _pzc_debug "ENVI_DIR is not set. ENVI_DIR = ${ENVI_DIR}."

fi



export CONTAINER_BUILD_DIR=${BUILD_DIR}/container
export PZC_USER_CONFIG_DIR=${ENVI_DIR}/pzc

_pzc_debug "Creating tmp, CCache, work, build, environment and container_build directories"
mkdir -p ${TMP_DIR} ${WORK_DIR} ${BUILD_DIR} ${INSTALL_DIR} ${ENVI_DIR} ${CONTAINER_BUILD_DIR} ${PZC_USER_CONFIG_DIR}

if [[ $? != 0 ]]
then
  _pzc_error "Error with mkdir. Check your export dir in .pzcrc. Enable debug mode in .pzcrc for more info."
  _PZC_FATAL_ERROR=1
fi
