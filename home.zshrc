
## ----- Config Launcher -----
## Put this file in your home,
## rename this file to ".zsh".



export ZSH_DIR=~/.zsh

# Source of true zshrc.
if [[ -e $ZSH_DIR/zshrc ]]
then
  source $ZSH_DIR/zshrc

else
  echo "Main zshrc not found... Minimal execution."
  
fi
