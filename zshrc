
## ----- Main zshrc -----



# ---------------------------------------------------------------
# -------------------------- Sources ----------------------------
# ---------------------------------------------------------------

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

# OhMyPosh System
if [[ -x "$(command -v oh-my-posh)" ]]
then

  if [[ -e ${ZSH_DIR}/progs/oh-my-posh/themes/OhMyZSH.json ]]
  then
    eval "$(oh-my-posh init zsh --config ${ZSH_DIR}/progs/oh-my-posh/themes/OhMyZSH.json)"
  fi

# Portable OhMyPosh
elif [[ -e ${ZSH_DIR}/progs/oh-my-posh/oh-my-posh ]]
then

  if [[ -e ${ZSH_DIR}/progs/oh-my-posh/themes/OhMyZSH.json ]]
  then
    eval "$(${ZSH_DIR}/progs/oh-my-posh/oh-my-posh init zsh --config ${ZSH_DIR}/progs/oh-my-posh/themes/OhMyZSH.json)"
  fi

fi
