
## ----- Config Launcher -----
## Put this file in your home,
## rename this file to ".zshrc".



# PC ID
# [TODO] Uncomment
#export PC_ID="f"
#export PC_ID="p"
#export PC_ID="c"

# SSH keys location
# [TODO] Complete
#export SSH_PUB=
#export SSH_PRI=

# OH-MY-POSH theme path
# [TODO] Complete if you have custom oh-my-posh theme
#export _PZC_OMP_THEME_PATH=




# ZSH config directory.
export ZSH_DIR=${HOME}/.zsh

# Source of true zshrc.
if [[ -e ${ZSH_DIR}/zshrc ]]
then
  source ${ZSH_DIR}/zshrc

else
  echo "Main zshrc not found... Minimal execution."
  
fi
