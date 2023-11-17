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
- oh-my-posh (https://github.com/JanDeDobbeleer/oh-my-posh)
- eza (https://github.com/eza-community/eza)
- age (https://github.com/FiloSottile/age)
- mold (https://github.com/rui314/mold)
