
## ----- For PC.F Only -----



# ---------------------------------------------------------------
# ---------------------------- Path -----------------------------
# ---------------------------------------------------------------

export PATH="\
${HOME}/.arm/forge/22.1.2/bin\
:${PATH}"



# ---------------------------------------------------------------
# ------------------ Proton/Wine Functions ----------------------
# ---------------------------------------------------------------

runproton()
{
  source ~/.proton/proton_vars.sh
  "${PROTON_EXE}" run ${1}
}



# ---------------------------------------------------------------
# ----------------------- Ytb aliases ---------------------------
# ---------------------------------------------------------------

alias ytmp3='_coal "yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o \"%(title)s.%(ext)s\"" ; \
yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o "%(title)s.%(ext)s"'

alias ytmp4='_coal "yt-dlp -f bestvideo+bestaudio --recode-video mp4 -o \"%(title)s.%(ext)s\"" ; \
yt-dlp -f bestvideo+bestaudio --recode-video mp4 -o "%(title)s.%(ext)s"'



# ---------------------------------------------------------------
# ------------------- Pacman/YAY aliases ------------------------
# ---------------------------------------------------------------

alias pmup='_coal_eval "sudo pacman -Syu"'
alias yup='_coal_eval "yay -Syu"'
