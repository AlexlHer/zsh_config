# Personal ZSH Configuration
## First installation
```sh
# Goto home:
cd

# Move ~/.zshrc:
mv ~/.zshrc ~/.zshrc.old

# Clone this repo in your home:
git clone https://github.com/AlexlHer/zsh_config .pzc

# Copy ~/.pzc/home.zshrc to ~/.zshrc:
cp ~/.pzc/template.zshrc ~/.zshrc

# Edit "~/.pzcrc":
# Search "[TODO]" to find lines to edit.
vim ~/.pzcrc

# If you have a PATH edit in your old .zshrc, you can edit the new .zshrc:
vim ~/.zshrc
```

## Update
```sh
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
- atuin (https://github.com/atuinsh/atuin)
