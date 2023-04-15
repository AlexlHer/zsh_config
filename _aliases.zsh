
## ----- Alias section -----



# ---------------------------------------------------------------
# ---------------------- LS/EXA aliases -------------------------
# ---------------------------------------------------------------

# File and Dir colors for ls and other outputs
export LS_OPTIONS='--color=auto'
eval "$(dircolors -b)"

## --- With EXA-LS ---
if [[ ${_PZC_EXA_AVAILABLE} = 1 ]]
then
  _pzc_debug "Aliases for EXA-LS."
  alias ls='${_PZC_EXA_PATH} --icons'
  alias l='${_PZC_EXA_PATH} --icons --color-scale --time-style long-iso -BghHl'
  alias la='${_PZC_EXA_PATH} --icons --color-scale --time-style long-iso -BghHla'

## --- Without EXA-LS ---
else
  _pzc_debug "Aliases for LS (not EXA-LS)."
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

alias gits='_pzc_coal "git status" ; git status'
alias gita='_pzc_coal "git add" ; git add'
alias gitc='_pzc_coal "git commit" ; git commit'
alias gitca='_pzc_coal "git commit --amend --no-edit" ; git commit --amend --no-edit'
alias gitco='_pzc_coal "git checkout" ; git checkout'
alias gitp='_pzc_coal "git push" ; git push'
alias gitw='_pzc_coal "git switch -c" ; git switch -c'
alias gitka='_pzc_coal "gitk --all" ; gitk --all'



# ---------------------------------------------------------------
# ----------------------- CP/MV aliases -------------------------
# ---------------------------------------------------------------

alias cpf='_pzc_coal "cp" ; cp'
alias cp='_pzc_coal "cp -i" ; cp -i'

alias mvf='_pzc_coal "mv" ; mv'
alias mv='_pzc_coal "mv -i" ; mv -i'

alias df='_pzc_coal "df -h" ; df -h'
alias free='_pzc_coal "free -m" ; free -m'



# ---------------------------------------------------------------
# ------------------------ CD aliases ---------------------------
# ---------------------------------------------------------------

alias cdbi='_pzc_coal_eval "cd ${BUILD_DIR}"'
alias cdw='_pzc_coal_eval "cd ${WORK_DIR}"'



# ---------------------------------------------------------------
# ------------------------ TAR aliases --------------------------
# ---------------------------------------------------------------

alias tarcxz='_pzc_coal "tar -Ipixz -cf" ; tar -Ipixz -cf'
alias tarxxz='_pzc_coal "tar -Ipixz -xf" ; tar -Ipixz -xf'



# ---------------------------------------------------------------
# ----------------------- WINE aliases --------------------------
# ---------------------------------------------------------------

alias wine32='_pzc_coal "WINEPREFIX=~/.wine32 wine" ; WINEPREFIX=~/.wine32 wine'
alias winetricks32='_pzc_coal "WINEPREFIX=~/.wine32 winetricks" ; WINEPREFIX=~/.wine32 winetricks'



# ---------------------------------------------------------------
# ------------------------ KDE aliases --------------------------
# ---------------------------------------------------------------

alias restartkde='_pzc_coal_eval "kstart5 plasmashell -- --replace"'



# ---------------------------------------------------------------
# ---------------------- Podman aliases -------------------------
# ---------------------------------------------------------------

alias pm='_pzc_coal "podman" ; podman'
alias docker='_pzc_coal "podman" ; podman'



# ---------------------------------------------------------------
# ------------------- Pacman/YAY aliases ------------------------
# ---------------------------------------------------------------

alias pa='_pzc_coal "sudo pacman" ; sudo pacman'
alias pas='_pzc_coal "sudo pacman -S" ; sudo pacman -S'
alias pass='_pzc_coal "sudo pacman -Ss" ; sudo pacman -Ss'
alias paup='_pzc_coal "sudo pacman -Syu" ; sudo pacman -Syu'
alias yup='_pzc_coal_eval "yay -Syua"'



# ---------------------------------------------------------------
# ----------------------- Ytb aliases ---------------------------
# ---------------------------------------------------------------

alias ytmp3='_pzc_coal "yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o \"%(title)s.%(ext)s\"" ; \
yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o "%(title)s.%(ext)s"'

# With thumbnail.
alias ytmp32='_pzc_coal "yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail -o \"%(title)s.%(ext)s\"" ; \
yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail -o "%(title)s.%(ext)s"'

alias ytmp4='_pzc_coal "yt-dlp -f bestvideo+bestaudio --recode-video mp4 -o \"%(title)s.%(ext)s\"" ; \
yt-dlp -f bestvideo+bestaudio --recode-video mp4 -o "%(title)s.%(ext)s"'
