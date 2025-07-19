
## ----- CMake functions section -----



# ---------------------------------------------------------------
# --------------- Create folder for init scripts ----------------
# ---------------------------------------------------------------

export PZC_EDIT_SCRIPTS=${PZC_USER_CONFIG_DIR}/cmake_scripts
mkdir -p ${PZC_EDIT_SCRIPTS}



# ---------------------------------------------------------------
# -------------------- Compatibility update ---------------------
# ---------------------------------------------------------------
# TODO : Delete this part in PZC v7

if [[ -d ${PZC_PZC_DIR}/arcane_scripts ]]
then
  _pzc_info "An old PZC version have been created arcane_scripts folder. Moving these scripts in ${PZC_EDIT_SCRIPTS}..."
  mv ${PZC_PZC_DIR}/arcane_scripts/* ${PZC_EDIT_SCRIPTS}
fi

# ---------------------------------------------------------------
# ----------------------- Init functions ------------------------
# ---------------------------------------------------------------

initcmp()
{
  if [[ -v 1 ]]
  then
    _pzc_info "Initialize CMake Project: ${1}"
    CMP_PROJECT_NAME=${1}
  else
    _pzc_error "Need project name (first arg)"
    return 1
  fi

  if [[ -v 2 ]]
  then
    if [[ ${2} == "D" ]] || [[ ${2} == "Debug" ]]
    then
      CMP_BUILD_TYPE=Debug
    elif [[ ${2} == "C" ]] || [[ ${2} == "Check" ]]
    then
      CMP_BUILD_TYPE=Check
    elif [[ ${2} == "R" ]] || [[ ${2} == "Release" ]]
    then
      CMP_BUILD_TYPE=Release
    else
      _pzc_error "Invalid 'CMP_BUILD_TYPE' (second arg)"
      return 1
    fi
  else
    _pzc_info "No argument, defining 'CMP_BUILD_TYPE' to 'Release'"
    CMP_BUILD_TYPE=Release
  fi

  if [[ -v 3 ]]
  then
    TYPE_BUILD_DIR=${3}
  else
    TYPE_BUILD_DIR=${CMP_BUILD_TYPE}
  fi

  local _PZC_EDIT_CMP_PATH="${PZC_EDIT_SCRIPTS}/editcmp_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.zsh"

  if [[ -e ${_PZC_EDIT_CMP_PATH} ]]
  then
    _pzc_info "The edit script exist. Overwrite default initialization."
    _pzc_coal_eval "source ${_PZC_EDIT_CMP_PATH}"

  else
    CMP_BUILD_TYPE="${CMP_BUILD_TYPE}"
    CMP_PROJECT_DIR="${WORK_DIR}/${CMP_PROJECT_NAME}"
    CMP_SOURCE_DIR="${CMP_PROJECT_DIR}"
    CMP_BUILD_DIR="${BUILD_DIR}/build_${CMP_PROJECT_NAME}/${TYPE_BUILD_DIR}"
    CMP_INSTALL_DIR="${INSTALL_DIR}/install_${CMP_PROJECT_NAME}/${TYPE_BUILD_DIR}"
  fi

  mkdir -p "${CMP_BUILD_DIR}"
  cd "${CMP_BUILD_DIR}"

  _pzc_pensil_begin
  echo "CMP_PROJECT_NAME=${CMP_PROJECT_NAME}"
  echo "TYPE_BUILD_DIR=${TYPE_BUILD_DIR}"
  echo ""
  echo "CMP_BUILD_TYPE=${CMP_BUILD_TYPE}"
  echo "CMP_PROJECT_DIR=${CMP_PROJECT_DIR}"
  echo "CMP_SOURCE_DIR=${CMP_SOURCE_DIR}"
  echo "CMP_BUILD_DIR=${CMP_BUILD_DIR}"
  echo "CMP_INSTALL_DIR=${CMP_INSTALL_DIR}"
  echo ""
  echo "mkdir -p ${CMP_BUILD_DIR}"
  echo "cd ${CMP_BUILD_DIR}"
  _pzc_pensil_end
}



# ---------------------------------------------------------------
# -------------------- Edit init functions ----------------------
# ---------------------------------------------------------------

editcmp()
{
  if [[ ! -v CMP_BUILD_DIR ]]
  then
    _pzc_error "Lancer initcmp avant."
    return 1
  fi

  _pzc_info "Edit initialization of CMake Project: ${CMP_PROJECT_NAME}"
  _pzc_info "Type of build to edit: ${CMP_BUILD_TYPE}"
  _pzc_info "Subdir build to edit: ${TYPE_BUILD_DIR}"

  local _PZC_EDIT_CMP_PATH="${PZC_EDIT_SCRIPTS}/editcmp_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.zsh"

  _pzc_info "Location of the edit script: ${_PZC_EDIT_CMP_PATH}"


  if [[ -e ${_PZC_EDIT_CMP_PATH} ]]
  then
    _pzc_info "The edit script exist. Editing it..."
    _pzc_coal_eval "${PZC_FILE_EDITOR} ${_PZC_EDIT_CMP_PATH}"

  else
    _pzc_coal_eval "touch ${_PZC_EDIT_CMP_PATH}"

    _pzc_info "Creating the edit script..."

    echo "# Custom initialisation for the CMake project: ${CMP_PROJECT_NAME}" >> ${_PZC_EDIT_CMP_PATH}
    echo "# Type of build: ${CMP_BUILD_TYPE}" >> ${_PZC_EDIT_CMP_PATH}
    echo "# Subdir of build: ${TYPE_BUILD_DIR}\n" >> ${_PZC_EDIT_CMP_PATH}

    echo "# Type of build for this project:" >> ${_PZC_EDIT_CMP_PATH}
    echo "CMP_BUILD_TYPE=${CMP_BUILD_TYPE}\n" >> ${_PZC_EDIT_CMP_PATH}

    echo "# Directory with the project:" >> ${_PZC_EDIT_CMP_PATH}
    echo "CMP_PROJECT_DIR=${WORK_DIR}/${CMP_PROJECT_NAME}\n" >> ${_PZC_EDIT_CMP_PATH}

    echo "# Directory with the project source (with the CMakeLists.txt file):" >> ${_PZC_EDIT_CMP_PATH}
    echo "CMP_SOURCE_DIR=${CMP_PROJECT_DIR}\n" >> ${_PZC_EDIT_CMP_PATH}

    echo "# Directory needed for the project build:" >> ${_PZC_EDIT_CMP_PATH}
    echo "CMP_BUILD_DIR=${BUILD_DIR}/build_${CMP_PROJECT_NAME}/${TYPE_BUILD_DIR}\n" >> ${_PZC_EDIT_CMP_PATH}

    echo "# Directory where install the project:" >> ${_PZC_EDIT_CMP_PATH}
    echo "CMP_INSTALL_DIR=${INSTALL_DIR}/install_${CMP_PROJECT_NAME}/${TYPE_BUILD_DIR}\n" >> ${_PZC_EDIT_CMP_PATH}

    _pzc_coal_eval "${PZC_FILE_EDITOR} ${_PZC_EDIT_CMP_PATH}"
  fi

  echo ""
  _pzc_coal_eval "initcmp ${CMP_PROJECT_NAME} ${CMP_BUILD_TYPE} ${TYPE_BUILD_DIR}"
}

editcmprm()
{
  if [[ ! -v CMP_BUILD_DIR ]]
  then
    _pzc_error "Lancer initcmp avant."
    return 1
  fi

  _pzc_info "Remove initialization script of CMake Project: ${CMP_PROJECT_NAME}"
  _pzc_info "Type of build to remove: ${CMP_BUILD_TYPE}"
  _pzc_info "Subdir build to remove: ${TYPE_BUILD_DIR}"


  local _PZC_EDIT_CMP_PATH="${PZC_EDIT_SCRIPTS}/editcmp_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.zsh"

  _pzc_info "Location of the script: ${_PZC_EDIT_CMP_PATH}"

  if [[ -e ${_PZC_EDIT_CMP_PATH} ]]
  then
    _pzc_info "The edit script exist."

    local _PZC_TDIR=$(mktemp -d --tmpdir=${TMP_DIR})
    _pzc_info "Moving ${_PZC_EDIT_CMP_PATH} file in ${_PZC_TDIR} directory..."

    mv ${_PZC_EDIT_CMP_PATH} ${_PZC_TDIR}

    echo ""
    _pzc_coal_eval "initcmp ${CMP_PROJECT_NAME} ${CMP_BUILD_TYPE} ${TYPE_BUILD_DIR}"

  else
    _pzc_warning "The edit script doesn't exist."
    return 1
  fi
}



# ---------------------------------------------------------------
# ---------------------- Config functions -----------------------
# ---------------------------------------------------------------

pconfigcmp()
{
  if [[ -v CMP_BUILD_DIR ]]
  then

    if [[ "${CMP_BUILD_TYPE}" == "Check" ]]
    then
      CMAKE_BUILD_TYPE="RelWithDebInfo"
    else
      CMAKE_BUILD_TYPE="${CMP_BUILD_TYPE}"
    fi

    _pzc_pensil_begin
    echo "cmake \\"
    echo "  -S ${CMP_SOURCE_DIR} \\"
    echo "  -B ${CMP_BUILD_DIR} \\"
    echo "  -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \\"
    echo "  -DCMAKE_CXX_COMPILER=${PZC_CXX_COMPILER} \\"
    echo "  ${PZC_CMAKE_GENERATOR} \\"
    echo "  ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \\"
    echo "  ${PZC_CMAKE_C_COMPILER_LAUNCHER} \\"
    echo "  ${PZC_CMAKE_LINKER_TYPE} \\"
    echo "  -DCMAKE_INSTALL_PREFIX=${CMP_INSTALL_DIR} \\"
    echo "  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
    _pzc_pensil_end
      
  else
    _pzc_error "Lancer initcmp avant."
    return 1
  fi
}

configcmp()
{
  if [[ -v CMP_BUILD_DIR ]]
  then
    _pzc_info "Configure CMake Project: ${CMP_PROJECT_NAME}"
    pconfigcmp

    if [[ "${CMP_BUILD_TYPE}" == "Check" ]]
    then
      CMAKE_BUILD_TYPE="RelWithDebInfo"
    else
      CMAKE_BUILD_TYPE="${CMP_BUILD_TYPE}"
    fi

    cmake \
      -S ${CMP_SOURCE_DIR} \
      -B ${CMP_BUILD_DIR} \
      -DCMAKE_C_COMPILER=${PZC_C_COMPILER} \
      -DCMAKE_CXX_COMPILER=${PZC_CXX_COMPILER} \
      ${PZC_CMAKE_GENERATOR} \
      ${PZC_CMAKE_CXX_COMPILER_LAUNCHER} \
      ${PZC_CMAKE_C_COMPILER_LAUNCHER} \
      ${PZC_CMAKE_LINKER_TYPE} \
      -DCMAKE_INSTALL_PREFIX=${CMP_INSTALL_DIR} \
      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
      
  else
    _pzc_error "Lancer initcmp avant."
    return 1
  fi
}



# ---------------------------------------------------------------
# ----------------------- Clear functions -----------------------
# ---------------------------------------------------------------

clearcmp()
{
  if [[ -v CMP_BUILD_DIR ]]
  then
    _pzc_pensil_begin
    _pzc_ecal_eval "cd ${CMP_BUILD_DIR}/.."
    _pzc_ecal_eval "rm -r ${CMP_BUILD_DIR}"
    _pzc_ecal_eval "rm -r ${CMP_INSTALL_DIR}"
    _pzc_ecal_eval "mkdir ${CMP_BUILD_DIR}"
    _pzc_ecal_eval "mkdir ${CMP_INSTALL_DIR}"
    _pzc_ecal_eval "cd ${CMP_BUILD_DIR}"
    _pzc_pensil_end

  else
    _pzc_error "Un appel à la fonction initcmp est nécessaire avant."
    return 1
  fi
}
