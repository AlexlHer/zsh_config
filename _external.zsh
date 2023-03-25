
## ----- External progs search section -----



# ---------------------------------------------------------------
# -------------------------- OhMyPosh ---------------------------
# ---------------------------------------------------------------

if [[ -v _PZC_OMP_PATH ]] && [[ ! -e ${_PZC_OMP_PATH} ]]
then
  echo "Warning: your oh-my-posh is not found. Search other oh-my-posh."
  unset _PZC_OMP_PATH

fi

if [[ ! -v _PZC_OMP_PATH ]]
then

  if [[ -x "$(command -v oh-my-posh)" ]]
  then
    _PZC_OMP_PATH=oh-my-posh

  elif [[ -e ${_PZC_PZC_DIR}/progs/oh-my-posh/oh-my-posh ]]
  then
    _PZC_OMP_PATH=${_PZC_PZC_DIR}/progs/oh-my-posh/oh-my-posh

  else
    echo "Warning: oh-my-posh is not installed (https://github.com/JanDeDobbeleer/oh-my-posh)"

  fi
fi



if [[ -v _PZC_OMP_THEME_PATH ]] && [[ ! -e ${_PZC_OMP_THEME_PATH} ]]
then
  echo "Warning: your oh-my-posh theme is not found. Search default oh-my-posh theme."
  unset _PZC_OMP_THEME_PATH

fi

if [[ ! -v _PZC_OMP_THEME_PATH ]]
then

  if [[ -e ${_PZC_PZC_DIR}/progs/oh-my-posh/themes/OhMyZSH.json ]]
  then
    _PZC_OMP_THEME_PATH=${_PZC_PZC_DIR}/progs/oh-my-posh/themes/OhMyZSH.json

  else
    echo "Warning: Default oh-my-posh theme is not found (https://github.com/JanDeDobbeleer/oh-my-posh)"

  fi
fi



# ---------------------------------------------------------------
# -------------------------- Age/Rage ---------------------------
# ---------------------------------------------------------------

if [[ -v _PZC_AGE_PATH ]] && [[ ! -e ${_PZC_AGE_PATH} ]]
then
  echo "Warning: your age is not found. Search other age."
  unset _PZC_AGE_PATH

fi

if [[ ! -v _PZC_AGE_PATH ]]
then

  if [[ -x "$(command -v age)" ]]
  then
    _PZC_AGE_PATH=age

  elif [[ -x "$(command -v rage)" ]]
  then
    _PZC_AGE_PATH=rage

  elif [[ -e ${_PZC_PZC_DIR}/progs/age/age ]]
  then
    _PZC_AGE_PATH=${_PZC_PZC_DIR}/progs/age/age
    
  else
    echo "Warning: age is not installed (https://github.com/FiloSottile/age)"

  fi
fi



# ---------------------------------------------------------------
# --------------------------- EXA-LS ----------------------------
# ---------------------------------------------------------------

if [[ -v _PZC_EXA_PATH ]] && [[ ! -e ${_PZC_EXA_PATH} ]]
then
  echo "Warning: your exa is not found. Search other exa."
  unset _PZC_EXA_PATH

fi

if [[ ! -v _PZC_EXA_PATH ]]
then


  if [[ -x "$(command -v exa)" ]]
  then
    _PZC_EXA_PATH=exa

  elif [[ -e ${_PZC_PZC_DIR}/progs/exa/exa ]]
  then
    _PZC_EXA_PATH=${_PZC_PZC_DIR}/progs/exa/exa
    
  else
    echo "Warning: exa is not installed (https://github.com/ogham/exa)"

  fi
fi



# ---------------------------------------------------------------
# ---------------------------- Mold -----------------------------
# ---------------------------------------------------------------

if [[ -v _PZC_MOLD_PATH ]] && [[ ! -e ${_PZC_MOLD_PATH} ]]
then
  echo "Warning: your mold is not found. Search other mold."
  unset _PZC_MOLD_PATH

fi

if [[ ! -v _PZC_MOLD_PATH ]]
then

  if [[ -x "$(command -v mold)" ]]
  then
    _PZC_MOLD_PATH=mold

  elif [[ -e ${_PZC_PZC_DIR}/progs/mold/mold ]]
  then
    _PZC_MOLD_PATH=${_PZC_PZC_DIR}/progs/mold/mold
    
  else
    echo "Warning: mold is not installed (https://github.com/rui314/mold)"

  fi
fi
