
## ----- Config Launcher -----
## Put this file in your home,
## rename this file to ".zsh".


# ZSH config directory.
export ZSH_DIR=${HOME}/.zsh

# Source of true zshrc.
if [[ -e ${ZSH_DIR}/zshrc ]]
then
  source ${ZSH_DIR}/zshrc

else
  echo "Main zshrc not found... Minimal execution."
  
fi
