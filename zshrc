
## ----- Main zshrc -----



# ---------------------------------------------------------------
# -------------------------- Sources ----------------------------
# ---------------------------------------------------------------

# Source manjaro-zsh-configuration
source ${_PZC_PZC_DIR}/_manjaro_config.zsh

# Source internal
source ${_PZC_PZC_DIR}/_internal.zsh

# Source external program needed
source ${_PZC_PZC_DIR}/_external.zsh

# Source variable export
source ${_PZC_PZC_DIR}/_export.zsh

# Source perso alias
source ${_PZC_PZC_DIR}/_aliases.zsh

# Source perso functions
source ${_PZC_PZC_DIR}/_functions.zsh

# Source local config
source ${_PZC_PZC_DIR}/_local.zsh

# Source Arcane specific functions
source ${_PZC_PZC_DIR}/_arcane.zsh



# ---------------------------------------------------------------
# -------------------------- OhMyPosh ---------------------------
# ---------------------------------------------------------------

if [[ -v _PZC_OMP_PATH ]] && [[ -v _PZC_OMP_THEME_PATH ]]
then
  eval "$(${_PZC_OMP_PATH} init zsh --config ${_PZC_OMP_THEME_PATH})"
fi
