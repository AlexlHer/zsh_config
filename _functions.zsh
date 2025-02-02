
## --- Functions section ---



# ---------------------------------------------------------------
# -------------------- EZA-LS/LS Functions ----------------------
# ---------------------------------------------------------------

# Unalias ll if exist, to define ll function after.
unalias ll 2&>/dev/null || true

# If EZA-LS is installed.
if [[ ${_PZC_EZA_AVAILABLE} = 1 ]]
then
  _pzc_debug "Define functions for EZA-LS."

  # Tree version of l with custom depth.
  ll()
  {
    local DEPTH="${1:-1}"
    _pzc_coal_eval 'l -TL "${DEPTH}"'
  }

  # Tree version of la with custom depth.
  lla()
  {
    local DEPTH="${1:-1}"
    _pzc_coal_eval 'la -TL "${DEPTH}"'
  }

  # Color $1 or 3 last edited files.
  lll()
  {
    ${_PZC_EZA_BIN} --icons --color-scale --time-style long-iso --git -bghHlM -s=modified
  }
  llldum()
  {
    ${_PZC_EZA_BIN} --icons --color-scale --time-style long-iso --git --total-size -bghHlM -s=modified
  }

  # Color $1 or 3 last edited files (cached files edition).
  llla()
  {
    ${_PZC_EZA_BIN} --icons --color-scale --time-style long-iso --git -BghHlMa -s=modified
  }
  llladum()
  {
    ${_PZC_EZA_BIN} --icons --color-scale --time-style long-iso --git --total-size -BghHlMa -s=modified
  }

else
  _pzc_debug "Define functions for LS (not EZA-LS)."

  ll()
  {
    _pzc_coal_eval 'l'
  }

  # Tree version of la with custom depth.
  lla()
  {
    _pzc_coal_eval 'la'
  }

  # Color $1 or 3 last edited files.
  lll()
  {
    local NUM_FILES="${1:-3}"
    grep --color=always -E -- "$(l -rt | tail -n${NUM_FILES})|$" <(l)
  }
  llldum()
  {
    local NUM_FILES="${1:-3}"
    grep --color=always -E -- "$(l -rt | tail -n${NUM_FILES})|$" <(l)
  }

  # Color $1 or 3 last edited files (cache edition).
  llla()
  {
    local NUM_FILES="${1:-3}"
    grep --color=always -E -- "$(la -rt | tail -n${NUM_FILES})|$" <(la)
  }
  llladum()
  {
    local NUM_FILES="${1:-3}"
    grep --color=always -E -- "$(la -rt | tail -n${NUM_FILES})|$" <(la)
  }

fi



# ---------------------------------------------------------------
# ---------------------- Short Functions ------------------------
# ---------------------------------------------------------------

# Size of folders/files with custom depth.
dum()
{
  local DEPTH="${1:-0}"
  local CMDD=`du -ahc --time --max-depth=${DEPTH}`
  grep --color=always -E -- '$(echo "${CMDD}" | tail -n1)|$' <(echo "${CMDD}" | sort -h)
}

# "Find" alias with symlinks follow.
dinf()
{
  _pzc_coal 'find -L . -name "${1}" 2> /dev/null'
  find -L . -name "${1}" 2> /dev/null
}



# ---------------------------------------------------------------
# ---------------------- Export Functions -----------------------
# ---------------------------------------------------------------

# Define "CLang" to CMake default compiler.
uclang()
{
  if [[ ${_PZC_CLANG_AVAILABLE} = 1 ]]
  then
    export PZC_C_COMPILER="${PZC_C_CLANG_BIN}"
    export PZC_CXX_COMPILER="${PZC_CXX_CLANG_BIN}"
    _PZC_C_CXX_DEFAULT_COMPILER="CLANG"
    _pzc_info "Define CLang to default C/CXX compiler."
  
  else
    _pzc_error "CLang is not available."
  fi
}

