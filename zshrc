
## ----- Main zshrc -----

# PZC Version
local _PZC_VERSION=(5 24 2)
local _PZC_CONFIG_LAST_VERSION=(5 24 0)
local _PZC_CONFIG_VERSION_NEEDED=(5 16 0)



# ---------------------------------------------------------------
# -------------------- Internal PZC sources ---------------------
# ---------------------------------------------------------------

local _PZC_FATAL_ERROR=0
# Source internal
source ${_PZC_PZC_DIR}/_internal.zsh


if [[ ${_PZC_FATAL_ERROR} = 0 ]]
then

# ---------------------------------------------------------------
# --------------------- Compatibility part ----------------------
# ---------------------------------------------------------------

# TODO : Deprecated
if [[ -v _PZC_EXA_AVAILABLE ]]
then
  _pzc_warning "EXA-LS is deprecated and replaced by EZA-LS. Please replace the '_PZC_EXA_AVAILABLE' variable by the '_PZC_EZA_AVAILABLE' variable in your .zshrc."
  local _PZC_EZA_AVAILABLE=$_PZC_EXA_AVAILABLE
fi

if [[ -v _PZC_EXA_PATH ]]
then
  _pzc_warning "EXA-LS is deprecated and replaced by EZA-LS. Please replace the '_PZC_EXA_PATH' variable by the '_PZC_EXA_PATH' variable in your .zshrc."
  local _PZC_EZA_BIN=$_PZC_EXA_PATH
fi



# ---------------------------------------------------------------
# -------------------------- Sources ----------------------------
# ---------------------------------------------------------------

# Source manjaro-zsh-configuration
source ${_PZC_PZC_DIR}/_manjaro_config.zsh

# Source external program needed
source ${_PZC_PZC_DIR}/_external.zsh

# Source variable export
source ${_PZC_PZC_DIR}/_export.zsh

# Source perso alias (optional)
source ${_PZC_PZC_DIR}/_aliases.zsh

# Source perso KDE specific part (optional)
source ${_PZC_PZC_DIR}/_kde.zsh

# Source perso encrypt/decrypt functions (optional)
source ${_PZC_PZC_DIR}/_enc_functions.zsh

# Source perso functions (optional)
source ${_PZC_PZC_DIR}/_functions.zsh

# Source local config (optional)
source ${_PZC_PZC_DIR}/_local.zsh

# Source CMake specific functions (optional)
source ${_PZC_PZC_DIR}/_cmake_projects.zsh

# Source Arcane specific functions (optional)
source ${_PZC_PZC_DIR}/_arcane.zsh

# Source Podman/Docker specific functions (optional)
source ${_PZC_PZC_DIR}/_podman.zsh

# Source Python specific functions (optional)
source ${_PZC_PZC_DIR}/_python.zsh



# ---------------------------------------------------------------
# ------------------------- Completion --------------------------
# ---------------------------------------------------------------

source ${_PZC_PZC_DIR}/completion/_completion.zsh



# ---------------------------------------------------------------
# --------------------------- Prompt ----------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_OMP_AVAILABLE} = 1 ]] && [[ ! -v SIMPLE_TERM ]]
then
  eval "$(${_PZC_OMP_BIN} init zsh --config ${_PZC_OMP_THEME_FILE})"

else
  setopt PROMPT_SUBST
  NEWLINE=$'\n'
  #PROMPT="[RET=%?][%*]${NEWLINE}${NEWLINE}[%n][%m]${NEWLINE}[%~]${NEWLINE}> "
  PROMPT="%F{006}[RET=%?]%f%F{006}[%*]%f${NEWLINE}${NEWLINE}%F{001}[%n]%f%F{003}[%m]%f${NEWLINE}%F{002}[%~]%f${NEWLINE}%F{006}>%f "
  #PROMPT="%F{006}[RET=%?]%f%F{014}[%*]%f${NEWLINE}${NEWLINE}%F{009}[%n]%f%F{011}[%m]%f${NEWLINE}%F{010}[%~]%f${NEWLINE}%F{014}>%f "
fi

# if _PZC_FATAL_ERROR
else
  echo ""
  echo "\033[0;101m\033[30m   Error: A fatal error have been detected in PZC configuration. Check previous messages to fix it. Minimal execution. \033[0m"
  setopt PROMPT_SUBST
  NEWLINE=$'\n'
  PROMPT="[RET=%?][%*]${NEWLINE}${NEWLINE}[%n][%m]${NEWLINE}[%~]${NEWLINE}> "
fi
