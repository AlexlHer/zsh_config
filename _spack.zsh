# -*- tab-width: 2; indent-tabs-mode: nil; coding: utf-8 -*-
# ------------------------------------------------------------------------------
# Copyright 2022-2026 Alexandre l'Heritier
# See the top-level LICENSE file for details.
# SPDX-License-Identifier: Apache-2.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# _spack.zsh
#
# Spack specific part.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------



# ---------------------------------------------------------------
# ---------------------------- Search ---------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_SPACK_AVAILABLE} = 1 ]]
then

  if [[ -v PZC_SPACK_PATH ]]
  then
    if [[ -e ${PZC_SPACK_PATH}/share/spack/setup-env.sh ]]
    then
      _pzc_debug "PZC_SPACK_PATH = ${PZC_SPACK_PATH}"

    else
      _pzc_warning "Your Spack is not valid (\"${PZC_SPACK_PATH}/share/spack/setup-env.sh\" not found)."
      _pzc_debug "PZC_SPACK_PATH = ${PZC_SPACK_PATH} (unset)"
      unset PZC_SPACK_PATH
      _PZC_SPACK_AVAILABLE=0
      
    fi

  else

    PZC_SPACK_PATH="${ENVI_DIR}/spack"

    if [[ -e ${PZC_SPACK_PATH} ]]
    then
      if [[ -e ${PZC_SPACK_PATH}/share/spack/setup-env.sh ]]
      then
        _pzc_debug "PZC_SPACK_PATH = ${PZC_SPACK_PATH}"

      else
        _pzc_warning "The Spack install is not valid (\"${PZC_SPACK_PATH}/share/spack/setup-env.sh\" not found). You can delete it and reclone Spack."
        _pzc_debug "PZC_SPACK_PATH = ${PZC_SPACK_PATH} (unset)"
        unset PZC_SPACK_PATH
        _PZC_SPACK_AVAILABLE=0
      fi

    else
      _pzc_info "To initialise Spack, you can call pzc_install_spack function."
      _PZC_SPACK_AVAILABLE=0

    fi

  fi

else
  _pzc_debug "Spack disabled."

fi



# ---------------------------------------------------------------
# --------------------------- Install ---------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_SPACK_AVAILABLE} = 0 ]]
then
  _pzc_debug "Define pzc_install_spack function"
  pzc_install_spack()
  {
    PZC_SPACK_PATH="${ENVI_DIR}/spack"

    _pzc_info "Clone Spack repo in PZC ENVI folder ("${PZC_SPACK_PATH}")..."
    git clone --depth=2 https://github.com/spack/spack.git ${PZC_SPACK_PATH}

    if [[ $? = 0 ]]
    then
      _pzc_info "Done, reload ZSH..."
      exec zsh
    else
      _pzc_error "Error with git call."
    fi
  }
fi



# ---------------------------------------------------------------
# ------------------------- Source Spack ------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_SPACK_AVAILABLE} = 1 ]]
then
  _PZC_SPACK_LOADED=0

  _pzc_debug "Define ssp function"
  function ssp()
  {
    _pzc_info "Source spack setup-env.sh"
    . ${PZC_SPACK_PATH}/share/spack/setup-env.sh
    alias sp='spack'
    _PZC_SPACK_LOADED=1
  }

  if [[ ${_PZC_SPACK_START_AT_LAUNCH} = 1 ]]
  then
    _pzc_debug "Launching ssp function..."
    . ${PZC_SPACK_PATH}/share/spack/setup-env.sh
    alias sp='spack'
    _PZC_SPACK_LOADED=1
  fi

fi
