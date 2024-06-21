
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
# ------------------------- Check large -------------------------
# ---------------------------------------------------------------

if [[ ! -v _PZC_LARGE_DIR ]]
then
  _pzc_debug "_PZC_LARGE_DIR is not set. Default directory is set to '${HOME}'."
  local _PZC_LARGE_DIR=${HOME}
fi



# ---------------------------------------------------------------
# ----------------------- Check compilers -----------------------
# ---------------------------------------------------------------

if [[ ${_PZC_C_GCC_AVAILABLE} = 1 ]]
then

  if [[ -v _PZC_C_GCC ]] && [[ ! -x "$(command -v ${_PZC_C_GCC})" ]]
  then
    _pzc_warning "Your gcc is not found. Search other gcc."
    _pzc_debug "_PZC_C_GCC = ${_PZC_C_GCC} (unset)"
    unset _PZC_C_GCC

  fi

  if [[ ! -v _PZC_C_GCC ]]
  then

    if [[ -x "$(command -v gcc)" ]]
    then
      _PZC_C_GCC=gcc
      _PZC_C_GCC_AVAILABLE=1
      _pzc_debug "_PZC_C_GCC = ${_PZC_C_GCC} (in PATH)"
      
    else
      _PZC_C_GCC_AVAILABLE=0
      _pzc_warning "GCC is not installed. You can disable gcc search in .zshrc."

    fi
  fi
else
  _pzc_debug "GCC disabled."

fi

if [[ ${_PZC_CXX_GCC_AVAILABLE} = 1 ]]
then

  if [[ -v _PZC_CXX_GCC ]] && [[ ! -x "$(command -v ${_PZC_CXX_GCC})" ]]
  then
    _pzc_warning "Your g++ is not found. Search other g++."
    _pzc_debug "_PZC_CXX_GCC = ${_PZC_CXX_GCC} (unset)"
    unset _PZC_CXX_GCC

  fi

  if [[ ! -v _PZC_CXX_GCC ]]
  then

    if [[ -x "$(command -v g++)" ]]
    then
      _PZC_CXX_GCC=g++
      _PZC_CXX_GCC_AVAILABLE=1
      _pzc_debug "_PZC_CXX_GCC = ${_PZC_CXX_GCC} (in PATH)"
      
    else
      _PZC_CXX_GCC_AVAILABLE=0
      _pzc_warning "G++ is not installed. You can disable g++ search in .zshrc."

    fi
  fi
else
  _pzc_debug "G++ disabled."

fi

if [[ ${_PZC_C_CLANG_AVAILABLE} = 1 ]]
then

  if [[ -v _PZC_C_CLANG ]] && [[ ! -x "$(command -v ${_PZC_C_CLANG})" ]]
  then
    _pzc_warning "Your clang is not found. Search other clang."
    _pzc_debug "_PZC_C_CLANG = ${_PZC_C_CLANG} (unset)"
    unset _PZC_C_CLANG

  fi

  if [[ ! -v _PZC_C_CLANG ]]
  then

    if [[ -x "$(command -v clang)" ]]
    then
      _PZC_C_CLANG=clang
      _PZC_C_CLANG_AVAILABLE=1
      _pzc_debug "_PZC_C_CLANG = ${_PZC_C_CLANG} (in PATH)"
      
    else
      _PZC_C_CLANG_AVAILABLE=0
      _pzc_warning "CLang is not installed. You can disable clang search in .zshrc."

    fi
  fi
else
  _pzc_debug "CLang disabled."

fi

if [[ ${_PZC_CXX_CLANG_AVAILABLE} = 1 ]]
then

  if [[ -v _PZC_CXX_CLANG ]] && [[ ! -x "$(command -v ${_PZC_CXX_CLANG})" ]]
  then
    _pzc_warning "Your clang++ is not found. Search other clang++."
    _pzc_debug "_PZC_CXX_CLANG = ${_PZC_CXX_CLANG} (unset)"
    unset _PZC_CXX_CLANG

  fi

  if [[ ! -v _PZC_CXX_CLANG ]]
  then

    if [[ -x "$(command -v clang++)" ]]
    then
      _PZC_CXX_CLANG=clang++
      _PZC_CXX_CLANG_AVAILABLE=1
      _pzc_debug "_PZC_CXX_CLANG = ${_PZC_CXX_CLANG} (in PATH)"
      
    else
      _PZC_CXX_CLANG_AVAILABLE=0
      _pzc_warning "CLang++ is not installed. You can disable clang++ search in .zshrc."

    fi
  fi
else
  _pzc_debug "CLang++ disabled."

fi

