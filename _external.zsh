# -*- tab-width: 2; indent-tabs-mode: nil; coding: utf-8 -*-
# ------------------------------------------------------------------------------
# Copyright 2022-2026 Alexandre l'Heritier
# See the top-level LICENSE file for details.
# SPDX-License-Identifier: Apache-2.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# _external.zsh
#
# Check availability of external progs.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------



# ---------------------------------------------------------------
# ------------------------ Check editor -------------------------
# ---------------------------------------------------------------

if [[ ! -v PZC_FILE_EDITOR ]]
then
  _pzc_debug "PZC_FILE_EDITOR is not set. Default editor is set to vim."
  PZC_FILE_EDITOR=vim
fi



# ---------------------------------------------------------------
# ----------------------- Check compilers -----------------------
# ---------------------------------------------------------------

if [[ ${_PZC_GCC_AVAILABLE} = 1 ]]
then

  if [[ -v PZC_C_GCC_BIN ]] && [[ -x "$(command -v ${PZC_C_GCC_BIN})" ]]
  then
    _pzc_debug "PZC_C_GCC_BIN = ${PZC_C_GCC_BIN} (user defined)"

  elif [[ -v PZC_C_GCC_BIN ]]
  then
    _pzc_warning "Your gcc is not found. Search other gcc."
    _pzc_debug "PZC_C_GCC_BIN = ${PZC_C_GCC_BIN} (unset)"
    unset PZC_C_GCC_BIN

  fi

  if [[ ! -v PZC_C_GCC_BIN ]]
  then

    if [[ -x "$(command -v gcc)" ]]
    then
      PZC_C_GCC_BIN=gcc
      _PZC_GCC_AVAILABLE=1
      _pzc_debug "PZC_C_GCC_BIN = ${PZC_C_GCC_BIN} (in PATH)"
      
    else
      _PZC_GCC_AVAILABLE=0
      _pzc_warning "GCC is not installed. You can disable gcc search in .pzcrc."

    fi
  fi
else
  _pzc_debug "GCC disabled."

fi

if [[ ${_PZC_GCC_AVAILABLE} = 1 ]]
then

  if [[ -v PZC_CXX_GCC_BIN ]] && [[ -x "$(command -v ${PZC_CXX_GCC_BIN})" ]]
  then
    _pzc_debug "PZC_CXX_GCC_BIN = ${PZC_CXX_GCC_BIN} (user defined)"

  elif [[ -v PZC_CXX_GCC_BIN ]]
  then
    _pzc_warning "Your g++ is not found. Search other g++."
    _pzc_debug "PZC_CXX_GCC_BIN = ${PZC_CXX_GCC_BIN} (unset)"
    unset PZC_CXX_GCC_BIN

  fi

  if [[ ! -v PZC_CXX_GCC_BIN ]]
  then

    if [[ -x "$(command -v g++)" ]]
    then
      PZC_CXX_GCC_BIN=g++
      _PZC_GCC_AVAILABLE=1
      _pzc_debug "PZC_CXX_GCC_BIN = ${PZC_CXX_GCC_BIN} (in PATH)"
      
    else
      _PZC_GCC_AVAILABLE=0
      _pzc_warning "G++ is not installed. You can disable g++ search in .pzcrc."

    fi
  fi
else
  _pzc_debug "G++ disabled."

fi

if [[ ${_PZC_CLANG_AVAILABLE} = 1 ]]
then

  if [[ -v PZC_C_CLANG_BIN ]] && [[ -x "$(command -v ${PZC_C_CLANG_BIN})" ]]
  then
    _pzc_debug "PZC_C_CLANG_BIN = ${PZC_C_CLANG_BIN} (user defined)"

  elif [[ -v PZC_C_CLANG_BIN ]]
  then
    _pzc_warning "Your clang is not found. Search other clang."
    _pzc_debug "PZC_C_CLANG_BIN = ${PZC_C_CLANG_BIN} (unset)"
    unset PZC_C_CLANG_BIN

  fi

  if [[ ! -v PZC_C_CLANG_BIN ]]
  then

    if [[ -x "$(command -v clang)" ]]
    then
      PZC_C_CLANG_BIN=clang
      _PZC_CLANG_AVAILABLE=1
      _pzc_debug "PZC_C_CLANG_BIN = ${PZC_C_CLANG_BIN} (in PATH)"
      
    else
      _PZC_CLANG_AVAILABLE=0
      _pzc_warning "CLang is not installed. You can disable clang search in .pzcrc."

    fi
  fi
else
  _pzc_debug "CLang disabled."

fi

if [[ ${_PZC_CLANG_AVAILABLE} = 1 ]]
then

  if [[ -v PZC_CXX_CLANG_BIN ]] && [[ -x "$(command -v ${PZC_CXX_CLANG_BIN})" ]]
  then
    _pzc_debug "PZC_CXX_CLANG_BIN = ${PZC_CXX_CLANG_BIN} (user defined)"

  elif [[ -v PZC_CXX_CLANG_BIN ]]
  then
    _pzc_warning "Your clang++ is not found. Search other clang++."
    _pzc_debug "PZC_CXX_CLANG_BIN = ${PZC_CXX_CLANG_BIN} (unset)"
    unset PZC_CXX_CLANG_BIN

  fi

  if [[ ! -v PZC_CXX_CLANG_BIN ]]
  then

    if [[ -x "$(command -v clang++)" ]]
    then
      PZC_CXX_CLANG_BIN=clang++
      _PZC_CLANG_AVAILABLE=1
      _pzc_debug "PZC_CXX_CLANG_BIN = ${PZC_CXX_CLANG_BIN} (in PATH)"
      
    else
      _PZC_CLANG_AVAILABLE=0
      _pzc_warning "CLang++ is not installed. You can disable clang++ search in .pzcrc."

    fi
  fi
