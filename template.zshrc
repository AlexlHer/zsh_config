
## ----- ZSH config -----

# ----------------------------------
# ------- Path configuration -------
# ----------------------------------

#export PATH=/usr/bin:${PATH}

# ==================================
# ==================================

# To configure PZC, you can edit ${HOME}/.pzcrc file.

# [TODO]
PZC_PZC_DIR=${HOME}/.pzc

# ----------------------------------
# -------- Launching PZC... --------
# ----------------------------------
if [[ -e ${PZC_PZC_DIR}/pzc.zsh ]]
then
  source ${PZC_PZC_DIR}/pzc.zsh

else
  echo "Error: PZC launcher not found... Minimal execution."
  
fi