if [[ ${_PZC_NVCC_BIN_AVAILABLE} = 1 ]]
then

  if [[ -v _PZC_NVCC_BIN ]] && [[ ! -x "$(command -v ${_PZC_NVCC_BIN})" ]]
  then
    _pzc_warning "Your nvcc is not found. Search other nvcc."
    _pzc_debug "_PZC_NVCC_BIN = ${_PZC_NVCC_BIN} (unset)"
    unset _PZC_NVCC_BIN

  fi

  if [[ ! -v _PZC_NVCC_BIN ]]
  then

    if [[ -x "$(command -v nvcc)" ]]
    then
      _PZC_NVCC_BIN=nvcc
      _PZC_NVCC_BIN_AVAILABLE=1
      _pzc_debug "_PZC_NVCC_BIN = ${_PZC_NVCC_BIN} (in PATH)"
      
    else
      _PZC_NVCC_BIN_AVAILABLE=0
      _pzc_warning "NVCC is not installed. You can disable nvcc search in .zshrc."

    fi
  fi

  if [[ ${_PZC_NVCC_BIN_AVAILABLE} = 1 ]]
  then

    if [[ -v _PZC_NVCC_HOST_COMPILER ]] && [[ ! -x "$(command -v ${_PZC_NVCC_HOST_COMPILER})" ]]
    then
      _pzc_warning "Your host compiler for nvcc is not found. Search other one."
      _pzc_debug "_PZC_NVCC_HOST_COMPILER = ${_PZC_NVCC_HOST_COMPILER} (unset)"
      unset _PZC_NVCC_HOST_COMPILER

    fi

    if [[ ! -v _PZC_NVCC_HOST_COMPILER ]]
    then

      if [[ ${_PZC_CXX_GCC_AVAILABLE} = 1 ]]
      then
        _PZC_NVCC_HOST_COMPILER=${_PZC_CXX_GCC}
        _PZC_NVCC_BIN_AVAILABLE=1
        _pzc_debug "_PZC_NVCC_HOST_COMPILER = ${_PZC_NVCC_HOST_COMPILER} (G++) (in PATH)"

      elif [[ ${_PZC_CXX_CLANG_AVAILABLE} = 1 ]]
      then
        _PZC_NVCC_HOST_COMPILER=${_PZC_CXX_CLANG}
        _PZC_NVCC_BIN_AVAILABLE=1
        _pzc_debug "_PZC_NVCC_HOST_COMPILER = ${_PZC_NVCC_HOST_COMPILER} (CLang++) (in PATH)"

      else
        _PZC_NVCC_BIN_AVAILABLE=0
        _pzc_warning "Host compiler for nvcc is not found. You can disable nvcc search in .zshrc."

      fi
    fi
  fi
else
  _pzc_debug "NVCC disabled."

fi

if [[ ${_PZC_SYCL_BIN_AVAILABLE} = 1 ]]
then

  if [[ -v _PZC_SYCL_BIN ]] && [[ ! -x "$(command -v ${_PZC_SYCL_BIN})" ]]
  then
    _pzc_warning "Your acpp is not found. Search other acpp."
    _pzc_debug "_PZC_SYCL_BIN = ${_PZC_SYCL_BIN} (unset)"
    unset _PZC_SYCL_BIN

  fi

  if [[ ! -v _PZC_SYCL_BIN ]]
  then

    if [[ -x "$(command -v acpp)" ]]
    then
      _PZC_SYCL_BIN=acpp
      _PZC_SYCL_BIN_AVAILABLE=1
      _pzc_debug "_PZC_SYCL_BIN = ${_PZC_SYCL_BIN} (in PATH)"
      
    else
      _PZC_SYCL_BIN_AVAILABLE=0
      _pzc_warning "Acpp is not installed. You can disable acpp search in .zshrc."

    fi
  fi