else
  _pzc_debug "CLang++ disabled."

fi

if [[ ${_PZC_NVCC_BIN_AVAILABLE} = 1 ]]
then

  if [[ -v PZC_NVCC_BIN ]] && [[ -x "$(command -v ${PZC_NVCC_BIN})" ]]
  then
    _pzc_debug "PZC_NVCC_BIN = ${PZC_NVCC_BIN} (user defined)"

  elif [[ -v PZC_NVCC_BIN ]]
  then
    _pzc_warning "Your nvcc is not found. Search other nvcc."
    _pzc_debug "PZC_NVCC_BIN = ${PZC_NVCC_BIN} (unset)"
    unset PZC_NVCC_BIN

  fi

  if [[ ! -v PZC_NVCC_BIN ]]
  then

    if [[ -x "$(command -v nvcc)" ]]
    then
      PZC_NVCC_BIN=nvcc
      _PZC_NVCC_BIN_AVAILABLE=1
      _pzc_debug "PZC_NVCC_BIN = ${PZC_NVCC_BIN} (in PATH)"
      
    else
      _PZC_NVCC_BIN_AVAILABLE=0
      _pzc_warning "NVCC is not installed. You can disable nvcc search in .pzcrc."

    fi
  fi

  if [[ ${_PZC_NVCC_BIN_AVAILABLE} = 1 ]]
  then

    if [[ -v PZC_NVCC_HOST_COMPILER_BIN ]] && [[ -x "$(command -v ${PZC_NVCC_HOST_COMPILER_BIN})" ]]
    then
      _pzc_debug "PZC_NVCC_HOST_COMPILER_BIN = ${PZC_NVCC_HOST_COMPILER_BIN} (user defined)"

    elif [[ -v PZC_NVCC_HOST_COMPILER_BIN ]]
    then
      _pzc_warning "Your host compiler for nvcc is not found. Search other one."
      _pzc_debug "PZC_NVCC_HOST_COMPILER_BIN = ${PZC_NVCC_HOST_COMPILER_BIN} (unset)"
      unset PZC_NVCC_HOST_COMPILER_BIN

    fi

    if [[ ! -v PZC_NVCC_HOST_COMPILER_BIN ]]
    then

      if [[ ${_PZC_GCC_AVAILABLE} = 1 ]]
      then
        PZC_NVCC_HOST_COMPILER_BIN=${PZC_CXX_GCC_BIN}
        _PZC_NVCC_BIN_AVAILABLE=1
        _pzc_debug "PZC_NVCC_HOST_COMPILER_BIN = ${PZC_NVCC_HOST_COMPILER_BIN} (G++) (in PATH)"

      elif [[ ${_PZC_CLANG_AVAILABLE} = 1 ]]
      then
        PZC_NVCC_HOST_COMPILER_BIN=${PZC_CXX_CLANG_BIN}
        _PZC_NVCC_BIN_AVAILABLE=1
        _pzc_debug "PZC_NVCC_HOST_COMPILER_BIN = ${PZC_NVCC_HOST_COMPILER_BIN} (CLang++) (in PATH)"

      else
        _PZC_NVCC_BIN_AVAILABLE=0
        _pzc_warning "Host compiler for nvcc is not found. You can disable nvcc search in .pzcrc."

      fi
    fi
  fi
else
  _pzc_debug "NVCC disabled."

fi

if [[ ${_PZC_SYCL_BIN_AVAILABLE} = 1 ]]
then

  if [[ -v PZC_SYCL_BIN ]] && [[ -x "$(command -v ${PZC_SYCL_BIN})" ]]
  then
    _pzc_debug "PZC_SYCL_BIN = ${PZC_SYCL_BIN} (user defined)"

  elif [[ -v PZC_SYCL_BIN ]]
  then
    _pzc_warning "Your sycl is not found. Search other sycl."
    _pzc_debug "PZC_SYCL_BIN = ${PZC_SYCL_BIN} (unset)"
    unset PZC_SYCL_BIN

  fi

  if [[ ! -v PZC_SYCL_BIN ]]
  then

    if [[ -x "$(command -v sycl)" ]]
    then
      PZC_SYCL_BIN=sycl
      _PZC_SYCL_BIN_AVAILABLE=1
      _pzc_debug "PZC_SYCL_BIN = ${PZC_SYCL_BIN} (in PATH)"
      
    else
      _PZC_SYCL_BIN_AVAILABLE=0
      _pzc_warning "Sycl is not installed. You can disable sycl search in .pzcrc."

    fi
  fi

  if [[ ${_PZC_SYCL_BIN_AVAILABLE} = 1 ]]
  then

    if [[ -v PZC_SYCL_HOST_COMPILER_BIN ]] && [[ -x "$(command -v ${PZC_SYCL_HOST_COMPILER_BIN})" ]]
    then
      _pzc_debug "PZC_SYCL_HOST_COMPILER_BIN = ${PZC_SYCL_HOST_COMPILER_BIN} (user defined)"

    elif [[ -v PZC_SYCL_HOST_COMPILER_BIN ]]
    then
      _pzc_warning "Your host compiler for sycl is not found. Search other one."
      _pzc_debug "PZC_SYCL_HOST_COMPILER_BIN = ${PZC_SYCL_HOST_COMPILER_BIN} (unset)"
      unset PZC_SYCL_HOST_COMPILER_BIN

    fi

    if [[ ! -v PZC_SYCL_HOST_COMPILER_BIN ]]
    then

      if [[ ${_PZC_CLANG_AVAILABLE} = 1 ]]
      then
        PZC_SYCL_HOST_COMPILER_BIN=${PZC_CXX_CLANG_BIN}
        _PZC_SYCL_BIN_AVAILABLE=1
        _pzc_debug "PZC_SYCL_HOST_COMPILER_BIN = ${PZC_SYCL_HOST_COMPILER_BIN} (CLang++) (in PATH)"

      elif [[ ${_PZC_GCC_AVAILABLE} = 1 ]]
      then
        PZC_SYCL_HOST_COMPILER_BIN=${PZC_CXX_GCC_BIN}
        _PZC_SYCL_BIN_AVAILABLE=1
        _pzc_debug "PZC_SYCL_HOST_COMPILER_BIN = ${PZC_SYCL_HOST_COMPILER_BIN} (G++) (in PATH)"

      else
        _PZC_SYCL_BIN_AVAILABLE=0
        _pzc_warning "Host compiler for sycl is not found. You can disable sycl search in .pzcrc."

      fi
    fi
  fi

