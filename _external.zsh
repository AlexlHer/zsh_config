
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

if [[ ${_PZC_OMP_AVAILABLE} = 1 ]]
then

  if [[ -v _PZC_OMP_PATH ]] && [[ ! -e ${_PZC_OMP_PATH} ]]
  then
    _pzc_warning "Your Oh-My-Posh is not found. Search other Oh-My-Posh."
    _pzc_debug "_PZC_OMP_PATH = ${_PZC_OMP_PATH} (unset)"
    unset _PZC_OMP_PATH

  fi

  if [[ ! -v _PZC_OMP_PATH ]]
  then

    if [[ -x "$(command -v oh-my-posh)" ]]
    then
      _PZC_OMP_PATH=oh-my-posh
      _PZC_OMP_AVAILABLE=1
      _pzc_debug "_PZC_OMP_PATH = ${_PZC_OMP_PATH} (in PATH)"

    elif [[ -e ${_PZC_PZC_DIR}/progs/oh-my-posh/oh-my-posh ]]
    then
      _PZC_OMP_PATH=${_PZC_PZC_DIR}/progs/oh-my-posh/oh-my-posh
      _PZC_OMP_AVAILABLE=1
      _pzc_debug "_PZC_OMP_PATH = ${_PZC_OMP_PATH} (in pzc)"

    else
      _PZC_OMP_AVAILABLE=0
      _pzc_warning "Oh-My-Posh is not installed (https://github.com/JanDeDobbeleer/oh-my-posh). You can install Oh-My-Posh in the PZC folder with the command 'pzc_install_omp' or disable Oh-My-Posh search in .zshrc."

    fi
  fi


  if [[ -v _PZC_OMP_THEME_PATH ]] && [[ ! -e ${_PZC_OMP_THEME_PATH} ]]
  then
    _pzc_warning "Your Oh-My-Posh theme is not found. Search default Oh-My-Posh theme."
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
      _pzc_warning "Default Oh-My-Posh theme is not found (https://github.com/JanDeDobbeleer/oh-my-posh)."
      _PZC_OMP_AVAILABLE=0

    fi
  fi
else
  _pzc_debug "Oh-My-Posh disabled"

fi





# ---------------------------------------------------------------
# -------------------------- Age/Rage ---------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_AGE_AVAILABLE} = 1 ]]
then

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
        _PZC_AGE_AVAILABLE=1
        _pzc_debug "_PZC_AGE_PATH = ${_PZC_AGE_PATH} (in PATH) (AGE)"

      elif [[ -x "$(command -v rage)" ]]
      then
        _PZC_AGE_PATH=rage
        _PZC_AGE_AVAILABLE=1
        _pzc_debug "_PZC_AGE_PATH = ${_PZC_AGE_PATH} (in PATH) (RAGE)"

      elif [[ -e ${_PZC_PZC_DIR}/progs/age/age ]]
      then
        _PZC_AGE_PATH=${_PZC_PZC_DIR}/progs/age/age
        _PZC_AGE_AVAILABLE=1
        _pzc_debug "_PZC_AGE_PATH = ${_PZC_AGE_PATH} (in pzc) (AGE)"
        
      else
        _PZC_AGE_AVAILABLE=0
        _pzc_warning "Age is not installed (https://github.com/FiloSottile/age). You can install age in the PZC folder with the command 'pzc_install_age' or disable age search in .zshrc."

      fi
    fi
  else
    unset _PZC_AGE_PATH
    _PZC_AGE_AVAILABLE=0
    _pzc_warning "Public key and/or private key not defined in .zshrc."
    _pzc_debug "_PZC_SSH_PUB = ${_PZC_SSH_PUB}"
    _pzc_debug "_PZC_SSH_PRI = ${_PZC_SSH_PRI}"

  fi
else
  _pzc_debug "Age disabled."

fi



# ---------------------------------------------------------------
# --------------------------- EXA-LS ----------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_EXA_AVAILABLE} = 1 ]]
then

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
      _PZC_EXA_AVAILABLE=1
      _pzc_debug "_PZC_EXA_PATH = ${_PZC_EXA_PATH} (in PATH)"

    elif [[ -e ${_PZC_PZC_DIR}/progs/exa/exa ]]
    then
      _PZC_EXA_PATH=${_PZC_PZC_DIR}/progs/exa/exa
      _PZC_EXA_AVAILABLE=1
      _pzc_debug "_PZC_EXA_PATH = ${_PZC_EXA_PATH} (in pzc)"
      
    else
      _PZC_EXA_AVAILABLE=0
      _pzc_warning "Exa is not installed (https://github.com/ogham/exa). You can install exa in the PZC folder with the command 'pzc_install_exa' or disable exa search in .zshrc."

    fi
  fi
