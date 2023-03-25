# Personal ZSH Configuration
## Installation

```zsh
# Goto home:
cd

# Move ~/.zshrc:
mv ~/.zshrc ~/.zshrc.old

# Clone this repo in your home:
git clone git@github.com:AlexlHer/zsh_config.git .pzc

# Copy ~/.pzc/home.zshrc to ~/.zshrc:
cp ~/.pzc/home.zshrc ~/.zshrc

# Edit "~/.zshrc":
# Search "[TODO]" to find lines to edit.
vim ~/.zshrc
```

## Update
```zsh
cd ~/.pzc
git stash
git pull
git stash pop
```

## Optional progs
- exa
- age (needed to decrypt local files)
- oh-my-posh
- mold