else
  _pzc_debug "SYCL disabled."

fi

if [[ ${_PZC_GCC_AVAILABLE} = 1 ]] || [[ ${_PZC_CLANG_AVAILABLE} = 1 ]]
then
  local _PZC_C_CXX_AVAILABLE=1

else
  local _PZC_C_CXX_AVAILABLE=0
fi

if [[ ${_PZC_NVCC_BIN_AVAILABLE} = 1 ]] || [[ ${_PZC_SYCL_BIN_AVAILABLE} = 1 ]]
then
  local _PZC_GPU_AVAILABLE=1

else
  local _PZC_GPU_AVAILABLE=0
fi



# ---------------------------------------------------------------
# -------------------------- OhMyPosh ---------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_OMP_AVAILABLE} = 1 ]]
then

  if [[ -v _PZC_OMP_BIN ]] && [[ -e ${_PZC_OMP_BIN} ]]
  then
    _pzc_debug "_PZC_OMP_BIN = ${_PZC_OMP_BIN} (user defined)"

  elif [[ -v _PZC_OMP_BIN ]]
  then
    _pzc_warning "Your Oh-My-Posh is not found. Search other Oh-My-Posh."
    _pzc_debug "_PZC_OMP_BIN = ${_PZC_OMP_BIN} (unset)"
    unset _PZC_OMP_BIN

  fi

  if [[ ! -v _PZC_OMP_BIN ]]
  then

    if [[ -x "$(command -v oh-my-posh)" ]]
    then
      _PZC_OMP_BIN=oh-my-posh
      _PZC_OMP_AVAILABLE=1
      _pzc_debug "Oh-My-Posh found in PATH"

    else

      if [[ ${_PZC_MISE_AVAILABLE} = 1 ]]
      then
        _PZC_OMP_BIN=$(mise which --raw -C "${ENVI_DIR}/pzc/progs/mise" oh-my-posh 2&>/dev/null)
      fi

      if [[ -n ${_PZC_OMP_BIN} ]] && [[ -e ${_PZC_OMP_BIN} ]]
      then
        _PZC_OMP_AVAILABLE=1
        _pzc_debug "_PZC_OMP_BIN = ${_PZC_OMP_BIN} (with Mise-en-place)"

      elif [[ -e ${PZC_PZC_DIR}/progs/oh-my-posh/oh-my-posh ]]
      then
        _pzc_warning "Your installation of Oh-My-Posh is deprecated, please reinstall it with Mise-en-place and remove your actual install (${PZC_PZC_DIR}/progs/oh-my-posh/oh-my-posh)."
        _pzc_info "You can install Oh-My-Posh with Mise-en-place with this command 'pzc_install_omp'."
        _PZC_OMP_BIN=${PZC_PZC_DIR}/progs/oh-my-posh/oh-my-posh
        _PZC_OMP_AVAILABLE=1
        _pzc_debug "_PZC_OMP_BIN = ${_PZC_OMP_BIN} (in pzc)"

      else
        _PZC_OMP_AVAILABLE=0
        _pzc_warning "Oh-My-Posh is not installed (https://github.com/JanDeDobbeleer/oh-my-posh). You can install Oh-My-Posh with Mise-en-place with the command 'pzc_install_omp' or disable Oh-My-Posh search in .pzcrc."

      fi
    fi
  fi

else
  _pzc_debug "Oh-My-Posh disabled"

fi



