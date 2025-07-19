
## ----- ZSH config -----

# ----------------------------------
# ------- Path configuration -------
# ----------------------------------

#export PATH=/usr/bin:${PATH}

# ==================================
# ==================================

# To configure PZC, you can edit ${HOME}/.pzcrc file.

# [TODO]
_PZC_PZC_DIR=${HOME}/.pzc

# ----------------------------------
# -------- Launching PZC... --------
# ----------------------------------
if [[ -e ${_PZC_PZC_DIR}/pzc.zsh ]]
then
  source ${_PZC_PZC_DIR}/pzc.zsh

else
  echo "Error: PZC launcher not found... Minimal execution."
  
fi
