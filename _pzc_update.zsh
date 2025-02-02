_pzc_update_pzcrc_5()
{
  echo "## ----- PZC configuration file -----" >> ${_PZC_OUTPUT_FILE}
  echo "# Edit only lines marked with a TODO comment." >> ${_PZC_OUTPUT_FILE}
  echo "# You can add path dir or other configs in .zshrc." >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ------ Config file version -------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "local _PZC_CONFIG_VERSION=(6 0 0)" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ------- Log verbose level --------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}

  if [[ ${_PZC_LOG_INFO} = 1 ]]
  then
    echo "local _PZC_LOG_INFO=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_LOG_INFO=0" >> ${_PZC_OUTPUT_FILE}
  fi

  if [[ ${_PZC_LOG_WARNING} = 1 ]]
  then
    echo "local _PZC_LOG_WARNING=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_LOG_WARNING=0" >> ${_PZC_OUTPUT_FILE}
  fi

  if [[ ${_PZC_LOG_ERROR} = 1 ]]
  then
    echo "local _PZC_LOG_ERROR=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_LOG_ERROR=0" >> ${_PZC_OUTPUT_FILE}
  fi

  if [[ ${_PZC_LOG_DEBUG} = 1 ]]
  then
    echo "local _PZC_LOG_DEBUG=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_LOG_DEBUG=0" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ==================================" >> ${_PZC_OUTPUT_FILE}
  echo "# ==================================" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------- File editor ----------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and edit if you want to use an other file editor than 'vim'." >> ${_PZC_OUTPUT_FILE}
  if [[ -v _PZC_FILE_EDITOR ]]
  then
    echo "local _PZC_FILE_EDITOR=\"${_PZC_FILE_EDITOR}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#local _PZC_FILE_EDITOR=vim" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# --------- TMP directory ----------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and edit if you have an other tmp dir than '/tmp'." >> ${_PZC_OUTPUT_FILE}
  if [[ -v _PZC_TMP_DIR ]]
  then
    echo "local _PZC_TMP_DIR=\"${_PZC_TMP_DIR}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#local _PZC_TMP_DIR=/tmp" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# -------- Large directory ---------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and edit if you have an other large dir than your HOME" >> ${_PZC_OUTPUT_FILE}
  echo "#        for all builds/installs/ccache." >> ${_PZC_OUTPUT_FILE}
  if [[ -v _PZC_LARGE_DIR ]]
  then
    echo "local _PZC_LARGE_DIR=\"${_PZC_LARGE_DIR}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo '#local _PZC_LARGE_DIR=${HOME}' >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and edit if you want more specific directories for your" >> ${_PZC_OUTPUT_FILE}
  echo "#        working environment." >> ${_PZC_OUTPUT_FILE}
  if [[ -v _PZC_WORK_DIR_PATH ]]
  then
    echo "local _PZC_WORK_DIR_PATH=\"${_PZC_WORK_DIR_PATH}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo '#local _PZC_WORK_DIR_PATH=${_PZC_LARGE_DIR}' >> ${_PZC_OUTPUT_FILE}
  fi
  if [[ -v _PZC_BUILD_DIR_PATH ]]
  then
    echo "local _PZC_BUILD_DIR_PATH=\"${_PZC_BUILD_DIR_PATH}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo '#local _PZC_BUILD_DIR_PATH=${_PZC_LARGE_DIR}' >> ${_PZC_OUTPUT_FILE}
  fi
  if [[ -v _PZC_ENVI_DIR_PATH ]]
  then
    echo "local _PZC_ENVI_DIR_PATH=\"${_PZC_ENVI_DIR_PATH}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo '#local _PZC_ENVI_DIR_PATH=${_PZC_LARGE_DIR}' >> ${_PZC_OUTPUT_FILE}
  fi
  if [[ -v _PZC_CCACHE_DIR_PATH ]]
  then
    echo "local _PZC_CCACHE_DIR_PATH=\"${_PZC_CCACHE_DIR_PATH}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo '#local _PZC_CCACHE_DIR_PATH=${_PZC_BUILD_DIR_PATH}' >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and edit if you don't want to have builds and installs" >> ${_PZC_OUTPUT_FILE}
  echo "#        in the same folder." >> ${_PZC_OUTPUT_FILE}
  if [[ -v _PZC_INSTALL_DIR_PATH ]]
  then
    echo "local _PZC_INSTALL_DIR_PATH=\"${_PZC_INSTALL_DIR_PATH}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo '#local _PZC_INSTALL_DIR_PATH=${_PZC_LARGE_DIR}' >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# -------- SSH keys location -------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and complete if you want to use 'agee' and 'aged' functions." >> ${_PZC_OUTPUT_FILE}
  if [[ -v _PZC_SSH_PUB ]]
  then
    echo "local _PZC_SSH_PUB=\"${_PZC_SSH_PUB}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#local _PZC_SSH_PUB=" >> ${_PZC_OUTPUT_FILE}
  fi
  if [[ -v _PZC_SSH_PRI ]]
  then
    echo "local _PZC_SSH_PRI=\"${_PZC_SSH_PRI}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#local _PZC_SSH_PRI=" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------- OH-MY-POSH -----------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] If you want to use Oh-My-Posh, set this variable to 1." >> ${_PZC_OUTPUT_FILE}
  if [[ ${_PZC_OMP_AVAILABLE} = 1 ]]
  then
    echo "local _PZC_OMP_AVAILABLE=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_OMP_AVAILABLE=0" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and complete if you have a custom installation of Oh-My-Posh (which is not in PATH)." >> ${_PZC_OUTPUT_FILE}
  if [[ -v _PZC_OMP_BIN ]]
  then
    echo "local _PZC_OMP_BIN=\"${_PZC_OMP_BIN}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#local _PZC_OMP_BIN=" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and complete if you have a custom Oh-My-Posh theme." >> ${_PZC_OUTPUT_FILE}
  if [[ -v _PZC_OMP_THEME_FILE ]]
  then
    echo "local _PZC_OMP_THEME_FILE=\"${_PZC_OMP_THEME_FILE}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#local _PZC_OMP_THEME_FILE=" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ------------ AGE/RAGE ------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] If you want to use age or rage, set this variable to 1." >> ${_PZC_OUTPUT_FILE}
  if [[ ${_PZC_AGE_AVAILABLE} = 1 ]]
  then
    echo "local _PZC_AGE_AVAILABLE=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_AGE_AVAILABLE=0" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and complete if you have a custom installation of age or rage (which is not in PATH)." >> ${_PZC_OUTPUT_FILE}
  if [[ -v _PZC_AGE_BIN ]]
  then
    echo "local _PZC_AGE_BIN=\"${_PZC_AGE_BIN}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#local _PZC_AGE_BIN=" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ------------- EZA-LS -------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] If you want to use eza-ls, set this variable to 1." >> ${_PZC_OUTPUT_FILE}
  if [[ ${_PZC_EZA_AVAILABLE} = 1 ]]
  then
    echo "local _PZC_EZA_AVAILABLE=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_EZA_AVAILABLE=0" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and complete if you have a custom installation of EZA-LS (which is not in PATH)." >> ${_PZC_OUTPUT_FILE}
  if [[ -v _PZC_EZA_BIN ]]
  then
    echo "local _PZC_EZA_BIN=\"${_PZC_EZA_BIN}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#local _PZC_EZA_BIN=" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and complete if you have a custom EZA theme." >> ${_PZC_OUTPUT_FILE}
  if [[ -v _PZC_EZA_CONFIG_DIR ]]
  then
    echo "local _PZC_EZA_CONFIG_DIR=\"${_PZC_EZA_CONFIG_DIR}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#local _PZC_EZA_CONFIG_DIR=" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ------------- CCACHE -------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] If you want to use ccache, set this variable to 1." >> ${_PZC_OUTPUT_FILE}
  if [[ ${_PZC_CCACHE_AVAILABLE} = 1 ]]
  then
    echo "local _PZC_CCACHE_AVAILABLE=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_CCACHE_AVAILABLE=0" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and complete if you have a custom installation of ccache (which is not in PATH)." >> ${_PZC_OUTPUT_FILE}
  if [[ -v _PZC_CCACHE_BIN ]]
  then
    echo "local _PZC_CCACHE_BIN=\"${_PZC_CCACHE_BIN}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#local _PZC_CCACHE_BIN=" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# -------------- MOLD --------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] If you want to use mold, set this variable to 1." >> ${_PZC_OUTPUT_FILE}
  if [[ ${_PZC_MOLD_AVAILABLE} = 1 ]]
  then
    echo "local _PZC_MOLD_AVAILABLE=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_MOLD_AVAILABLE=0" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and complete if you have a custom installation of mold." >> ${_PZC_OUTPUT_FILE}
  echo "# Note: This PATH will be add in PATH." >> ${_PZC_OUTPUT_FILE}
  if [[ -v _PZC_MOLD_PATH ]]
  then
    echo "local _PZC_MOLD_PATH=\"${_PZC_MOLD_PATH}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#local _PZC_MOLD_PATH=" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ------------- NINJA --------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] If you want to use ninja, set this variable to 1." >> ${_PZC_OUTPUT_FILE}
  if [[ ${_PZC_NINJA_AVAILABLE} = 1 ]]
  then
    echo "local _PZC_NINJA_AVAILABLE=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_NINJA_AVAILABLE=0" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and complete if you have a custom installation of ninja." >> ${_PZC_OUTPUT_FILE}
  echo "# Note: This PATH will be add in PATH." >> ${_PZC_OUTPUT_FILE}
  if [[ -v _PZC_NINJA_PATH ]]
  then
    echo "local _PZC_NINJA_PATH=\"${_PZC_NINJA_PATH}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#local _PZC_NINJA_PATH=" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ------------- CMAKE --------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] If you want to use cmake, set this variable to 1." >> ${_PZC_OUTPUT_FILE}
  if [[ ${_PZC_CMAKE_AVAILABLE} = 1 ]]
  then
    echo "local _PZC_CMAKE_AVAILABLE=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_CMAKE_AVAILABLE=0" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and complete if you have a custom installation of cmake." >> ${_PZC_OUTPUT_FILE}
  echo "# Note: This PATH will be add in PATH." >> ${_PZC_OUTPUT_FILE}
  if [[ -v _PZC_CMAKE_PATH ]]
  then
    echo "local _PZC_CMAKE_PATH=\"${_PZC_CMAKE_PATH}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#local _PZC_CMAKE_PATH=" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ---------- TASKWARRIOR -----------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] If you want to use taskwarrior, set this variable to 1." >> ${_PZC_OUTPUT_FILE}
  if [[ ${_PZC_TASK_AVAILABLE} = 1 ]]
  then
    echo "local _PZC_TASK_AVAILABLE=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_TASK_AVAILABLE=0" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and complete if you have a custom installation of taskwarrior." >> ${_PZC_OUTPUT_FILE}
  echo "# Note: This PATH will be add in PATH." >> ${_PZC_OUTPUT_FILE}
  if [[ -v _PZC_TASK_PATH ]]
  then
    echo "local _PZC_TASK_PATH=\"${_PZC_TASK_PATH}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#local _PZC_TASK_PATH=" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ------------- CHMOD --------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] In case of problem with permissions after compiling," >> ${_PZC_OUTPUT_FILE}
  echo "# active this option." >> ${_PZC_OUTPUT_FILE}
  if [[ ${_PZC_CHMOD_COMPILING} = 1 ]]
  then
    echo "local _PZC_CHMOD_COMPILING=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_CHMOD_COMPILING=0" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------- COMPILERS ------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}

  echo "# [TODO] Setup available compilers." >> ${_PZC_OUTPUT_FILE}
  if [[ ${_PZC_C_CXX_DEFAULT_COMPILER} = "CLANG" ]]
  then
    echo "local _PZC_C_CXX_DEFAULT_COMPILER=CLANG # Or GCC" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_C_CXX_DEFAULT_COMPILER=GCC # Or CLANG" >> ${_PZC_OUTPUT_FILE}
  fi

  echo "" >> ${_PZC_OUTPUT_FILE}

  if [[ ${_PZC_GCC_AVAILABLE} = 1 ]]
  then
    echo "local _PZC_GCC_AVAILABLE=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_GCC_AVAILABLE=0" >> ${_PZC_OUTPUT_FILE}
  fi

  if [[ -v PZC_C_GCC_BIN ]]
  then
    echo "export PZC_C_GCC_BIN=\"${PZC_C_GCC_BIN}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#export PZC_C_GCC_BIN=gcc" >> ${_PZC_OUTPUT_FILE}
  fi

  if [[ -v PZC_CXX_GCC_BIN ]]
  then
    echo "export PZC_CXX_GCC_BIN=\"${PZC_CXX_GCC_BIN}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#export PZC_CXX_GCC_BIN=g++" >> ${_PZC_OUTPUT_FILE}
  fi


  echo "" >> ${_PZC_OUTPUT_FILE}


  if [[ ${_PZC_CLANG_AVAILABLE} = 1 ]]
  then
    echo "local _PZC_CLANG_AVAILABLE=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_CLANG_AVAILABLE=0" >> ${_PZC_OUTPUT_FILE}
  fi


  if [[ -v PZC_C_CLANG_BIN ]]
  then
    echo "export PZC_C_CLANG_BIN=\"${PZC_C_CLANG_BIN}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#export PZC_C_CLANG_BIN=clang" >> ${_PZC_OUTPUT_FILE}
  fi
  if [[ -v PZC_CXX_CLANG_BIN ]]
  then
    echo "export PZC_CXX_CLANG_BIN=\"${PZC_CXX_CLANG_BIN}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#export PZC_CXX_CLANG_BIN=clang++" >> ${_PZC_OUTPUT_FILE}
  fi

  echo "" >> ${_PZC_OUTPUT_FILE}


  if [[ ${_PZC_GPU_DEFAULT_COMPILER} = "SYCL" ]]
  then
    echo "local _PZC_GPU_DEFAULT_COMPILER=SYCL # Or NVCC" >> ${_PZC_OUTPUT_FILE}

  elif [[ ${_PZC_GPU_DEFAULT_COMPILER} = "NVCC" ]]
  then
    echo "local _PZC_GPU_DEFAULT_COMPILER=NVCC # Or SYCL" >> ${_PZC_OUTPUT_FILE}

  else
    echo "#local _PZC_GPU_DEFAULT_COMPILER=NVCC # Or SYCL" >> ${_PZC_OUTPUT_FILE}

  fi

  if [[ -v _PZC_GPU_TARGET_ARCH ]]
  then
    echo "local _PZC_GPU_TARGET_ARCH=\"${_PZC_GPU_TARGET_ARCH}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#local _PZC_GPU_TARGET_ARCH=\"89\"" >> ${_PZC_OUTPUT_FILE}
  fi


  echo "" >> ${_PZC_OUTPUT_FILE}


  if [[ ${_PZC_NVCC_BIN_AVAILABLE} = 1 ]]
  then
    echo "local _PZC_NVCC_BIN_AVAILABLE=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_NVCC_BIN_AVAILABLE=0" >> ${_PZC_OUTPUT_FILE}
  fi


  if [[ -v PZC_NVCC_BIN ]]
  then
    echo "export PZC_NVCC_BIN=\"${PZC_NVCC_BIN}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#export PZC_NVCC_BIN=nvcc" >> ${_PZC_OUTPUT_FILE}
  fi


  if [[ -v PZC_NVCC_HOST_COMPILER_BIN ]]
  then
    echo "export PZC_NVCC_HOST_COMPILER_BIN=\"${PZC_NVCC_HOST_COMPILER_BIN}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#export PZC_NVCC_HOST_COMPILER_BIN=g++-12" >> ${_PZC_OUTPUT_FILE}
  fi

  echo "" >> ${_PZC_OUTPUT_FILE}


  if [[ ${_PZC_SYCL_BIN_AVAILABLE} = 1 ]]
  then
    echo "local _PZC_SYCL_BIN_AVAILABLE=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "local _PZC_SYCL_BIN_AVAILABLE=0" >> ${_PZC_OUTPUT_FILE}
  fi

  if [[ -v PZC_SYCL_BIN ]]
  then
    echo "export PZC_SYCL_BIN=\"${PZC_SYCL_BIN}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#export PZC_SYCL_BIN=sycl" >> ${_PZC_OUTPUT_FILE}
  fi

  if [[ -v PZC_SYCL_HOST_COMPILER_BIN ]]
  then
    echo "export PZC_SYCL_HOST_COMPILER_BIN=\"${PZC_SYCL_HOST_COMPILER_BIN}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#export PZC_SYCL_HOST_COMPILER_BIN=clang++" >> ${_PZC_OUTPUT_FILE}
  fi

  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# ---------- TODOlist path ---------" >> ${_PZC_OUTPUT_FILE}
  echo "# ----------------------------------" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and complete if you have a todolist." >> ${_PZC_OUTPUT_FILE}
  if [[ -v _PZC_TODOLIST_PATH ]]
  then
    echo "local _PZC_TODOLIST_PATH=\"${_PZC_TODOLIST_PATH}\"" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#local _PZC_TODOLIST_PATH=" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
  echo "# [TODO] Uncomment and edit if your todolist is encrypted (1) or not (0)." >> ${_PZC_OUTPUT_FILE}
  if [[ ${_PZC_TODOLIST_ENC} = 1 ]]
  then
    echo "local _PZC_TODOLIST_ENC=1" >> ${_PZC_OUTPUT_FILE}
  else
    echo "#local _PZC_TODOLIST_ENC=0" >> ${_PZC_OUTPUT_FILE}
  fi
  echo "" >> ${_PZC_OUTPUT_FILE}
}

