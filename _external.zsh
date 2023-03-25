
## ----- External progs search section -----



# ---------------------------------------------------------------
# -------------------------- OhMyPosh ---------------------------
# ---------------------------------------------------------------

if [[ -x "$(command -v oh-my-posh)" ]]
then
  _PZC_OMP_PATH=oh-my-posh

elif [[ -e ${ZSH_DIR}/progs/oh-my-posh/oh-my-posh ]]
then
  _PZC_OMP_PATH=${ZSH_DIR}/progs/oh-my-posh/oh-my-posh

else
  echo "Warning: oh-my-posh is not installed (https://github.com/JanDeDobbeleer/oh-my-posh)"

fi


if [[ -v _PZC_OMP_THEME_PATH ]]
then
  if [[ ! -e ${_PZC_OMP_THEME_PATH} ]]
  then
    echo "Warning: your oh-my-posh theme is not found. Set default theme."
    _PZC_OMP_THEME_PATH=${ZSH_DIR}/progs/oh-my-posh/themes/OhMyZSH.json
    
  fi

else
  _PZC_OMP_THEME_PATH=${ZSH_DIR}/progs/oh-my-posh/themes/OhMyZSH.json
fi

if [[ ! -e ${_PZC_OMP_THEME_PATH} ]]
then
  echo "Warning: Default oh-my-posh theme is not found (https://github.com/JanDeDobbeleer/oh-my-posh)"
  unset _PZC_OMP_THEME_PATH
fi



# ---------------------------------------------------------------
# -------------------------- Age/Rage ---------------------------
# ---------------------------------------------------------------

if [[ -x "$(command -v age)" ]]
then
  _PZC_AGE_PATH=age

elif [[ -x "$(command -v rage)" ]]
then
  _PZC_AGE_PATH=rage

elif [[ -e ${ZSH_DIR}/progs/age/age ]]
then
  _PZC_AGE_PATH=${ZSH_DIR}/progs/age/age
  
else
  echo "Warning: age is not installed (https://github.com/FiloSottile/age)"

fi



# ---------------------------------------------------------------
# --------------------------- EXA-LS ----------------------------
# ---------------------------------------------------------------

if [[ -x "$(command -v exa)" ]]
then
  _PZC_EXA_PATH=exa

elif [[ -e ${ZSH_DIR}/progs/exa/exa ]]
then
  _PZC_EXA_PATH=${ZSH_DIR}/progs/exa/exa
  
else
  echo "Warning: exa is not installed (https://github.com/ogham/exa)"

fi



# ---------------------------------------------------------------
# ---------------------------- Mold -----------------------------
# ---------------------------------------------------------------

if [[ -x "$(command -v mold)" ]]
then
  _PZC_MOLD_PATH=mold

elif [[ -e ${ZSH_DIR}/progs/mold/mold ]]
then
  _PZC_MOLD_PATH=${ZSH_DIR}/progs/mold/mold
  
else
  echo "Warning: mold is not installed (https://github.com/rui314/mold)"

fi
