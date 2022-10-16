
## ----- Config Launcher -----



# Source of true zshrc.
if [[ -e ~/.zsh/zshrc ]]
then
  source ~/.zsh/zshrc
fi

# Source of local zshrc.
if [[ -e ~/.zshlocalrc ]]
then
  source ~/.zshlocalrc
fi