# ---------------------------------------------------------------
# --------------------------- EZA-LS ----------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_EZA_AVAILABLE} = 1 ]]
then

  if [[ -v PZC_EZA_BIN ]] && [[ -e ${PZC_EZA_BIN} ]]
  then
    _pzc_debug "PZC_EZA_BIN = ${PZC_EZA_BIN} (user defined)"
    alias eza='${PZC_EZA_BIN}'
    _pzc_debug "Define alias eza"

  elif [[ -v PZC_EZA_BIN ]]
  then
    _pzc_warning "Your eza is not found. Search other eza."
    _pzc_debug "PZC_EZA_BIN = ${PZC_EZA_BIN} (unset)"
    unset PZC_EZA_BIN

  fi

  if [[ ! -v PZC_EZA_BIN ]]
  then

    if [[ -x "$(command -v eza)" ]]
    then
      PZC_EZA_BIN=eza
      _PZC_EZA_AVAILABLE=1
      _pzc_debug "EZA found in PATH"

    else

      if [[ ${_PZC_MISE_AVAILABLE} = 1 ]]
      then
        PZC_EZA_BIN=$(mise which --raw -C "${ENVI_DIR}/pzc/progs/mise" eza 2&>/dev/null)
      fi

      if [[ -n ${PZC_EZA_BIN} ]] && [[ -e ${PZC_EZA_BIN} ]]
      then
        _PZC_EZA_AVAILABLE=1
        _pzc_debug "PZC_EZA_BIN = ${PZC_EZA_BIN} (with Mise-en-place)"
        alias eza='${PZC_EZA_BIN}'
        _pzc_debug "Define alias eza"

      elif [[ -e ${PZC_PZC_DIR}/progs/eza/eza ]]
      then
        _pzc_warning "Your installation of EZA-LS is deprecated, please reinstall it with Mise-en-place and remove your actual EZA-LS install (${PZC_PZC_DIR}/progs/eza/eza)."
        _pzc_info "You can install eza with Mise-en-place with this command 'pzc_install_eza'."
        PZC_EZA_BIN=${PZC_PZC_DIR}/progs/eza/eza
        _PZC_EZA_AVAILABLE=1
        _pzc_debug "PZC_EZA_BIN = ${PZC_EZA_BIN} (in pzc)"
        alias eza='${PZC_EZA_BIN}'
        _pzc_debug "Define alias eza"
        
      else
        _PZC_EZA_AVAILABLE=0
        _pzc_warning "Eza is not installed (https://github.com/eza-community/eza). You can install eza with Mise-en-place with the command 'pzc_install_eza' or disable eza search in .pzcrc."

      fi
    fi
  fi

else
  _pzc_debug "Eza disabled."

fi



# ---------------------------------------------------------------
# --------------------------- CCache ----------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_CCACHE_AVAILABLE} = 1 ]]
then

  if [[ -v PZC_CCACHE_BIN ]] && [[ -e ${PZC_CCACHE_BIN} ]]
  then
    _pzc_debug "PZC_CCACHE_BIN = ${PZC_CCACHE_BIN} (user defined)"
    alias ccache='${PZC_CCACHE_BIN}'
    _pzc_debug "Define alias ccache"

  elif [[ -v PZC_CCACHE_BIN ]]
  then
    _pzc_warning "Your ccache is not found. Search other ccache."
    _pzc_debug "PZC_CCACHE_BIN = ${PZC_CCACHE_BIN} (unset)"
    unset PZC_CCACHE_BIN

  fi

  if [[ ! -v PZC_CCACHE_BIN ]]
  then

    if [[ -x "$(command -v ccache)" ]]
    then
      PZC_CCACHE_BIN=ccache
      _PZC_CCACHE_AVAILABLE=1
      _pzc_debug "CCache found in PATH"

    else

      if [[ ${_PZC_MISE_AVAILABLE} = 1 ]]
      then
        PZC_CCACHE_BIN=$(mise which --raw -C "${ENVI_DIR}/pzc/progs/mise" ccache 2&>/dev/null)
      fi

      if [[ -n ${PZC_CCACHE_BIN} ]] && [[ -e ${PZC_CCACHE_BIN} ]]
      then
        _PZC_CCACHE_AVAILABLE=1
        _pzc_debug "PZC_CCACHE_BIN = ${PZC_CCACHE_BIN} (with Mise-en-place)"
        alias ccache='${PZC_CCACHE_BIN}'
        _pzc_debug "Define alias ccache"

      else
        _PZC_CCACHE_AVAILABLE=0
        _pzc_warning "CCache is not installed (https://github.com/ccache/ccache). You can install ccache with Mise-en-place with the command 'pzc_install_ccache' or disable ccache search in .pzcrc."

      fi
    fi
  fi

else
  _pzc_debug "CCache disabled."

fi



# ---------------------------------------------------------------
# ---------------------------- Mold -----------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_MOLD_AVAILABLE} = 1 ]]
then

  if [[ -v _PZC_MOLD_PATH ]] && [[ -e ${_PZC_MOLD_PATH} ]]
  then
    _pzc_debug "_PZC_MOLD_PATH = ${_PZC_MOLD_PATH} (add in PATH)"
    export PATH=${_PZC_MOLD_PATH}:$PATH

  elif [[ -v _PZC_MOLD_PATH ]]
  then
    _pzc_warning "Your mold is not found. Search other mold."
    _pzc_debug "_PZC_MOLD_PATH = ${_PZC_MOLD_PATH} (unset)"
    unset _PZC_MOLD_PATH

  fi

  if [[ ! -v _PZC_MOLD_PATH ]]
  then

    if [[ -x "$(command -v mold)" ]]
    then
      _PZC_MOLD_AVAILABLE=1
      _pzc_debug "Mold found in PATH"

    else

      if [[ ${_PZC_MISE_AVAILABLE} = 1 ]]
      then
        _PZC_MOLD_PATH=$(mise which --raw -C "${ENVI_DIR}/pzc/progs/mise" mold 2&>/dev/null)
        _PZC_MOLD_PATH=$(dirname "${_PZC_MOLD_PATH}")
      fi

      if [[ -n ${_PZC_MOLD_PATH} ]] && [[ -e ${_PZC_MOLD_PATH} ]]
      then
        _PZC_MOLD_AVAILABLE=1
        _pzc_debug "_PZC_MOLD_PATH = ${_PZC_MOLD_PATH} (with Mise-en-place / add in PATH)"
        export PATH=${_PZC_MOLD_PATH}:$PATH

      else
        _PZC_MOLD_AVAILABLE=0
        _pzc_warning "Mold is not installed (https://github.com/rui314/mold). You can install mold with Mise-en-place with the command 'pzc_install_mold' or disable mold search in .pzcrc."

      fi
    fi
  fi

