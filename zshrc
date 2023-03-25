
## ----- Main zshrc -----



# ---------------------------------------------------------------
# -------------------------- Sources ----------------------------
# ---------------------------------------------------------------

# Source external program needed
source ${ZSH_DIR}/_external.zsh

# Source manjaro-zsh-configuration
source ${ZSH_DIR}/_manjaro_config.zsh

# Source internal
source ${ZSH_DIR}/_internal.zsh

# Source variable export
source ${ZSH_DIR}/_export.zsh

# Source perso alias
source ${ZSH_DIR}/_aliases.zsh

# Source perso functions
source ${ZSH_DIR}/_functions.zsh

# Source local config
source ${ZSH_DIR}/_local.zsh

# Source Arcane specific functions
source ${ZSH_DIR}/_arcane.zsh



# ---------------------------------------------------------------
# -------------------------- OhMyPosh ---------------------------
# ---------------------------------------------------------------

if [[ -v _PZC_OMP_PATH ]] && [[ -v _PZC_OMP_THEME_PATH ]]
then
  eval "$(${_PZC_OMP_PATH} init zsh --config ${_PZC_OMP_THEME_PATH})"
fi
