# My ZSH Configuration
## Installation

```zsh
# Goto home:
cd

# Remove ~/.zsh folder and ~/.zshrc:
rm -r ~/.zsh
rm ~/.zshrc

# Clone this repo in your home:
git clone git@github.com:AlexlHer/zsh_config.git .zsh

# Copy ~/.zsh/home.zshrc to ~/.zshrc:
cp ~/.zsh/home.zshrc ~/.zshrc

# Edit "zshrc" to select specific local zsh.
# Search "[HERE]" to find lines.
vim ~/.zsh/zshrc
```

## Update
```zsh
cd ~/.zsh
git stash
git pull
git stash pop
```