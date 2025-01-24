
## ----- Config Launcher -----
## Put this file in your home,
## rename this file to ".zshrc".



# ==================================
# ==================================

# ----------------------------------
# ------- Path configuration -------
# ----------------------------------

#export PATH=/usr/bin:${PATH}



# ==================================
# ==================================

# ----------------------------------
# -------- SSH keys location -------
# ----------------------------------
# [TODO] Uncomment and complete if you want to use 'agee' and 'aged' functions.
#local _PZC_SSH_PUB=
#local _PZC_SSH_PRI=


# ----------------------------------
# ----------- OH-MY-POSH -----------
# ----------------------------------
# [TODO] If you want to use Oh-My-Posh, set this variable to 1.
local _PZC_OMP_AVAILABLE=1

# [TODO] Uncomment and complete if you have a custom installation of Oh-My-Posh (which is not in PATH).
#local _PZC_OMP_BIN=

# [TODO] Uncomment and complete if you have a custom Oh-My-Posh theme.
#local _PZC_OMP_THEME_FILE=


# ----------------------------------
# ------------ AGE/RAGE ------------
# ----------------------------------
# [TODO] If you want to use age or rage, set this variable to 1.
local _PZC_AGE_AVAILABLE=1

# [TODO] Uncomment and complete if you have a custom installation of age or rage (which is not in PATH).
#local _PZC_AGE_BIN=


# ----------------------------------
# ------------- EZA-LS -------------
# ----------------------------------
# [TODO] If you want to use eza-ls, set this variable to 1.
local _PZC_EZA_AVAILABLE=1

# [TODO] Uncomment and complete if you have a custom installation of EZA-LS (which is not in PATH).
#local _PZC_EZA_BIN=

# [TODO] Uncomment and complete if you have a custom EZA theme.
#local _PZC_EZA_CONFIG_DIR=


# ----------------------------------
# ------------- CCACHE -------------
# ----------------------------------
# [TODO] If you want to use ccache, set this variable to 1.
local _PZC_CCACHE_AVAILABLE=1

# [TODO] Uncomment and complete if you have a custom installation of ccache (which is not in PATH).
#local _PZC_CCACHE_BIN=


# ----------------------------------
# -------------- MOLD --------------
# ----------------------------------
# [TODO] If you want to use mold, set this variable to 1.
local _PZC_MOLD_AVAILABLE=1

# [TODO] Uncomment and complete if you have a custom installation of mold.
# Note: This PATH will be add in PATH.
#local _PZC_MOLD_PATH=


# ----------------------------------
# ------------- NINJA --------------
# ----------------------------------
# [TODO] If you want to use ninja, set this variable to 1.
local _PZC_NINJA_AVAILABLE=1

# [TODO] Uncomment and complete if you have a custom installation of ninja.
# Note: This PATH will be add in PATH.
#local _PZC_NINJA_PATH=


# ----------------------------------
# ------------- CMAKE --------------
# ----------------------------------
# [TODO] If you want to use cmake, set this variable to 1.
local _PZC_CMAKE_AVAILABLE=1

# [TODO] Uncomment and complete if you have a custom installation of cmake.
# Note: This PATH will be add in PATH.
#local _PZC_CMAKE_PATH=


# ----------------------------------
# ---------- TASKWARRIOR -----------
# ----------------------------------
# [TODO] If you want to use taskwarrior, set this variable to 1.
local _PZC_TASK_AVAILABLE=1

# [TODO] Uncomment and complete if you have a custom installation of taskwarrior.
# Note: This PATH will be add in PATH.
#local _PZC_TASK_PATH=


# ----------------------------------
# ------------- CHMOD --------------
# ----------------------------------
# [TODO] In case of problem with permissions after compiling,
# active this option.
local _PZC_CHMOD_COMPILING=0


# ----------------------------------
# ----------- COMPILERS ------------
# ----------------------------------
# [TODO] Setup available compilers.
local _PZC_C_CXX_DEFAULT_COMPILER=GCC # Or CLANG

local _PZC_GCC_AVAILABLE=1
#export PZC_C_GCC_BIN=gcc
#export PZC_CXX_GCC_BIN=g++

local _PZC_CLANG_AVAILABLE=1
#export PZC_C_CLANG_BIN=clang
#export PZC_CXX_CLANG_BIN=clang++

#local _PZC_GPU_DEFAULT_COMPILER=NVCC # Or SYCL
#local _PZC_GPU_TARGET_ARCH="89"

#local _PZC_NVCC_BIN_AVAILABLE=1
#export PZC_NVCC_BIN=nvcc
#export PZC_NVCC_HOST_COMPILER_BIN=g++-12

#local _PZC_SYCL_BIN_AVAILABLE=1
#export PZC_SYCL_BIN=sycl
#export PZC_SYCL_HOST_COMPILER_BIN=clang++


# ----------------------------------
# ---------- TODOlist path ---------
# ----------------------------------
# [TODO] Uncomment and complete if you have a todolist.
#local _PZC_TODOLIST_PATH=

# [TODO] Uncomment and edit if your todolist is encrypted (1) or not (0).
#local _PZC_TODOLIST_ENC=0


# ----------------------------------
# ----------- File editor ----------
# ----------------------------------
# [TODO] Uncomment and edit if you want to use an other file editor than 'vim'.
#local _PZC_FILE_EDITOR=vim


# ----------------------------------
# --------- TMP directory ----------
# ----------------------------------
# [TODO] Uncomment and edit if you have an other tmp dir than '/tmp'.
#local _PZC_TMP_DIR=/tmp


# ----------------------------------
# -------- Large directory ---------
# ----------------------------------
# [TODO] Uncomment and edit if you have an other large dir than your HOME
#        for all builds/installs/ccache.
#local _PZC_LARGE_DIR=${HOME}

# [TODO] Uncomment and edit if you want more specific directories for your
#        working environment.
#local _PZC_WORK_DIR_PATH=${_PZC_LARGE_DIR}
#local _PZC_BUILD_DIR_PATH=${_PZC_LARGE_DIR}
#local _PZC_ENVI_DIR_PATH=${_PZC_LARGE_DIR}
#local _PZC_CCACHE_DIR_PATH=${_PZC_BUILD_DIR}

# [TODO] Uncomment and edit if you don't want to have builds and installs
#        in the same folder.
#local _PZC_INSTALL_DIR_PATH=${_PZC_LARGE_DIR}


# ----------------------------------
# -------------- PC ID -------------
# ----------------------------------
# [TODO] Uncomment if you are AlexlHer :-).
#local _PZC_PC_ID="f"
#local _PZC_PC_ID="p"
#local _PZC_PC_ID="c"



# ==================================
# ==================================



# ----------------------------------
# ------- Log verbose level --------
# ----------------------------------
local _PZC_LOG_INFO=1
local _PZC_LOG_WARNING=1
local _PZC_LOG_ERROR=1
local _PZC_LOG_DEBUG=0

# ----------------------------------
# - Personnal ZSH config directory -
# ----------------------------------
local _PZC_PZC_DIR=${HOME}/.pzc

# ----------------------------------
# ------ Config file version -------
# ----------------------------------
local _PZC_CONFIG_VERSION=(5 24 0)

# ----------------------------------
# ------ Source of true zshrc ------
# ----------------------------------
if [[ -e ${_PZC_PZC_DIR}/zshrc ]]
then
  source ${_PZC_PZC_DIR}/zshrc

else
  echo "Error: Main zshrc not found... Minimal execution."
  
fi
