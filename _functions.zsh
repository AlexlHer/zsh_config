
## --- Functions section ---



# ---------------------------------------------------------------
# -------------------- EXA-LS/LS Functions ----------------------
# ---------------------------------------------------------------

# If EXA-LS is installed.
if [[ ${_PZC_EXA_AVAILABLE} = 1 ]]
then
  _pzc_debug "Define functions for EXA-LS."

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
    local NUM_FILES="${1:-3}"
    grep --color=always -E -- "$(l -snew | tail -n${NUM_FILES})|$" <(l)
  }

  # Color $1 or 3 last edited files (cached files edition).
  llla()
  {
    local NUM_FILES="${1:-3}"
    grep --color=always -E -- "$(la -snew | tail -n${NUM_FILES})|$" <(la)
  }

else
  _pzc_debug "Define functions for LS (not EXA-LS)."

  # Color $1 or 3 last edited files.
  lll()
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
  _pzc_coal_eval "export CC=clang"
  _pzc_coal_eval "export CXX=clang++"
  if [[ ${_PZC_MOLD_AVAILABLE} = 1 ]]
  then
  _pzc_coal_eval "export CFLAGS='-fuse-ld=${_PZC_MOLD_PATH}'"
  _pzc_coal_eval "export CXXFLAGS='-fuse-ld=${_PZC_MOLD_PATH}'"
  fi
}

# Define "GCC" to CMake default compiler.
ugcc()
{
  _pzc_coal_eval "export CC=gcc"
  _pzc_coal_eval "export CXX=g++"
  if [[ ${_PZC_MOLD_AVAILABLE} = 1 ]]
  then
  _pzc_coal_eval "export CFLAGS='-fuse-ld=${_PZC_MOLD_PATH}'"
  _pzc_coal_eval "export CXXFLAGS='-fuse-ld=${_PZC_MOLD_PATH}'"
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
# ------------------ Proton/Wine Functions ----------------------
# ---------------------------------------------------------------

runproton()
{
  source ${_PZC_PZC_DIR}/scripts/proton_vars.sh
  "${PROTON_EXE}" run ${1}
}



# ---------------------------------------------------------------
# ----------------------- Age Functions -------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_AGE_AVAILABLE} = 1 ]]
then
  _pzc_debug "Define functions for AGE/RAGE."
  agee()
  {
    if [[ -v 1 ]]
    then
      mkdir -p ${_PZC_TMP_DIR}/age
      ${_PZC_AGE_PATH} -d -i ${_PZC_SSH_PRI} -o ${_PZC_TMP_DIR}/age/keys.txt ${_PZC_PZC_DIR}/keys/keys.txt
      ${_PZC_AGE_PATH} -e -R ${_PZC_TMP_DIR}/age/keys.txt -a -o ${1}.age ${1}
      rm ${_PZC_TMP_DIR}/age/keys.txt

    else
      _pzc_error "Need input file."

    fi
  }

  aged()
  {
    if [[ -v 1 ]]
    then
      ${_PZC_AGE_PATH} -d -i ${_PZC_SSH_PRI} -o ${1}.dec ${1}

    else
      _pzc_error "Need encrypted input file."

    fi
  }
else
  _pzc_debug "Age disabled, agee and aged functions not defined."

fi



# ---------------------------------------------------------------
# ----------------------- Todo function -------------------------
# ---------------------------------------------------------------

todo()
{
  if [[ -v _PZC_TODOLIST_PATH ]] && [[ -e ${_PZC_TODOLIST_PATH} ]]
  then

    if [[ ${_PZC_TODOLIST_ENC} = 1 ]]
    then

      if [[ -v _PZC_AGE_PATH ]]
      then
        _pzc_info "Create backup."
        \cp ${_PZC_TODOLIST_PATH} ${_PZC_TODOLIST_PATH}.old
        \cp ${_PZC_TODOLIST_PATH} ${_PZC_TMP_DIR}/todolist_enc.old

        _pzc_info "Decrypting file."
        aged ${_PZC_TMP_DIR}/todolist_enc.old

        _pzc_info "Launch ${_PZC_FILE_EDITOR}..."
        ${_PZC_FILE_EDITOR} ${_PZC_TMP_DIR}/todolist_enc.old.dec

        _pzc_info "Encrypting new file."
        agee ${_PZC_TMP_DIR}/todolist_enc.old.dec
        rm ${_PZC_TMP_DIR}/todolist_enc.old.dec

        _pzc_info "Move new encrypted file."
        \mv ${_PZC_TMP_DIR}/todolist_enc.old.dec.age ${_PZC_TODOLIST_PATH}

      else
        _pzc_error "Age not found, not possible to decrypt your TODOlist."
        return 1
      fi

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
    _pzc_error "_PZC_TODOLIST_PATH not define. Check your .zshrc."
    return 1

  fi
}
