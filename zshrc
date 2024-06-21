
## ----- Main zshrc -----



# ---------------------------------------------------------------
# -------------------- Internal PZC sources ---------------------
# ---------------------------------------------------------------

# Source internal
source ${_PZC_PZC_DIR}/_internal.zsh



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
  local _PZC_EZA_PATH=$_PZC_EXA_PATH
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

# Source perso functions (optional)
source ${_PZC_PZC_DIR}/_functions.zsh

# Source local config (optional)
source ${_PZC_PZC_DIR}/_local.zsh

# Source Arcane specific functions (optional)
source ${_PZC_PZC_DIR}/_arcane.zsh

# Source Podman/Docker specific functions (optional)
source ${_PZC_PZC_DIR}/_podman.zsh



# ---------------------------------------------------------------
# ------------------------- Completion --------------------------
# ---------------------------------------------------------------

source ${_PZC_PZC_DIR}/completion/_completion.zsh



# ---------------------------------------------------------------
# -------------------------- OhMyPosh ---------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_OMP_AVAILABLE} = 1 ]]
then
  eval "$(${_PZC_OMP_PATH} init zsh --config ${_PZC_OMP_THEME_PATH})"

else
  autoload -Uz vcs_info
  precmd() { vcs_info }
  zstyle ':vcs_info:git:*' formats '%b '
  setopt PROMPT_SUBST
  PROMPT='%F{green}%*%f %F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '
  
fi
