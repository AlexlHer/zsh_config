
## ----- Config Launcher -----
## Put this file in your home,
## rename this file to ".zshrc".


# ZSH config directory.
export ZSH_DIR=${HOME}/.zsh

# PC ID
# [TODO] Uncomment
#export PC_ID="f"
#export PC_ID="p"
#export PC_ID="c"

# SSH keys location
# [TODO] Complete
#export SSH_PUB=
#export SSH_PRI=


# Source of true zshrc.
if [[ -e ${ZSH_DIR}/zshrc ]]
then
  source ${ZSH_DIR}/zshrc

else
  echo "Main zshrc not found... Minimal execution."
  
fi