_pzc_launch_pzc_update()
{
  mv ${PZC_PZCRC_DIR}/.pzcrc ${PZC_PZCRC_DIR}/.pzcrc.old
  _pzc_info "A copy of your .pzcrc is available here: ${PZC_PZCRC_DIR}/.pzcrc.old"

  local _PZC_OUTPUT_FILE="${PZC_PZCRC_DIR}/.pzcrc"

  if [[ ${_PZC_CONFIG_VERSION[1]} -eq 5 ]]
  then
    _pzc_info "Updating from .zshrc file (PZC v5 or lower) to v6.0.0 .pzcrc file..."
    _pzc_update_pzcrc_5
  fi

  _pzc_info "Update done. Restarting zsh..."
  exec zsh
}

_pzc_check_update()
{
  source ${_PZC_PZC_DIR}/_version_checker.zsh

  local _PZC_VERSION_CHECKER_RET=0
  _pzc_version_checker ${_PZC_CONFIG_VERSION} ${_PZC_CONFIG_LAST_VERSION}

  if [[ ${_PZC_VERSION_CHECKER_RET} = 2 ]]
  then
    _PZC_LOG_ERROR=1
    _pzc_error "PZC is too old to read your .pzcrc. Please update PZC (git pull)."
    echo "\033[0;101m\033[30m             Your .pzcrc version:                     v${_PZC_CONFIG_VERSION[1]}.${_PZC_CONFIG_VERSION[2]}.${_PZC_CONFIG_VERSION[3]} \033[0m"
    echo "\033[0;101m\033[30m             Latest version supported by PZC v${PZC_VERSION[1]}.${PZC_VERSION[2]}.${PZC_VERSION[3]}: v${_PZC_CONFIG_VERSION_NEEDED[1]}.${_PZC_CONFIG_VERSION_NEEDED[2]}.${_PZC_CONFIG_VERSION_NEEDED[3]} \033[0m"
    _PZC_FATAL_ERROR=1
    return 0

  elif [[ ${_PZC_VERSION_CHECKER_RET} = 1 ]]
  then
    _pzc_info "Your .pzcrc file is not up to date. Updating..."
    _pzc_launch_pzc_update
    # Ne devrait pas aller ici.
    _PZC_FATAL_ERROR=1
    return 0

  else
    _pzc_debug ".pzcrc Checker OK"
  fi

  unfunction _pzc_version_checker

  unfunction _pzc_update_pzcrc_5
  unfunction _pzc_launch_pzc_update
}
