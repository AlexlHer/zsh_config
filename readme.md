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

# Edit "~/.zshrc":
# Search "[TODO]" to find lines to edit.
vim ~/.zshrc
```

## Update
```zsh
cd ~/.zsh
git stash
git pull
git stash pop
```

## Optional progs
- exa
- age (needed to decrypt local files)
- oh-my-posh
- mold
