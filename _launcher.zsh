
## ----- PZC Launcher -----



# ---------------------------------------------------------------
# ---------------------- Welcome message ------------------------
# ---------------------------------------------------------------

_pzc_welcome()
{
  if [[ -v _PZC_DISABLE_WELCOME ]]
  then
    return 0
  fi

  echo "______ ___________  "
  echo "| ___ |___  /  __ \ "
  echo "| |_/ /  / /| /  \/ "
  echo "|  __/  / / | |     "
  echo "| |   ./ /__| \__/\ "
  echo "\_|   \_____/\____/ "
  echo ""
  echo "Personal ZSH Configuration v${PZC_VERSION[1]}.${PZC_VERSION[2]}.${PZC_VERSION[3]}"
  echo ""

  _pzc_debug "Debug mode activated. Edit your .pzcrc to disable it."

  # f70bb3d582a4067500f28f479a07f7ee523b3984 (08/07/2022) : v1.0.0
  # 24b601f7644e9d5a900546fb06f563a35b4f66b5 (13/01/2023) : v2.0.0
  # 11c94394fd7dcb64badedc4d18d4f6fcc92cc21a (25/02/2023) : v3.0.0
  # 42c86a691019612c2845752743fd075f395ca4fa (25/03/2023) : v4.0.0
  # 54876d68737ca75563032bf0ccdbf736762ffc21 (19/06/2024) : v5.0.0
  # 5875022f9a9559360d771da7a7858c86624b23bc (19/07/2025) : v6.0.0
}



# ---------------------------------------------------------------
# -------------------------- Sources ----------------------------
# ---------------------------------------------------------------

_pzc_sources()
{
  # Source manjaro-zsh-configuration
  source ${PZC_PZC_DIR}/_manjaro_config.zsh

  # Source needed dirs creation
  source ${PZC_PZC_DIR}/_dirs.zsh
  if [[ ${_PZC_FATAL_ERROR} = 1 ]]
  then
    return 0
  fi

  # Source external program needed
  source ${PZC_PZC_DIR}/_external.zsh

  # Source variable export
  source ${PZC_PZC_DIR}/_export.zsh

  # Source perso alias (optional)
  source ${PZC_PZC_DIR}/_aliases.zsh

  # Source perso KDE specific part (optional)
  source ${PZC_PZC_DIR}/_kde.zsh

  # Source perso encrypt/decrypt functions (optional)
  source ${PZC_PZC_DIR}/_enc_functions.zsh

  # Source perso functions (optional)
  source ${PZC_PZC_DIR}/_functions.zsh

  # Source CMake specific functions (optional)
  source ${PZC_PZC_DIR}/_cmake_projects.zsh

  # Source Arcane specific functions (optional)
  source ${PZC_PZC_DIR}/_arcane.zsh

  # Source Podman/Docker specific functions (optional)
  source ${PZC_PZC_DIR}/_podman.zsh

  # Source Python specific functions (optional)
  source ${PZC_PZC_DIR}/_python.zsh

  # Source Completion scripts (optional)
  source ${PZC_PZC_DIR}/completion/_completion.zsh
}



# ---------------------------------------------------------------
# --------------------------- Prompt ----------------------------
# ---------------------------------------------------------------

_pzc_prompt()
{
  if [[ ${_PZC_OMP_AVAILABLE} = 1 ]] && [[ ! -v SIMPLE_TERM ]]
  then
    eval "$(${_PZC_OMP_BIN} init zsh --config ${_PZC_OMP_THEME_FILE})"

  else
    setopt PROMPT_SUBST
    NEWLINE=$'\n'
    #PROMPT="[RET=%?][%*]${NEWLINE}${NEWLINE}[%n][%m]${NEWLINE}[%~]${NEWLINE}> "
    PROMPT="%F{006}[RET=%?]%f%F{006}[%*]%f${NEWLINE}${NEWLINE}%F{001}[%n]%f%F{003}[%m]%f${NEWLINE}%F{002}[%~]%f${NEWLINE}%F{006}>%f "
    #PROMPT="%F{006}[RET=%?]%f%F{014}[%*]%f${NEWLINE}${NEWLINE}%F{009}[%n]%f%F{011}[%m]%f${NEWLINE}%F{010}[%~]%f${NEWLINE}%F{014}>%f "
  fi
}
