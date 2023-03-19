
## ----- Alias section -----



# ---------------------------------------------------------------
# ---------------------- LS/EXA aliases -------------------------
# ---------------------------------------------------------------

# File and Dir colors for ls and other outputs
export LS_OPTIONS='--color=auto'
eval "$(dircolors -b)"

## --- With EXA-LS ---
if [[ -x "$(command -v exa)" ]]
then
  alias ls='exa --icons'
  alias l='exa --icons --color-scale --time-style long-iso -BghHl'
  alias la='exa --icons --color-scale --time-style long-iso -BghHla'
  local EXA_AVAILABLE=1

## --- With Portable EXA-LS ---
elif [[ -e $ZSH_DIR/progs/exa/exa ]]
then
  alias ls='$ZSH_DIR/progs/exa/exa --icons'
  alias l='$ZSH_DIR/progs/exa/exa --icons --color-scale --time-style long-iso -BghHl'
  alias la='$ZSH_DIR/progs/exa/exa --icons --color-scale --time-style long-iso -BghHla'
  local EXA_AVAILABLE=1

## --- Without EXA-LS ---
else
  alias ls='ls $LS_OPTIONS'
  alias l='ls -l $LS_OPTIONS'
  alias la='ls -la $LS_OPTIONS'
fi



# ---------------------------------------------------------------
# ----------------------- GREP aliases --------------------------
# ---------------------------------------------------------------

alias grep='grep --color=always'



# ---------------------------------------------------------------
# ------------------------ GIT aliases --------------------------
# ---------------------------------------------------------------

alias gits='_coal "git status" ; git status'
alias gita='_coal "git add" ; git add'
alias gitc='_coal "git commit" ; git commit'
alias gitca='_coal "git commit --amend --no-edit" ; git commit --amend --no-edit'
alias gitco='_coal "git checkout" ; git checkout'
alias gitp='_coal "git push" ; git push'
alias gitw='_coal "git switch -c" ; git switch -c'
alias gitka='_coal "gitk --all" ; gitk --all'



# ---------------------------------------------------------------
# ----------------------- CP/MV aliases -------------------------
# ---------------------------------------------------------------

alias cpf='_coal "cp" ; cp'
alias cp='_coal "cp -i" ; cp -i'

alias mvf='_coal "mv" ; mv'
alias mv='_coal "mv -i" ; mv -i'

alias df='_coal "df -h" ; df -h'
alias free='_coal "free -m" ; free -m'



# ---------------------------------------------------------------
# ------------------------ CD aliases ---------------------------
# ---------------------------------------------------------------

alias cdbi='cd ${BUILD_DIR}'
alias cdw='cd ${WORK_DIR}'



# ---------------------------------------------------------------
# ------------------------ TAR aliases --------------------------
# ---------------------------------------------------------------

alias tarcxz='_coal "tar -Ipixz -cf" ; tar -Ipixz -cf'
alias tarxxz='_coal "tar -Ipixz -xf" ; tar -Ipixz -xf'



# ---------------------------------------------------------------
# ----------------------- WINE aliases --------------------------
# ---------------------------------------------------------------

alias wine32='_coal "WINEPREFIX=~/.wine32 wine" ; WINEPREFIX=~/.wine32 wine'
alias winetricks32='_coal "WINEPREFIX=~/.wine32 winetricks" ; WINEPREFIX=~/.wine32 winetricks'



# ---------------------------------------------------------------
# ------------------------ KDE aliases --------------------------
# ---------------------------------------------------------------

alias restartkde='_coal_eval "kstart5 plasmashell -- --replace"'



# ---------------------------------------------------------------
# ---------------------- Podman aliases -------------------------
# ---------------------------------------------------------------

alias pm='_coal "podman" ; podman'
alias docker='_coal "podman" ; podman'



# ---------------------------------------------------------------
# ------------------- Pacman/YAY aliases ------------------------
# ---------------------------------------------------------------

alias pa='_coal "sudo pacman" ; sudo pacman'
alias pas='_coal_eval "sudo pacman -S"'
alias pass='_coal_eval "sudo pacman -Ss"'
alias paup='_coal_eval "sudo pacman -Syu"'
alias yup='_coal_eval "yay -Syu"'



# ---------------------------------------------------------------
# ----------------------- Ytb aliases ---------------------------
# ---------------------------------------------------------------

alias ytmp3='_coal "yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o \"%(title)s.%(ext)s\"" ; \
yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o "%(title)s.%(ext)s"'

alias ytmp4='_coal "yt-dlp -f bestvideo+bestaudio --recode-video mp4 -o \"%(title)s.%(ext)s\"" ; \
yt-dlp -f bestvideo+bestaudio --recode-video mp4 -o "%(title)s.%(ext)s"'