else
  _pzc_debug "Exa disabled."

fi



# ---------------------------------------------------------------
# ---------------------------- Mold -----------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_MOLD_AVAILABLE} = 1 ]]
then

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
      _PZC_MOLD_AVAILABLE=1
      _pzc_debug "_PZC_MOLD_PATH = ${_PZC_MOLD_PATH} (in PATH)"
      
    else
      _PZC_MOLD_AVAILABLE=0
      _pzc_warning "Mold is not installed (https://github.com/rui314/mold). You can disable mold search in .zshrc."

    fi
  fi
else
  _pzc_debug "Mold disabled."

fi



# ---------------------------------------------------------------
# ---------------------- PZC Install Part -----------------------
# ---------------------------------------------------------------

# ------------------------
# ------ Oh-My-Posh ------
# ------------------------

if [[ ${_PZC_OMP_AVAILABLE} = 0 ]]
then
  pzc_install_omp()
  {
    _pzc_info "Install Oh-My-Posh in PZC folder..."

    _pzc_debug "MkDir progs/oh-my-posh"
    mkdir -p "${_PZC_PZC_DIR}/progs/oh-my-posh"

    _pzc_debug "Download Oh-My-Posh in PZC folder"
    wget -q -O "${_PZC_PZC_DIR}/progs/oh-my-posh/oh-my-posh" "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64"

    _pzc_debug "Change permission Oh-My-Posh exe"
    chmod u+x "${_PZC_PZC_DIR}/progs/oh-my-posh/oh-my-posh"

    if [[ $? = 0 ]]
    then
      _pzc_info "Reload ZSH..."
      exec zsh
    else
      _pzc_error "Error with wget call."
    fi
  }
fi



# ------------------------
# --------- Age ----------
# ------------------------

if [[ ${_PZC_AGE_AVAILABLE} = 0 ]]
then
  pzc_install_age()
  {
    _pzc_info "Install AGE in PZC folder..."

    _pzc_debug "Download AGE in TMP folder"
    wget -q -O "${_PZC_TMP_DIR}/age_archive.tar.gz" "https://github.com/FiloSottile/age/releases/download/v1.1.1/age-v1.1.1-linux-amd64.tar.gz"

    _pzc_debug "Unzip AGE archive in TMP/age_archive folder"
    tar -zxf "${_PZC_TMP_DIR}/age_archive.tar.gz" -C "${_PZC_TMP_DIR}"

    _pzc_debug "MkDir progs/age"
    mkdir -p "${_PZC_PZC_DIR}/progs/age"

    _pzc_debug "Copy age bin"
    cp "${_PZC_TMP_DIR}/age/age" "${_PZC_PZC_DIR}/progs/age/"

    if [[ $? = 0 ]]
    then
      _pzc_info "Reload ZSH..."
      exec zsh
    else
      _pzc_error "Error with wget call."
    fi
  }
fi



# ------------------------
# --------- EXA ----------
# ------------------------

if [[ ${_PZC_EXA_AVAILABLE} = 0 ]]
then
  pzc_install_exa()
  {
    _pzc_info "Install EXA in PZC folder..."

    _pzc_debug "Download EXA in TMP folder"
    wget -q -O "${_PZC_TMP_DIR}/exa_archive.zip" "https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip"

    _pzc_debug "Unzip EXA archive in TMP/exa_archive folder"
    unzip -q -n "${_PZC_TMP_DIR}/exa_archive.zip" -d "${_PZC_TMP_DIR}/exa_archive"

    _pzc_debug "MkDir progs/exa"
    mkdir -p "${_PZC_PZC_DIR}/progs/exa"

    _pzc_debug "Copy exa bin"
    cp "${_PZC_TMP_DIR}/exa_archive/bin/exa" "${_PZC_PZC_DIR}/progs/exa/"

    if [[ $? = 0 ]]
    then
      _pzc_info "Reload ZSH..."
      exec zsh
    else
      _pzc_error "Error with wget call."
    fi
  }
fi