else
  _pzc_debug "Mold disabled."

fi



# ---------------------------------------------------------------
# ---------------------------- Ninja ----------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_NINJA_AVAILABLE} = 1 ]]
then

  if [[ -v _PZC_NINJA_PATH ]] && [[ -e ${_PZC_NINJA_PATH} ]]
  then
    _pzc_debug "_PZC_NINJA_PATH = ${_PZC_NINJA_PATH} (add in PATH)"
    export PATH=${_PZC_NINJA_PATH}:$PATH

  elif [[ -v _PZC_NINJA_PATH ]]
  then
    _pzc_warning "Your ninja is not found. Search other ninja."
    _pzc_debug "_PZC_NINJA_PATH = ${_PZC_NINJA_PATH} (unset)"
    unset _PZC_NINJA_PATH

  fi

  if [[ ! -v _PZC_NINJA_PATH ]]
  then

    if [[ -x "$(command -v ninja)" ]]
    then
      _PZC_NINJA_AVAILABLE=1
      _pzc_debug "Ninja found in PATH"

    else

      if [[ ${_PZC_MISE_AVAILABLE} = 1 ]]
      then
        _PZC_NINJA_PATH=$(mise which --raw -C "${ENVI_DIR}/pzc/progs/mise" ninja 2&>/dev/null)
        _PZC_NINJA_PATH=$(dirname "${_PZC_NINJA_PATH}")
      fi

      if [[ -n ${_PZC_NINJA_PATH} ]] && [[ -e ${_PZC_NINJA_PATH} ]]
      then
        _PZC_NINJA_AVAILABLE=1
        _pzc_debug "_PZC_NINJA_PATH = ${_PZC_NINJA_PATH} (with Mise-en-place / add in PATH)"
        export PATH=${_PZC_NINJA_PATH}:$PATH
      
      else
        _PZC_NINJA_AVAILABLE=0
        _pzc_warning "Ninja is not installed (https://github.com/ninja-build/ninja). You can install ninja with Mise-en-place with the command 'pzc_install_ninja' or disable ninja search in .pzcrc."

      fi
    fi
  fi

else
  _pzc_debug "Ninja disabled."

fi



# ---------------------------------------------------------------
# ---------------------------- CMake ----------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_CMAKE_AVAILABLE} = 1 ]]
then

  if [[ -v _PZC_CMAKE_PATH ]] && [[ -e ${_PZC_CMAKE_PATH} ]]
  then
    _pzc_debug "_PZC_CMAKE_PATH = ${_PZC_CMAKE_PATH} (add in PATH)"
    export PATH=${_PZC_CMAKE_PATH}:$PATH

  elif [[ -v _PZC_CMAKE_PATH ]]
  then
    _pzc_warning "Your cmake is not found. Search other cmake."
    _pzc_debug "_PZC_CMAKE_PATH = ${_PZC_CMAKE_PATH} (unset)"
    unset _PZC_CMAKE_PATH

  fi

  if [[ ! -v _PZC_CMAKE_PATH ]]
  then

    if [[ -x "$(command -v cmake)" ]]
    then
      _PZC_CMAKE_AVAILABLE=1
      _pzc_debug "CMake found in PATH"

    else

      if [[ ${_PZC_MISE_AVAILABLE} = 1 ]]
      then
        _PZC_CMAKE_PATH=$(mise which --raw -C "${ENVI_DIR}/pzc/progs/mise" cmake 2&>/dev/null)
        _PZC_CMAKE_PATH=$(dirname "${_PZC_CMAKE_PATH}")
      fi

      if [[ -n ${_PZC_CMAKE_PATH} ]] && [[ -e ${_PZC_CMAKE_PATH} ]]
      then
        _PZC_CMAKE_AVAILABLE=1
        _pzc_debug "_PZC_CMAKE_PATH = ${_PZC_CMAKE_PATH} (with Mise-en-place / add in PATH)"
        export PATH=${_PZC_CMAKE_PATH}:$PATH
      
      else
        _PZC_CMAKE_AVAILABLE=0
        _pzc_warning "CMake is not installed (https://github.com/Kitware/CMake). You can install cmake with Mise-en-place with the command 'pzc_install_cmake' or disable cmake search in .pzcrc."

      fi
    fi
  fi

else
  _pzc_debug "CMake disabled."

fi



# ---------------------------------------------------------------
# ------------------------ TASKWARRIOR --------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_TASK_AVAILABLE} = 1 ]]
then

  if [[ -v _PZC_TASK_PATH ]] && [[ -e ${_PZC_TASK_PATH} ]]
  then
    _pzc_debug "_PZC_TASK_PATH = ${_PZC_TASK_PATH} (add in PATH)"
    export PATH=${_PZC_TASK_PATH}:$PATH

  elif [[ -v _PZC_TASK_PATH ]]
  then
    _pzc_warning "Your taskwarrior binary is not found. Search other taskwarrior."
    _pzc_debug "_PZC_TASK_PATH = ${_PZC_TASK_PATH} (unset)"
    unset _PZC_TASK_PATH

  fi

  if [[ ! -v _PZC_TASK_PATH ]]
  then

    if [[ -x "$(command -v task)" ]]
    then
      _PZC_TASK_AVAILABLE=1
      _pzc_debug "Taskwarrior found in PATH"
      
    else
      _PZC_TASK_AVAILABLE=0
      _pzc_warning "Taskwarrior is not installed (https://github.com/GothenburgBitFactory/taskwarrior). You can disable taskwarrior search in .pzcrc."

    fi
  fi

