
## --- Encrypt/Decrypt functions section ---



# ---------------------------------------------------------------
# -------------------------- Age/Rage ---------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_AGE_AVAILABLE} = 1 ]]
then

  if [[ -v _PZC_SSH_PUB ]] && [[ -e ${_PZC_SSH_PUB} ]] && [[ -v _PZC_SSH_PRI ]] && [[ -e ${_PZC_SSH_PRI} ]]
  then

    if [[ -v _PZC_AGE_BIN ]] && [[ -e ${_PZC_AGE_BIN} ]]
    then
      _pzc_debug "_PZC_AGE_BIN = ${_PZC_AGE_BIN} (user defined)"

    elif [[ -v _PZC_AGE_BIN ]]
    then
      _pzc_warning "Your age is not found. Search other age."
      _pzc_debug "_PZC_AGE_BIN = ${_PZC_AGE_BIN} (unset)"
      unset _PZC_AGE_BIN

    fi

    if [[ ! -v _PZC_AGE_BIN ]]
    then

      if [[ -x "$(command -v age)" ]]
      then
        _PZC_AGE_BIN=age
        _PZC_AGE_AVAILABLE=1
        _pzc_debug "_PZC_AGE_BIN = ${_PZC_AGE_BIN} (in PATH) (AGE)"

      elif [[ -x "$(command -v rage)" ]]
      then
        _PZC_AGE_BIN=rage
        _PZC_AGE_AVAILABLE=1
        _pzc_debug "_PZC_AGE_BIN = ${_PZC_AGE_BIN} (in PATH) (RAGE)"

      elif [[ -e ${_PZC_PZC_DIR}/progs/age/age ]]
      then
        _PZC_AGE_BIN=${_PZC_PZC_DIR}/progs/age/age
        _PZC_AGE_AVAILABLE=1
        _pzc_debug "_PZC_AGE_BIN = ${_PZC_AGE_BIN} (in pzc) (AGE)"
        
      else
        _PZC_AGE_AVAILABLE=0
        _pzc_warning "Age is not installed (https://github.com/FiloSottile/age). You can install age in the PZC folder with the command 'pzc_install_age' or disable age search in .zshrc."

      fi
    fi
  else
    unset _PZC_AGE_BIN
    _PZC_AGE_AVAILABLE=0
    _pzc_warning "Public key and/or private key not defined in .zshrc."
    _pzc_debug "_PZC_SSH_PUB = ${_PZC_SSH_PUB}"
    _pzc_debug "_PZC_SSH_PRI = ${_PZC_SSH_PRI}"

  fi
else
  _pzc_debug "Age disabled."

fi



# ------------------------
# --------- Age ----------
# ------------------------

if [[ ${_PZC_AGE_AVAILABLE} = 0 ]]
then
  _pzc_debug "Define pzc_install_age function"
  pzc_install_age()
  {
    _pzc_info "Install AGE in PZC folder..."

    _pzc_debug "Download AGE in TMP folder"
    wget -q -O "${_PZC_TMP_DIR}/age_archive.tar.gz" "https://github.com/FiloSottile/age/releases/download/v1.1.1/age-v1.1.1-linux-amd64.tar.gz"

    _pzc_debug "Untar AGE archive in TMP/age_archive folder"
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
      ${_PZC_AGE_BIN} -d -i ${_PZC_SSH_PRI} -o ${_PZC_TMP_DIR}/age/keys.txt ${_PZC_PZC_DIR}/keys/keys.txt
      ${_PZC_AGE_BIN} -e -R ${_PZC_TMP_DIR}/age/keys.txt -a -o ${1}.age ${1}
      rm ${_PZC_TMP_DIR}/age/keys.txt

    else
      _pzc_error "Need input file."

    fi
  }

  aged()
  {
    if [[ -v 1 ]]
    then
      ${_PZC_AGE_BIN} -d -i ${_PZC_SSH_PRI} -o ${1}.dec ${1}

    else
      _pzc_error "Need encrypted input file."

    fi
  }
else
  _pzc_debug "Age disabled, agee and aged functions not defined."

fi



# ---------------------------------------------------------------
# -------------------- SecureFile function ----------------------
# ---------------------------------------------------------------

sf()
{
  if [[ -v 1 ]]
  then
    if [[ ${_PZC_AGE_AVAILABLE} = 1 ]]
    then
      if [[ -e ${1} ]]
      then
        _pzc_info "Create backup."
        \cp ${1} ${1}.old
        \cp ${1} ${_PZC_TMP_DIR}/file_enc.old

        _pzc_info "Decrypting file."
        aged ${_PZC_TMP_DIR}/file_enc.old
      else
        _pzc_warning "File not found. Creating it..."
      fi

      _pzc_info "Launch ${_PZC_FILE_EDITOR}..."
      ${_PZC_FILE_EDITOR} ${_PZC_TMP_DIR}/file_enc.old.dec

      _pzc_info "Encrypting new file."
      agee ${_PZC_TMP_DIR}/file_enc.old.dec
      rm ${_PZC_TMP_DIR}/file_enc.old.dec

      _pzc_info "Move new encrypted file."
      \mv ${_PZC_TMP_DIR}/file_enc.old.dec.age ${1}

    else
      _pzc_error "Age not found, not possible to decrypt your file."
      return 1
    fi

  else
    _pzc_error "Need encrypted input file."

  fi
}