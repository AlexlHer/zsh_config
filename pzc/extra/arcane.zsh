# -*- tab-width: 2; indent-tabs-mode: nil; coding: utf-8 -*-
# ------------------------------------------------------------------------------
# Copyright 2022-2026 Alexandre l'Heritier
# See the top-level LICENSE file for details.
# SPDX-License-Identifier: Apache-2.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# arcane.zsh
#
# Specific functions and aliases to work in/with the Framework Arcane.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------



## With these functions, you can clone, compile and install Arcane like this:
## $ clonearc    # First time only
## $ initarc R   # R for Release, C for Check, D for Debug
## $ configarc   # If cmake config needed
## $ biarc
##
## Source dir:
## $ gitarc
##
## Build dir:
## $ cd ${CMP_BUILD_DIR}
##
## Install dir:
## $ cd ${CMP_INSTALL_DIR}


# ---------------------------------------------------------------
# -------------------------- Aliases ----------------------------
# ---------------------------------------------------------------

alias clonearc='_pzc_coal_eval "mkdir -p ${WORK_DIR}/arcane" ; \
                _pzc_coal_eval "cd ${WORK_DIR}/arcane" ; \
                _pzc_coal_eval "git clone --recurse-submodules https://github.com/arcaneframework/framework" ; \
                gitarc'

function gitarc()
{
  local CMP_SOURCE_DIR="${WORK_DIR}/arcane/framework"
  if [[ -v 1 ]]
  then
    # TODO : Regex
    if [[ ${1} == "1" ]]
    then
      CMP_SOURCE_DIR="${WORK_DIR}/arcane/framework_wt1"
    else
      CMP_SOURCE_DIR="${WORK_DIR}/arcane/framework_${1}"
    fi
  fi
  _pzc_coal_eval "cd ${CMP_SOURCE_DIR}"
}



# ---------------------------------------------------------------
# ------------------ Generate preset functions ------------------
# ---------------------------------------------------------------

function parc()
{
  _pzc_warning "Deprecated function : use 'pcmp' instead."
  pcmp
  return $?
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function pap()
{
  _pzc_warning "Deprecated function : use 'pcmp' instead."
  pcmp
  return $?
}



# ---------------------------------------------------------------
# ----------------------- Init functions ------------------------
# ---------------------------------------------------------------

function initarc()
{

  if [[ -v 3 ]] && [[ ${3} != "_" ]] && [[ ${3} != "none" ]]
  then
    CMP_PROJECT_NAME=framework_${3}
  else
    CMP_PROJECT_NAME=framework
  fi

  CMP_PROJECT_TYPE=2

  _pzc_common_initcmp ${CMP_PROJECT_NAME} ${1} ${2}
  local RET_CODE=$?

  if [[ $RET_CODE != 0 ]]
  then
    return 1
  fi

  _pzc_pensil_begin
  echo "CMP_PROJECT_NAME=${CMP_PROJECT_NAME}"
  echo "TYPE_BUILD_DIR=${TYPE_BUILD_DIR}"
  echo ""
  echo "CMP_BUILD_TYPE=${CMP_BUILD_TYPE}"
  echo "CMP_SOURCE_DIR=${CMP_SOURCE_DIR}"
  echo "CMP_BUILD_DIR=${CMP_BUILD_DIR}"
  echo "CMP_INSTALL_DIR=${CMP_INSTALL_DIR}"
  echo ""
  echo "mkdir -p ${CMP_BUILD_DIR}"
  echo "cd ${CMP_BUILD_DIR}"
  _pzc_pensil_end
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function initap()
{
  CMP_PROJECT_TYPE=3

  _pzc_common_initcmp ${1} ${2} ${3}
  local RET_CODE=$?

  if [[ $RET_CODE != 0 ]]
  then
    return 1
  fi

  _pzc_pensil_begin
  echo "CMP_PROJECT_NAME=${CMP_PROJECT_NAME}"
  echo "TYPE_BUILD_DIR=${TYPE_BUILD_DIR}"
  echo ""
  echo "CMP_BUILD_TYPE=${CMP_BUILD_TYPE}"
  echo "CMP_SOURCE_DIR=${CMP_SOURCE_DIR}"
  echo "CMP_BUILD_DIR=${CMP_BUILD_DIR}"
  echo "CMP_INSTALL_DIR=${CMP_INSTALL_DIR}"
  echo ""
  echo "ARCANE_INSTALL_DIR=${ARCANE_INSTALL_DIR}"
  echo ""
  echo "mkdir -p ${CMP_BUILD_DIR}"
  echo "cd ${CMP_BUILD_DIR}"
  _pzc_pensil_end
}



# ---------------------------------------------------------------
# -------------------- Edit preset functions --------------------
# ---------------------------------------------------------------

function editparc()
{
  _pzc_warning "Deprecated function : use 'editpcmp' instead."
  editpcmp
  return $?
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function editpap()
{
  _pzc_warning "Deprecated function : use 'editpcmp' instead."
  editpcmp
  return $?
}



# ---------------------------------------------------------------
# -------------------- Save preset functions --------------------
# ---------------------------------------------------------------

function saveparc()
{
  _pzc_warning "Deprecated function : use 'savepcmp' instead."
  savepcmp
  return $?
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function savepap()
{
  _pzc_warning "Deprecated function : use 'savepcmp' instead."
  savepcmp
  return $?
}



# ---------------------------------------------------------------
# ---------------------- Config functions -----------------------
# ---------------------------------------------------------------

function configarc()
{
  _pzc_warning "Deprecated function : use 'configcmp' instead."
  configcmp
  return $?
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function configarcgpu()
{
  _pzc_warning "Deprecated function : use 'configcmpgpu' instead."
  configcmpgpu
  return $?
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function configap()
{
  _pzc_warning "Deprecated function : use 'configcmp' instead."
  configcmp
  return $?
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function configapgpu()
{
  _pzc_warning "Deprecated function : use 'configcmpgpu' instead."
  configcmpgpu
  return $?
}



# ---------------------------------------------------------------
# ------------------- Build/Install functions -------------------
# ---------------------------------------------------------------

function biarc()
{
  _pzc_warning "Deprecated function : use 'bicmp' instead."
  bicmp
  return $?
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function docarc()
{
  if [[ ! -v CMP_BUILD_DIR ]]
  then
    _pzc_error "You need to call 'initarc' command before."
    return 1
  fi

  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x ${CMP_BUILD_DIR}/bin/*
  fi
  cmake --build ${CMP_BUILD_DIR}
  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x ${CMP_BUILD_DIR}/bin/*
  fi
  cmake --build ${CMP_BUILD_DIR} --target ${1}doc
}



# ---------------------------------------------------------------
# ----------------------- Clear functions -----------------------
# ---------------------------------------------------------------

function cleararc()
{
  _pzc_warning "Deprecated function : use 'clearcmp' instead."
  clearcmp
  return $?
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

function clearap()
{
  _pzc_warning "Deprecated function : use 'clearcmp' instead."
  clearcmp
  return $?
}