else
  _pzc_debug "Taskwarrior disabled."

fi



# ---------------------------------------------------------------
# ---------------------------- Atuin ----------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_ATUIN_AVAILABLE} = 1 ]]
then

  if [[ -v PZC_ATUIN_BIN ]] && [[ -e ${PZC_ATUIN_BIN} ]]
  then
    _pzc_debug "PZC_ATUIN_BIN = ${PZC_ATUIN_BIN} (user defined)"
    alias atuin='${PZC_ATUIN_BIN}'
    _pzc_debug "Define alias atuin"

  elif [[ -v PZC_ATUIN_BIN ]]
  then
    _pzc_warning "Your atuin is not found. Search other atuin."
    _pzc_debug "PZC_ATUIN_BIN = ${PZC_ATUIN_BIN} (unset)"
    unset PZC_ATUIN_BIN

  fi

  if [[ ! -v PZC_ATUIN_BIN ]]
  then

    if [[ -x "$(command -v atuin)" ]]
    then
      PZC_ATUIN_BIN=atuin
      _PZC_ATUIN_AVAILABLE=1
      _pzc_debug "Atuin found in PATH"
      
    else

      if [[ ${_PZC_MISE_AVAILABLE} = 1 ]]
      then
        PZC_ATUIN_BIN=$(mise which --raw -C "${ENVI_DIR}/pzc/progs/mise" atuin 2&>/dev/null)
      fi

      if [[ -n ${PZC_ATUIN_BIN} ]] && [[ -e ${PZC_ATUIN_BIN} ]]
      then
        _PZC_ATUIN_AVAILABLE=1
        _pzc_debug "PZC_ATUIN_BIN = ${PZC_ATUIN_BIN} (with Mise-en-place)"
        alias atuin='${PZC_ATUIN_BIN}'
        _pzc_debug "Define alias atuin"

      else
        _PZC_ATUIN_AVAILABLE=0
        _pzc_warning "Atuin is not installed (https://github.com/atuinsh/atuin). You can install atuin with Mise-en-place with the command 'pzc_install_atuin' or disable atuin search in .pzcrc."

      fi
    fi
  fi

else
  _pzc_debug "Atuin disabled."

fi



# ---------------------------------------------------------------
# ----------------------------- Fzf -----------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_FZF_AVAILABLE} = 1 ]]
then

  if [[ -v PZC_FZF_BIN ]] && [[ -e ${PZC_FZF_BIN} ]]
  then
    _pzc_debug "PZC_FZF_BIN = ${PZC_FZF_BIN} (user defined)"
    alias fzf='${PZC_FZF_BIN}'
    _pzc_debug "Define alias fzf"

  elif [[ -v PZC_FZF_BIN ]]
  then
    _pzc_warning "Your fzf is not found. Search other fzf."
    _pzc_debug "PZC_FZF_BIN = ${PZC_FZF_BIN} (unset)"
    unset PZC_FZF_BIN

  fi

  if [[ ! -v PZC_FZF_BIN ]]
  then

    if [[ -x "$(command -v fzf)" ]]
    then
      PZC_FZF_BIN=fzf
      _PZC_FZF_AVAILABLE=1
      _pzc_debug "Fzf found in PATH"

    else

      if [[ ${_PZC_MISE_AVAILABLE} = 1 ]]
      then
        PZC_FZF_BIN=$(mise which --raw -C "${ENVI_DIR}/pzc/progs/mise" fzf 2&>/dev/null)
      fi

      if [[ -n ${PZC_FZF_BIN} ]] && [[ -e ${PZC_FZF_BIN} ]]
      then
        _PZC_FZF_AVAILABLE=1
        _pzc_debug "PZC_FZF_BIN = ${PZC_FZF_BIN} (with Mise-en-place)"
        alias fzf='${PZC_FZF_BIN}'
        _pzc_debug "Define alias fzf"

      else
        _PZC_FZF_AVAILABLE=0
        _pzc_warning "Fzf is not installed (https://github.com/junegunn/fzf). You can install fzf with Mise-en-place with the command 'pzc_install_fzf' or disable fzf search in .pzcrc."

      fi
    fi
  fi

else
  _pzc_debug "Fzf disabled."

fi



# ---------------------------------------------------------------
# --------------------------- Python ----------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_PYTHON_AVAILABLE} = 1 ]]
then

  _PZC_PYTHON_BIN=python

  if [[ -v _PZC_PYTHON_PATH ]] && [[ -e ${_PZC_PYTHON_PATH} ]]
  then
    _pzc_debug "_PZC_PYTHON_PATH = ${_PZC_PYTHON_PATH} (add in PATH)"
    export PATH=${_PZC_PYTHON_PATH}:$PATH

  elif [[ -v _PZC_PYTHON_PATH ]]
  then
    _pzc_warning "Your python is not found. Search other python."
    _pzc_debug "_PZC_PYTHON_PATH = ${_PZC_PYTHON_PATH} (unset)"
    unset _PZC_PYTHON_PATH

  fi

  if [[ ! -v _PZC_PYTHON_PATH ]]
  then

    if [[ -x "$(command -v python)" ]]
    then
      _PZC_PYTHON_AVAILABLE=1
      _pzc_debug "Python found in PATH (_PZC_PYTHON_BIN = ${_PZC_PYTHON_BIN})"

    elif [[ -x "$(command -v python3)" ]]
    then
      _PZC_PYTHON_AVAILABLE=1
      _PZC_PYTHON_BIN=python3
      _pzc_debug "Python found in PATH (_PZC_PYTHON_BIN = ${_PZC_PYTHON_BIN})"

    else
      _PZC_PYTHON_AVAILABLE=0
      _pzc_warning "Python is not installed. You can disable python search in .pzcrc."

    fi
  fi

