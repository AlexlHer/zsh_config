
## ----- ZSH config -----

# ----------------------------------
# ------- Path configuration -------
# ----------------------------------

#export PATH=/usr/bin:${PATH}

# ==================================
# ==================================

# To configure PZC, after a first launch, you can edit ${HOME}/.config/pzc/pzcrc file.

# [TODO] Cloned PZC git repo path.
PZC_PZC_DIR=${HOME}/.pzc

# [TODO] You can edit pzc config dir.
#PZC_PZC_CONFIG_DIR=${HOME}/.config/pzc

# ----------------------------------
# -------- Launching PZC... --------
# ----------------------------------
if [[ -e ${PZC_PZC_DIR}/pzc.zsh ]]
then
  source ${PZC_PZC_DIR}/pzc.zsh

else
  echo "Error: PZC launcher not found... Minimal execution."
  
fi
