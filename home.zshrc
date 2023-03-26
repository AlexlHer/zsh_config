
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
# ------ OH-MY-POSH theme path -----
# ----------------------------------
# [TODO] Uncomment and complete if you have a custom oh-my-posh theme.
#local _PZC_OMP_THEME_PATH=


# ----------------------------------
# --------- OH-MY-POSH path --------
# ----------------------------------
# [TODO] Uncomment and complete if you have a custom installation of oh-my-posh (which is not in PATH).
#local _PZC_OMP_PATH=


# ----------------------------------
# ---------- AGE/RAGE path ---------
# ----------------------------------
# [TODO] Uncomment and complete if you have a custom installation of age or rage (which is not in PATH).
#local _PZC_AGE_PATH=


# ----------------------------------
# ----------- EXA-LS path ----------
# ----------------------------------
# [TODO] Uncomment and complete if you have a custom installation of EXA-LS (which is not in PATH).
#local _PZC_EXA_PATH=


# ----------------------------------
# ------------ MOLD path -----------
# ----------------------------------
# [TODO] Uncomment and complete if you have a custom installation of mold (which is not in PATH).
#local _PZC_MOLD_PATH=


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