else
  _pzc_debug "Python disabled."

fi



# ---------------------------------------------------------------
# ---------------------- PZC Install Part -----------------------
# ---------------------------------------------------------------

if [[ ${_PZC_MISE_AVAILABLE} = 1 ]]
then

  # ------------------------
  # ------ Oh-My-Posh ------
  # ------------------------

  if [[ ${_PZC_OMP_AVAILABLE} = 0 ]]
  then
    _pzc_debug "Define pzc_install_omp function"
    pzc_install_omp()
    {
      _pzc_info "Installing Oh-My-Posh with Mise-en-place..."

      _pzc_coal_eval "${PZC_MISE_BIN} install oh-my-posh"

      if [[ $? = 0 ]]
      then
        _pzc_info "Enabling Oh-My-Posh..."
        sed -i 's/local _PZC_OMP_AVAILABLE=0/local _PZC_OMP_AVAILABLE=1/g' ${_PZC_PZCRC_DIR}/.pzcrc

        _pzc_info "Update PZC's mise.toml..."
        _pzc_coal_eval "${PZC_MISE_BIN} use -p \"${ENVI_DIR}/pzc/progs/mise\" oh-my-posh"

        if [[ ! -n ${_PZC_PKG_RESTART} ]] || [[ ${_PZC_PKG_RESTART} = 1 ]]
        then
          _pzc_info "Reloading ZSH..."
          exec zsh
        fi
      else
        _pzc_error "Error with Mise-en-place."
      fi
    }
  else
    pzc_install_omp()
    {
      _pzc_info "Oh-My-Posh is already installed."
    }
  fi


  # ------------------------
  # --------- EZA ----------
  # ------------------------

  if [[ ${_PZC_EZA_AVAILABLE} = 0 ]]
  then
    _pzc_debug "Define pzc_install_eza function"
    pzc_install_eza()
    {
      _pzc_info "Installing EZA with Mise-en-place..."

      _pzc_coal_eval "${PZC_MISE_BIN} install eza"

      if [[ $? = 0 ]]
      then
        _pzc_info "Enabling EZA..."
        sed -i 's/local _PZC_EZA_AVAILABLE=0/local _PZC_EZA_AVAILABLE=1/g' ${_PZC_PZCRC_DIR}/.pzcrc

        _pzc_info "Update PZC's mise.toml..."
        _pzc_coal_eval "${PZC_MISE_BIN} use -p \"${ENVI_DIR}/pzc/progs/mise\" eza"

        if [[ ! -n ${_PZC_PKG_RESTART} ]] || [[ ${_PZC_PKG_RESTART} = 1 ]]
        then
          _pzc_info "Reloading ZSH..."
          exec zsh
        fi
      else
        _pzc_error "Error with Mise-en-place."
      fi
    }
  else
    pzc_install_eza()
    {
      _pzc_info "EZA is already installed."
    }
  fi


  # ------------------------
  # -------- CCache --------
  # ------------------------

  if [[ ${_PZC_CCACHE_AVAILABLE} = 0 ]]
  then
    _pzc_debug "Define pzc_install_ccache function"
    pzc_install_ccache()
    {
      _pzc_info "Installing CCache with Mise-en-place..."

      _pzc_coal_eval "${PZC_MISE_BIN} install ccache"

      if [[ $? = 0 ]]
      then
        _pzc_info "Enabling CCache..."
        sed -i 's/local _PZC_CCACHE_AVAILABLE=0/local _PZC_CCACHE_AVAILABLE=1/g' ${_PZC_PZCRC_DIR}/.pzcrc

        _pzc_info "Update PZC's mise.toml..."
        _pzc_coal_eval "${PZC_MISE_BIN} use -p \"${ENVI_DIR}/pzc/progs/mise\" ccache"

        if [[ ! -n ${_PZC_PKG_RESTART} ]] || [[ ${_PZC_PKG_RESTART} = 1 ]]
        then
          _pzc_info "Reloading ZSH..."
          exec zsh
        fi
      else
        _pzc_error "Error with Mise-en-place."
      fi
    }
  else
    pzc_install_ccache()
    {
      _pzc_info "CCache is already installed."
    }
  fi


  # ------------------------
  # --------- Mold ---------
  # ------------------------

  if [[ ${_PZC_MOLD_AVAILABLE} = 0 ]]
  then
    _pzc_debug "Define pzc_install_mold function"
    pzc_install_mold()
    {
      _pzc_info "Installing Mold with Mise-en-place..."

      _pzc_coal_eval "${PZC_MISE_BIN} install mold"

      if [[ $? = 0 ]]
      then
        _pzc_info "Enabling Mold..."
        sed -i 's/local _PZC_MOLD_AVAILABLE=0/local _PZC_MOLD_AVAILABLE=1/g' ${_PZC_PZCRC_DIR}/.pzcrc

        _pzc_info "Update PZC's mise.toml..."
        _pzc_coal_eval "${PZC_MISE_BIN} use -p \"${ENVI_DIR}/pzc/progs/mise\" mold"

        if [[ ! -n ${_PZC_PKG_RESTART} ]] || [[ ${_PZC_PKG_RESTART} = 1 ]]
        then
          _pzc_info "Reloading ZSH..."
          exec zsh
        fi
      else
        _pzc_error "Error with Mise-en-place."
      fi
    }
  else
    pzc_install_mold()
    {
      _pzc_info "Mold is already installed."
    }
  fi


  # ------------------------
  # --------- Ninja --------
  # ------------------------

  if [[ ${_PZC_NINJA_AVAILABLE} = 0 ]]
  then
    _pzc_debug "Define pzc_install_ninja function"
    pzc_install_ninja()
    {
      _pzc_info "Installing Ninja with Mise-en-place..."

      _pzc_coal_eval "${PZC_MISE_BIN} install ninja"

      if [[ $? = 0 ]]
      then
        _pzc_info "Enabling Ninja..."
        sed -i 's/local _PZC_NINJA_AVAILABLE=0/local _PZC_NINJA_AVAILABLE=1/g' ${_PZC_PZCRC_DIR}/.pzcrc

        _pzc_info "Update PZC's mise.toml..."
        _pzc_coal_eval "${PZC_MISE_BIN} use -p \"${ENVI_DIR}/pzc/progs/mise\" ninja"

        if [[ ! -n ${_PZC_PKG_RESTART} ]] || [[ ${_PZC_PKG_RESTART} = 1 ]]
        then
          _pzc_info "Reloading ZSH..."
          exec zsh
        fi
      else
        _pzc_error "Error with Mise-en-place."
      fi
    }
  else
    pzc_install_ninja()
    {
      _pzc_info "Ninja is already installed."
    }
  fi


  # ------------------------
  # --------- CMake --------
  # ------------------------

  if [[ ${_PZC_CMAKE_AVAILABLE} = 0 ]]
  then
    _pzc_debug "Define pzc_install_cmake function"
    pzc_install_cmake()
    {
      _pzc_info "Installing CMake with Mise-en-place..."

      _pzc_coal_eval "${PZC_MISE_BIN} install cmake"

      if [[ $? = 0 ]]
      then
        _pzc_info "Enabling CMake..."
        sed -i 's/local _PZC_CMAKE_AVAILABLE=0/local _PZC_CMAKE_AVAILABLE=1/g' ${_PZC_PZCRC_DIR}/.pzcrc

        _pzc_info "Update PZC's mise.toml..."
        _pzc_coal_eval "${PZC_MISE_BIN} use -p \"${ENVI_DIR}/pzc/progs/mise\" cmake"

        if [[ ! -n ${_PZC_PKG_RESTART} ]] || [[ ${_PZC_PKG_RESTART} = 1 ]]
        then
          _pzc_info "Reloading ZSH..."
          exec zsh
        fi
      else
        _pzc_error "Error with Mise-en-place."
      fi
    }
  else
    pzc_install_cmake()
    {
      _pzc_info "CMake is already installed."
    }
  fi


  # ------------------------
  # --------- Atuin --------
  # ------------------------

  if [[ ${_PZC_ATUIN_AVAILABLE} = 0 ]]
  then
    _pzc_debug "Define pzc_install_atuin function"
    pzc_install_atuin()
    {
      _pzc_info "Installing Atuin with Mise-en-place..."

      _pzc_coal_eval "${PZC_MISE_BIN} install atuin"

      if [[ $? = 0 ]]
      then
        _pzc_info "Enabling Atuin..."
        sed -i 's/local _PZC_ATUIN_AVAILABLE=0/local _PZC_ATUIN_AVAILABLE=1/g' ${_PZC_PZCRC_DIR}/.pzcrc

        _pzc_info "Update PZC's mise.toml..."
        _pzc_coal_eval "${PZC_MISE_BIN} use -p \"${ENVI_DIR}/pzc/progs/mise\" atuin"

        if [[ ! -n ${_PZC_PKG_RESTART} ]] || [[ ${_PZC_PKG_RESTART} = 1 ]]
        then
          _pzc_info "Reloading ZSH..."
          exec zsh
        fi
      else
        _pzc_error "Error with Mise-en-place."
      fi
    }
  else
    pzc_install_atuin()
    {
      _pzc_info "Atuin is already installed."
    }
  fi


  # ------------------------
  # --------- Fzf ----------
  # ------------------------

  if [[ ${_PZC_FZF_AVAILABLE} = 0 ]]
  then
    _pzc_debug "Define pzc_install_fzf function"
    pzc_install_fzf()
    {
      _pzc_info "Installing Fzf with Mise-en-place..."

      _pzc_coal_eval "${PZC_MISE_BIN} install fzf"

      if [[ $? = 0 ]]
      then
        _pzc_info "Enabling Fzf..."
        sed -i 's/local _PZC_FZF_AVAILABLE=0/local _PZC_FZF_AVAILABLE=1/g' ${_PZC_PZCRC_DIR}/.pzcrc

        _pzc_info "Update PZC's mise.toml..."
        _pzc_coal_eval "${PZC_MISE_BIN} use -p \"${ENVI_DIR}/pzc/progs/mise\" fzf"

        _pzc_info "Reloading ZSH..."
        exec zsh
      else
        _pzc_error "Error with Mise-en-place."
      fi
    }
  fi

  pzc_install_all()
  {
    local _PZC_PKG_RESTART=0

    pzc_install_omp
    pzc_install_eza
    pzc_install_ccache
    pzc_install_mold
    pzc_install_ninja
    pzc_install_cmake
    pzc_install_atuin
    pzc_install_fzf

    _pzc_info "Reloading ZSH..."
    exec zsh
  }

fi
