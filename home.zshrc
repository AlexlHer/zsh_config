
## ----- Config Launcher -----
## Put this file in your home,
## rename this file to ".zshrc".



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
#local _PZC_OMP_PATH=

# [TODO] Uncomment and complete if you have a custom Oh-My-Posh theme.
#local _PZC_OMP_THEME_PATH=


# ----------------------------------
# ------------ AGE/RAGE ------------
# ----------------------------------
# [TODO] If you want to use age or rage, set this variable to 1.
local _PZC_AGE_AVAILABLE=1

# [TODO] Uncomment and complete if you have a custom installation of age or rage (which is not in PATH).
#local _PZC_AGE_PATH=


# ----------------------------------
# ------------- EZA-LS -------------
# ----------------------------------
# [TODO] If you want to use eza-ls, set this variable to 1.
local _PZC_EZA_AVAILABLE=1

# [TODO] Uncomment and complete if you have a custom installation of EZA-LS (which is not in PATH).
#local _PZC_EZA_PATH=


# ----------------------------------
# ------------- CCACHE -------------
# ----------------------------------
# [TODO] If you want to use ccache, set this variable to 1.
local _PZC_CCACHE_AVAILABLE=1

# [TODO] Uncomment and complete if you have a custom installation of ccache (which is not in PATH).
#local _PZC_CCACHE_PATH=


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
# ------------- CHMOD --------------
# ----------------------------------
# [TODO] In case of problem with permissions after compiling,
# active this option.
local _PZC_CHMOD_COMPILING=0


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
# ------ Source of true zshrc ------
# ----------------------------------
if [[ -e ${_PZC_PZC_DIR}/zshrc ]]
then
  source ${_PZC_PZC_DIR}/zshrc

else
  echo "Error: Main zshrc not found... Minimal execution."
  
fi
