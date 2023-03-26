
## ----- External progs search section -----



# ---------------------------------------------------------------
# ------------------------ Check editor -------------------------
# ---------------------------------------------------------------

if [[ ! -v _PZC_FILE_EDITOR ]]
then
  _pzc_debug "_PZC_FILE_EDITOR is not set. Default editor is set to vim."
  local _PZC_FILE_EDITOR=vim
fi


# ---------------------------------------------------------------
# -------------------------- Check tmp --------------------------
# ---------------------------------------------------------------

if [[ ! -v _PZC_TMP_DIR ]]
then
  _pzc_debug "_PZC_TMP_DIR is not set. Default directory is set to '/tmp'."
  local _PZC_TMP_DIR=/tmp
fi



# ---------------------------------------------------------------
# -------------------------- OhMyPosh ---------------------------
# ---------------------------------------------------------------

if [[ -v _PZC_OMP_PATH ]] && [[ ! -e ${_PZC_OMP_PATH} ]]
then
  _pzc_warning "Your oh-my-posh is not found. Search other oh-my-posh."
  _pzc_debug "_PZC_OMP_PATH = ${_PZC_OMP_PATH} (unset)"
  unset _PZC_OMP_PATH

fi

if [[ ! -v _PZC_OMP_PATH ]]
then

  if [[ -x "$(command -v oh-my-posh)" ]]
  then
    _PZC_OMP_PATH=oh-my-posh
    _pzc_debug "_PZC_OMP_PATH = ${_PZC_OMP_PATH} (in PATH)"

  elif [[ -e ${_PZC_PZC_DIR}/progs/oh-my-posh/oh-my-posh ]]
  then
    _PZC_OMP_PATH=${_PZC_PZC_DIR}/progs/oh-my-posh/oh-my-posh
    _pzc_debug "_PZC_OMP_PATH = ${_PZC_OMP_PATH} (in pzc)"

  else
    _pzc_warning "Oh-my-posh is not installed (https://github.com/JanDeDobbeleer/oh-my-posh)."

  fi
fi



if [[ -v _PZC_OMP_THEME_PATH ]] && [[ ! -e ${_PZC_OMP_THEME_PATH} ]]
then
  _pzc_warning "Your oh-my-posh theme is not found. Search default oh-my-posh theme."
  _pzc_debug "_PZC_OMP_THEME_PATH = ${_PZC_OMP_THEME_PATH} (unset)"
  unset _PZC_OMP_THEME_PATH

fi

if [[ ! -v _PZC_OMP_THEME_PATH ]]
then

  if [[ -e ${_PZC_PZC_DIR}/progs/oh-my-posh/themes/OhMyZSH.json ]]
  then
    _PZC_OMP_THEME_PATH=${_PZC_PZC_DIR}/progs/oh-my-posh/themes/OhMyZSH.json
    _pzc_debug "_PZC_OMP_THEME_PATH = ${_PZC_OMP_THEME_PATH} (default)"

  else
    _pzc_warning "Default oh-my-posh theme is not found (https://github.com/JanDeDobbeleer/oh-my-posh)."

  fi
fi



# ---------------------------------------------------------------
# -------------------------- Age/Rage ---------------------------
# ---------------------------------------------------------------

if [[ -v _PZC_SSH_PUB ]] && [[ -e ${_PZC_SSH_PUB} ]] && [[ -v _PZC_SSH_PRI ]] && [[ -e ${_PZC_SSH_PRI} ]]
then

  if [[ -v _PZC_AGE_PATH ]] && [[ ! -e ${_PZC_AGE_PATH} ]]
  then
    _pzc_warning "Your age is not found. Search other age."
    _pzc_debug "_PZC_AGE_PATH = ${_PZC_AGE_PATH} (unset)"
    unset _PZC_AGE_PATH

  fi

  if [[ ! -v _PZC_AGE_PATH ]]
  then

    if [[ -x "$(command -v age)" ]]
    then
      _PZC_AGE_PATH=age
      _pzc_debug "_PZC_AGE_PATH = ${_PZC_AGE_PATH} (in PATH) (AGE)"

    elif [[ -x "$(command -v rage)" ]]
    then
      _PZC_AGE_PATH=rage
      _pzc_debug "_PZC_AGE_PATH = ${_PZC_AGE_PATH} (in PATH) (RAGE)"

    elif [[ -e ${_PZC_PZC_DIR}/progs/age/age ]]
    then
      _PZC_AGE_PATH=${_PZC_PZC_DIR}/progs/age/age
      _pzc_debug "_PZC_AGE_PATH = ${_PZC_AGE_PATH} (in pzc) (AGE)"
      
    else
      _pzc_warning "Age is not installed (https://github.com/FiloSottile/age)."

    fi
  fi
else
  _pzc_warning "Public key and/or private key not defined in .zshrc."
  unset _PZC_AGE_PATH
  _pzc_debug "_PZC_SSH_PUB = ${_PZC_SSH_PUB}"
  _pzc_debug "_PZC_SSH_PRI = ${_PZC_SSH_PRI}"

fi



# ---------------------------------------------------------------
# --------------------------- EXA-LS ----------------------------
# ---------------------------------------------------------------

if [[ -v _PZC_EXA_PATH ]] && [[ ! -e ${_PZC_EXA_PATH} ]]
then
  _pzc_warning "Your exa is not found. Search other exa."
  _pzc_debug "_PZC_EXA_PATH = ${_PZC_EXA_PATH} (unset)"
  unset _PZC_EXA_PATH

fi

if [[ ! -v _PZC_EXA_PATH ]]
then

  if [[ -x "$(command -v exa)" ]]
  then
    _PZC_EXA_PATH=exa
    _pzc_debug "_PZC_EXA_PATH = ${_PZC_EXA_PATH} (in PATH)"

  elif [[ -e ${_PZC_PZC_DIR}/progs/exa/exa ]]
  then
    _PZC_EXA_PATH=${_PZC_PZC_DIR}/progs/exa/exa
    _pzc_debug "_PZC_EXA_PATH = ${_PZC_EXA_PATH} (in pzc)"
    
  else
    _pzc_warning "Exa is not installed (https://github.com/ogham/exa)."

  fi
fi



# ---------------------------------------------------------------
# ---------------------------- Mold -----------------------------
# ---------------------------------------------------------------

if [[ -v _PZC_MOLD_PATH ]] && [[ ! -e ${_PZC_MOLD_PATH} ]]
then
  _pzc_warning "Your mold is not found. Search other mold."
  _pzc_debug "_PZC_MOLD_PATH = ${_PZC_MOLD_PATH} (unset)"
  unset _PZC_MOLD_PATH

fi

if [[ ! -v _PZC_MOLD_PATH ]]
then

  if [[ -x "$(command -v mold)" ]]
  then
    _PZC_MOLD_PATH=mold
    _pzc_debug "_PZC_MOLD_PATH = ${_PZC_MOLD_PATH} (in PATH)"

  elif [[ -e ${_PZC_PZC_DIR}/progs/mold/mold ]]
  then
    _PZC_MOLD_PATH=${_PZC_PZC_DIR}/progs/mold/mold
    _pzc_debug "_PZC_MOLD_PATH = ${_PZC_MOLD_PATH} (in pzc)"
    
  else
    _pzc_info "Mold is not installed (https://github.com/rui314/mold)."

  fi
fi
