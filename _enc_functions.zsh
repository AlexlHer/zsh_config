# -*- tab-width: 2; indent-tabs-mode: nil; coding: utf-8 -*-
# ------------------------------------------------------------------------------
# Copyright 2022-2026 Alexandre l'Heritier
# See the top-level LICENSE file for details.
# SPDX-License-Identifier: Apache-2.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# _enc_functions.zsh
#
# General functions to encrypt and decrypt files with Age/Rage.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------



# ---------------------------------------------------------------
# -------------------------- Age/Rage ---------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_AGE_AVAILABLE} = 1 ]]
then

  if [[ -v PZC_SSH_PUB ]] && [[ -e ${PZC_SSH_PUB} ]] && [[ -v PZC_SSH_PRI ]] && [[ -e ${PZC_SSH_PRI} ]]
  then

    if [[ -v PZC_AGE_BIN ]] && [[ -e ${PZC_AGE_BIN} ]]
    then
      _pzc_debug "PZC_AGE_BIN = ${PZC_AGE_BIN} (user defined)"

    elif [[ -v PZC_AGE_BIN ]]
    then
      _pzc_warning "Your age is not found. Search other age."
      _pzc_debug "PZC_AGE_BIN = ${PZC_AGE_BIN} (unset)"
      unset PZC_AGE_BIN

    fi

    if [[ ! -v PZC_AGE_BIN ]]
    then

      if [[ -x "$(command -v age)" ]]
      then
        PZC_AGE_BIN=age
        _PZC_AGE_AVAILABLE=1
        _pzc_debug "PZC_AGE_BIN = ${PZC_AGE_BIN} (in PATH) (AGE)"

      elif [[ -x "$(command -v rage)" ]]
      then
        PZC_AGE_BIN=rage
        _PZC_AGE_AVAILABLE=1
        _pzc_debug "PZC_AGE_BIN = ${PZC_AGE_BIN} (in PATH) (RAGE)"

      elif [[ -e ${PZC_PZC_DIR}/progs/age/age ]]
      then
        PZC_AGE_BIN=${PZC_PZC_DIR}/progs/age/age
        _PZC_AGE_AVAILABLE=1
        _pzc_debug "PZC_AGE_BIN = ${PZC_AGE_BIN} (in pzc) (AGE)"
        
      else
        _PZC_AGE_AVAILABLE=0
        _pzc_warning "Age is not installed (https://github.com/FiloSottile/age). You can install age in the PZC folder with the command 'pzc_install_age' or disable age search in .pzcrc."

      fi
    fi
  else
    unset PZC_AGE_BIN
    _PZC_AGE_AVAILABLE=0
    _pzc_warning "Public key and/or private key not defined in .pzcrc."
    _pzc_debug "PZC_SSH_PUB = ${PZC_SSH_PUB}"
    _pzc_debug "PZC_SSH_PRI = ${PZC_SSH_PRI}"

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
    wget -q -O "${TMP_DIR}/age_archive.tar.gz" "https://github.com/FiloSottile/age/releases/download/v1.1.1/age-v1.1.1-linux-amd64.tar.gz"

    _pzc_debug "Untar AGE archive in TMP/age_archive folder"
    tar -zxf "${TMP_DIR}/age_archive.tar.gz" -C "${TMP_DIR}"

    _pzc_debug "MkDir progs/age"
    mkdir -p "${PZC_PZC_DIR}/progs/age"

    _pzc_debug "Copy age bin"
    cp "${TMP_DIR}/age/age" "${PZC_PZC_DIR}/progs/age/"

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
      mkdir -p ${TMP_DIR}/age
      local _PZC_PUBLIC_KEYS_ENC=${PZC_USER_CONFIG_DIR}/keys/pkeys.txt

      if [[ ! -e ${_PZC_PUBLIC_KEYS_ENC} ]]
      then
        mkdir -p "${PZC_USER_CONFIG_DIR}/keys"
        _pzc_info "To use this function, we need your public keys."
        _pzc_warning "All of there associated private keys will be able to decrypt your file."
        _pzc_info "One public key per line."
        read -s -k $'?Press any key to continue.\n'
        "${PZC_FILE_EDITOR}" "${TMP_DIR}/age/pkeys.txt"
        _pzc_info "Encrypting your public keys with your local public key."
        "${PZC_AGE_BIN}" -e -R "${PZC_SSH_PUB}" -a -o "${_PZC_PUBLIC_KEYS_ENC}" "${TMP_DIR}/age/pkeys.txt"
        rm "${TMP_DIR}/age/pkeys.txt"
        _pzc_info "Your public keys will be available here: ${_PZC_PUBLIC_KEYS_ENC}"
      fi

      "${PZC_AGE_BIN}" -d -i "${PZC_SSH_PRI}" -o "${TMP_DIR}/age/pkeys.txt" "${_PZC_PUBLIC_KEYS_ENC}"
      "${PZC_AGE_BIN}" -e -R "${TMP_DIR}/age/pkeys.txt" -a -o "${1}.age" "${1}"
      rm "${TMP_DIR}/age/pkeys.txt"
      
    else
      _pzc_error "Need input file."

    fi
  }

  aged()
  {
    if [[ -v 1 ]]
    then
      "${PZC_AGE_BIN}" -d -i "${PZC_SSH_PRI}" -o "${1}.dec" "${1}"

    else
      _pzc_error "Need encrypted input file."

    fi
  }
else
  _pzc_debug "Age disabled, agee and aged functions not defined."
  agee()
  {
    _pzc_error "Age not available."
  }
  aged()
  {
    _pzc_error "Age not available."
  }
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
        \cp ${1} ${TMP_DIR}/file_enc.old

        _pzc_info "Decrypting file."
        aged ${TMP_DIR}/file_enc.old
      else
        _pzc_warning "File not found. Creating it..."
      fi

      _pzc_info "Launch ${PZC_FILE_EDITOR}..."
      ${PZC_FILE_EDITOR} ${TMP_DIR}/file_enc.old.dec

      _pzc_info "Encrypting new file."
      agee ${TMP_DIR}/file_enc.old.dec
      rm ${TMP_DIR}/file_enc.old.dec

      _pzc_info "Move new encrypted file."
      \mv ${TMP_DIR}/file_enc.old.dec.age ${1}

    else
      _pzc_error "Age not found, not possible to decrypt your file."
      return 1
    fi

  else
    _pzc_error "Need encrypted input file."

  fi
}
