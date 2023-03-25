
## ----- Config Launcher -----
## Put this file in your home,
## rename this file to ".zshrc".




# -----------------------------
# ----- SSH keys location -----
# -----------------------------
# [TODO] Uncomment and complete if you want to use 'agee' and 'aged' functions.
#export _PZC_SSH_PUB=
#export _PZC_SSH_PRI=


# -----------------------------
# --- OH-MY-POSH theme path ---
# -----------------------------
# [TODO] Uncomment and complete if you have a custom oh-my-posh theme.
#export _PZC_OMP_THEME_PATH=


# -----------------------------
# ------ OH-MY-POSH path ------
# -----------------------------
# [TODO] Uncomment and complete if you have a custom installation of oh-my-posh (which is not in PATH).
#export _PZC_OMP_PATH=


# -----------------------------
# ------- AGE/RAGE path -------
# -----------------------------
# [TODO] Uncomment and complete if you have a custom installation of age or rage (which is not in PATH).
#export _PZC_AGE_PATH=


# -----------------------------
# -------- EXA-LS path --------
# -----------------------------
# [TODO] Uncomment and complete if you have a custom installation of EXA-LS (which is not in PATH).
#export _PZC_EXA_PATH=


# -----------------------------
# --------- MOLD path ---------
# -----------------------------
# [TODO] Uncomment and complete if you have a custom installation of mold (which is not in PATH).
#export _PZC_MOLD_PATH=



# -----------------------------
# ----------- PC ID -----------
# -----------------------------
# [TODO] Uncomment if you are AlexlHer :-).
#export _PZC_PC_ID="f"
#export _PZC_PC_ID="p"
#export _PZC_PC_ID="c"




# Personnal ZSH config directory.
export _PZC_PZC_DIR=${HOME}/.pzc

# Source of true zshrc.
if [[ -e ${_PZC_PZC_DIR}/zshrc ]]
then
  source ${_PZC_PZC_DIR}/zshrc

else
  echo "Error: Main zshrc not found... Minimal execution."
  
fi