# Define "GCC" to CMake default compiler.
ugcc()
{
  if [[ ${_PZC_GCC_AVAILABLE} = 1 ]]
  then
    export PZC_C_COMPILER="${PZC_C_GCC_BIN}"
    export PZC_CXX_COMPILER="${PZC_CXX_GCC_BIN}"
    _PZC_C_CXX_DEFAULT_COMPILER="GCC"
    _pzc_info "Define GCC to default C/CXX compiler."
  
  else
    _pzc_error "GCC is not available."
  fi
}

# Define "NVCC" to CMake default GPU compiler.
unvcc()
{
  if [[ ${_PZC_NVCC_BIN_AVAILABLE} = 1 ]]
  then
    export PZC_GPU_HOST_COMPILER="${PZC_NVCC_HOST_COMPILER_BIN}"
    export PZC_GPU_COMPILER="${PZC_NVCC_BIN}"
    unset PZC_GPU_FLAGS
    _PZC_GPU_DEFAULT_COMPILER="NVCC"
    _pzc_info "Define NVCC to default GPU compiler."
  
  else
    _pzc_error "NVCC is not available."
  fi
}

# Define "SYCL" to CMake default GPU compiler.
usycl()
{
  if [[ ${_PZC_SYCL_BIN_AVAILABLE} = 1 ]]
  then
    export PZC_GPU_HOST_COMPILER="${PZC_SYCL_BIN}"
    export PZC_GPU_COMPILER="${PZC_SYCL_BIN}"
    if [[ -v _PZC_GPU_TARGET_ARCH ]]
    then
      export PZC_GPU_FLAGS="'--acpp-targets=cuda:sm_${_PZC_GPU_TARGET_ARCH}'"
    fi

    _PZC_GPU_DEFAULT_COMPILER="SYCL"
    _pzc_info "Define SYCL to default GPU compiler."
  
  else
    _pzc_error "SYCL is not available."
  fi
}



# ---------------------------------------------------------------
# ---------------------- CTest Functions ------------------------
# ---------------------------------------------------------------

cti()
{
  local ARG1="${1:-0}"
  local ARG2="${2:-${ARG1}}"
  _pzc_coal_eval "ctest -I ${ARG1},${ARG2},1 --output-on-failure ${*:3}"
}

ctr()
{
  local ARG1="${1:-0}"
  _pzc_coal_eval "ctest -R \"${ARG1}\" --output-on-failure ${*:2}"
}

ctn()
{
  _pzc_coal_eval "ctest -N ${*:1}"
}

ctnr()
{
  local ARG1="${1:-0}"
  _pzc_coal_eval "ctest -N -R \"${ARG1}\" ${*:2}"
}

cta()
{
  local ARG1="${1:-1}"
  _pzc_coal_eval "ctest -j${ARG1} --repeat until-pass:3 --output-on-failure ${*:2}"
}



# ---------------------------------------------------------------
# ----------------------- Todo function -------------------------
# ---------------------------------------------------------------

todo()
{
  if [[ -v _PZC_TODOLIST_PATH ]] && [[ -e ${_PZC_TODOLIST_PATH} ]]
  then

    if [[ ${_PZC_TODOLIST_ENC} = 1 ]]
    then
      sf ${_PZC_TODOLIST_PATH}

    else
      _pzc_info "Create backup."
      \cp ${_PZC_TODOLIST_PATH} ${_PZC_TODOLIST_PATH}.old

      _pzc_info "Launch ${_PZC_FILE_EDITOR}..."
      ${_PZC_FILE_EDITOR} ${_PZC_TODOLIST_PATH}

    fi

  elif [[ ! -e ${_PZC_TODOLIST_PATH} ]]
  then
    _pzc_error "Your TODOlist is not found."
    _pzc_debug "_PZC_TODOLIST_PATH = ${_PZC_TODOLIST_PATH}"
    return 1

  else
    _pzc_error "_PZC_TODOLIST_PATH not define. Check your .pzcrc."
    return 1

  fi
}



# ---------------------------------------------------------------
# ----------------------- Tmp function --------------------------
# ---------------------------------------------------------------

tdir()
{
  export TDIR=$(mktemp -d --tmpdir=${_PZC_TMP_DIR})
  _pzc_info "Create new directory in ${_PZC_TMP_DIR} : ${TDIR}"
  _pzc_coal_eval "cd ${TDIR}"
}