else
  _pzc_debug "acpp disabled."

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
# --------------------------- EZA-LS ----------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_EZA_AVAILABLE} = 1 ]]
then

  if [[ -v _PZC_EZA_PATH ]] && [[ ! -e ${_PZC_EZA_PATH} ]]
  then
    _pzc_warning "Your eza is not found. Search other eza."
    _pzc_debug "_PZC_EZA_PATH = ${_PZC_EZA_PATH} (unset)"
    unset _PZC_EZA_PATH

  fi

  if [[ ! -v _PZC_EZA_PATH ]]
  then

    if [[ -x "$(command -v eza)" ]]
    then
      _PZC_EZA_PATH=eza
      _PZC_EZA_AVAILABLE=1
      _pzc_debug "_PZC_EZA_PATH = ${_PZC_EZA_PATH} (in PATH)"

    elif [[ -e ${_PZC_PZC_DIR}/progs/eza/eza ]]
    then
      _PZC_EZA_PATH=${_PZC_PZC_DIR}/progs/eza/eza
      _PZC_EZA_AVAILABLE=1
      _pzc_debug "_PZC_EZA_PATH = ${_PZC_EZA_PATH} (in pzc)"

    # TODO : Deprecated
    elif [[ -x "$(command -v exa)" ]]
    then
      _PZC_EZA_PATH=exa
      _PZC_EZA_AVAILABLE=1
      _PZC_EXA_DEPRECATED=1
      _pzc_debug "_PZC_EZA_PATH = ${_PZC_EZA_PATH} (in PATH / EXA)"
      _pzc_warning "EXA-LS is deprecated, please update to the EZA-LS fork (https://github.com/eza-community/eza) and remove your actual EXA-LS install."
      _pzc_info "You can install eza in the PZC folder with the command 'pzc_install_eza' or disable eza search in .zshrc."

    # TODO : Deprecated
    elif [[ -e ${_PZC_PZC_DIR}/progs/exa/exa ]]
    then
      _PZC_EZA_PATH=${_PZC_PZC_DIR}/progs/exa/exa
      _PZC_EZA_AVAILABLE=1
      _PZC_EXA_DEPRECATED=1
      _pzc_debug "_PZC_EZA_PATH = ${_PZC_EZA_PATH} (in pzc / EXA)"
      _pzc_warning "EXA-LS is deprecated, please update to the EZA-LS fork (https://github.com/eza-community/eza) and remove your actual EXA-LS install ($_PZC_EZA_PATH)."
      _pzc_info "You can install eza in the PZC folder with the command 'pzc_install_eza' or disable eza search in .zshrc."
      
    else
      _PZC_EZA_AVAILABLE=0
      _pzc_warning "Eza is not installed (https://github.com/eza-community/eza). You can install eza in the PZC folder with the command 'pzc_install_eza' or disable eza search in .zshrc."

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

  if [[ -v _PZC_CCACHE_PATH ]] && [[ ! -e ${_PZC_CCACHE_PATH} ]]
  then
    _pzc_warning "Your ccache is not found. Search other ccache."
    _pzc_debug "_PZC_CCACHE_PATH = ${_PZC_CCACHE_PATH} (unset)"
    unset _PZC_CCACHE_PATH

  fi

  if [[ ! -v _PZC_CCACHE_PATH ]]
  then

    if [[ -x "$(command -v ccache)" ]]
    then
      _PZC_CCACHE_PATH=ccache
      _PZC_CCACHE_AVAILABLE=1
      _pzc_debug "_PZC_CCACHE_PATH = ${_PZC_CCACHE_PATH} (in PATH)"
      
    else
      _PZC_CCACHE_AVAILABLE=0
      _pzc_warning "CCache is not installed (https://github.com/ccache/ccache). You can disable ccache search in .zshrc."

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
      _PZC_MOLD_AVAILABLE=0
      _pzc_warning "Mold is not installed (https://github.com/rui314/mold). You can disable mold search in .zshrc."

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
      _PZC_NINJA_AVAILABLE=0
      _pzc_warning "Ninja is not installed (https://github.com/ninja-build/ninja). You can disable ninja search in .zshrc."

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
      _PZC_CMAKE_AVAILABLE=0
      _pzc_warning "CMake is not installed (https://github.com/Kitware/CMake). You can disable cmake search in .zshrc."

    fi
  fi
else
  _pzc_debug "CMake disabled."

fi



# ---------------------------------------------------------------
# ---------------------- PZC Install Part -----------------------
# ---------------------------------------------------------------

# ------------------------
# ------ Oh-My-Posh ------
# ------------------------

if [[ ${_PZC_OMP_AVAILABLE} = 0 ]]
then
  _pzc_debug "Define pzc_install_omp function"
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



# ------------------------
# --------- EZA ----------
# ------------------------

if [[ ${_PZC_EZA_AVAILABLE} = 0 ]] || [[ ${_PZC_EXA_DEPRECATED} = 1 ]]
then
  _pzc_debug "Define pzc_install_eza function"
  pzc_install_eza()
  {
    _pzc_info "Install EZA in PZC folder..."

    _pzc_debug "Download EZA in TMP folder"
    wget -q -O "${_PZC_TMP_DIR}/eza_archive.tar.gz" "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz"

    _pzc_debug "Untar EZA archive in TMP folder"
    tar -zxf "${_PZC_TMP_DIR}/eza_archive.tar.gz" -C "${_PZC_TMP_DIR}"

    _pzc_debug "MkDir progs/eza"
    mkdir -p "${_PZC_PZC_DIR}/progs/eza"

    _pzc_debug "Copy eza bin"
    cp "${_PZC_TMP_DIR}/eza" "${_PZC_PZC_DIR}/progs/eza/"

    if [[ $? = 0 ]]
    then
      _pzc_info "Reload ZSH..."
      exec zsh
    else
      _pzc_error "Error with wget call."
    fi
  }
fi

