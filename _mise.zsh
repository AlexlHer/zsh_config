# -*- tab-width: 2; indent-tabs-mode: nil; coding: utf-8 -*-
# ------------------------------------------------------------------------------
# Copyright 2022-2026 Alexandre l'Heritier
# See the top-level LICENSE file for details.
# SPDX-License-Identifier: Apache-2.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# _mise.zsh
#
# Mise-en-place specific part.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------



# ---------------------------------------------------------------
# ---------------------------- Search ---------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_MISE_AVAILABLE} = 1 ]]
then

  if [[ -v PZC_MISE_BIN ]] && [[ -e ${PZC_MISE_BIN} ]]
  then
    _pzc_debug "PZC_MISE_BIN = ${PZC_MISE_BIN} (user defined)"

  elif [[ -v PZC_MISE_BIN ]]
  then
    _pzc_warning "Your mise-en-place is not found. Search other mise."
    _pzc_debug "PZC_MISE_BIN = ${PZC_MISE_BIN} (unset)"
    unset PZC_MISE_BIN

  fi

  if [[ ! -v PZC_MISE_BIN ]]
  then

    if [[ -x "$(command -v mise)" ]]
    then
      PZC_MISE_BIN=mise
      _PZC_MISE_AVAILABLE=1
      _pzc_debug "PZC_MISE_BIN = ${PZC_MISE_BIN} (in PATH)"

    elif [[ -e ${ENVI_DIR}/pzc/progs/mise/mise ]]
    then
      PZC_MISE_BIN=${ENVI_DIR}/pzc/progs/mise/mise
      _PZC_MISE_AVAILABLE=1
      _pzc_debug "PZC_MISE_BIN = ${PZC_MISE_BIN} (in pzc)"
      
    else
      _PZC_MISE_AVAILABLE=0
      _pzc_warning "Mise-en-place is not installed (https://github.com/jdx/mise). You can install mise-en-place in the PZC environment folder with the command 'pzc_install_mise' or disable mise search in .pzcrc."

    fi
  fi

else
  _pzc_debug "Mise disabled."

fi



# ---------------------------------------------------------------
# --------------------------- Install ---------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_MISE_AVAILABLE} = 0 ]]
then
  _pzc_debug "Define pzc_install_mise function"
  function pzc_install_mise()
  {
    local MISE_INSTALL_DIR="${ENVI_DIR}/pzc/progs/mise"

    _pzc_info "Install Mise in ${MISE_INSTALL_DIR} path."

    mkdir -p "${MISE_INSTALL_DIR}"

    wget -q -O "${TMP_DIR}/install_mise.sh" "https://github.com/jdx/mise/releases/latest/download/install.sh"

    _pzc_warning "Please check hash of 'install.sh' before continuing here : https://github.com/jdx/mise/releases/latest"
    _pzc_info "Hash (sha256) :"
    sha256sum "${TMP_DIR}/install_mise.sh"

    read -s -k $'?Press any key to continue install or Ctrl+C to stop here.\n'

    _pzc_info "You can check script with this command :"
    _pzc_coal "${PZC_FILE_EDITOR} \"${TMP_DIR}/install_mise.sh\""

    read -s -k $'?Press any key to launch script or Ctrl+C to stop here.\n'

    chmod u+x ${TMP_DIR}/install_mise.sh

    export MISE_INSTALL_PATH="${MISE_INSTALL_DIR}/mise"
    ${TMP_DIR}/install_mise.sh

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
# ---------------------------------------------------------------

if [[ ${_PZC_MISE_AVAILABLE} = 0 ]]
then
  return 0
fi

# ---------------------------------------------------------------
# ---------------------------------------------------------------



# ---------------------------------------------------------------
# ------------------------ Activate Mise ------------------------
# ---------------------------------------------------------------

_PZC_MISE_LOADED=0

if [[ ${_PZC_MISE_START_AT_LAUNCH} = 1 ]]
then
  _pzc_debug "Activate mise."
  eval "$(${PZC_MISE_BIN} activate zsh)"
  _PZC_MISE_LOADED=1

else
  _pzc_debug "Define smise function"
  function smise()
  {
    _pzc_info "Activate mise."
    eval "$(${PZC_MISE_BIN} activate zsh)"
    _PZC_MISE_LOADED=1
  }
fi

# TODO : Voir pour demander à mise directement.
PZC_MISE_INSTALL_DIR=${HOME}/.local/share/mise/installs
