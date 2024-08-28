
## --- Internal section ---


# ---------------------------------------------------------------
# ----------------------- Echo functions ------------------------
# ---------------------------------------------------------------

# Note: Eval first param = break autocompletion.
# COlor ALias
_pzc_coal()
{
  echo "\033[0;102m\033[30m   ${1} \033[0m"
}

_pzc_coal_eval()
{
  echo "\033[0;102m\033[30m   ${1} \033[0m"
  eval ${1}
}

# ECho ALias
_pzc_ecal_eval()
{
  echo "${1}"
  eval ${1}
}

_pzc_pensil_begin()
{
  echo "\033[0;102m\033[30m   \033[0m"
}

_pzc_pensil_end()
{
  echo "\033[0;102m\033[30m   \033[0m"
}


_pzc_info()
{
  if [[ ${_PZC_LOG_INFO} = 1 ]]
  then
    if [[ ${_PZC_LOG_DEBUG} = 1 ]]
    then
      echo "\033[0;102m\033[30m   Info: [${funcfiletrace[1]##*/}] ${1} \033[0m"
    else
      echo "\033[0;102m\033[30m   Info: ${1} \033[0m"
    fi
  fi
}

_pzc_warning()
{
  if [[ ${_PZC_LOG_WARNING} = 1 ]]
  then
    if [[ ${_PZC_LOG_DEBUG} = 1 ]]
    then
      echo "\033[0;103m\033[30m   Warning: [${funcfiletrace[1]##*/}] ${1} \033[0m"
    else
      echo "\033[0;103m\033[30m   Warning: ${1} \033[0m"
    fi
  fi
}

_pzc_error()
{
  if [[ ${_PZC_LOG_ERROR} = 1 ]]
  then
    if [[ ${_PZC_LOG_DEBUG} = 1 ]]
    then
      echo "\033[0;101m\033[30m   Error: [${funcfiletrace[1]##*/}] ${1} \033[0m"
    else
      echo "\033[0;101m\033[30m   Error: ${1} \033[0m"
    fi
  fi
}

_pzc_debug()
{
  if [[ ${_PZC_LOG_DEBUG} = 1 ]]
  then
    echo "\033[0;104m\033[30m   Debug: [${funcfiletrace[1]##*/}] ${1} \033[0m"
  fi
}

_pzc_debug_eval()
{
  if [[ ${_PZC_LOG_DEBUG} = 1 ]]
  then
    echo "\033[0;104m\033[30m   Debug Eval: [${funcfiletrace[1]##*/}] \033[0m"
    echo "\033[0;104m\033[30m   \uE285 ${1} \033[0m"
    eval ${1}
  fi
}



# ---------------------------------------------------------------
# ---------------------- Welcome message ------------------------
# ---------------------------------------------------------------

echo "______ ___________  "
echo "| ___ |___  /  __ \ "
echo "| |_/ /  / /| /  \/ "
echo "|  __/  / / | |     "
echo "| |   ./ /__| \__/\ "
echo "\_|   \_____/\____/ "
echo ""
echo "Personal ZSH Configuration v${_PZC_VERSION[1]}.${_PZC_VERSION[2]}.${_PZC_VERSION[3]}"
echo ""

_pzc_debug "Debug mode activated. Edit your .zshrc to disable it."

# f70bb3d582a4067500f28f479a07f7ee523b3984 (08/07/2022) : v1.0.0
# 24b601f7644e9d5a900546fb06f563a35b4f66b5 (13/01/2023) : v2.0.0
# 11c94394fd7dcb64badedc4d18d4f6fcc92cc21a (25/02/2023) : v3.0.0
# 42c86a691019612c2845752743fd075f395ca4fa (25/03/2023) : v4.0.0
# 54876d68737ca75563032bf0ccdbf736762ffc21 (19/06/2024) : v5.0.0



# ---------------------------------------------------------------
# ----------------------- .zshrc Checker ------------------------
# ---------------------------------------------------------------

if [[ ! ${_PZC_CONFIG_VERSION[1]} = ${_PZC_CONFIG_VERSION_NEEDED[1]} ]] \
|| [[ ! ${_PZC_CONFIG_VERSION[2]} = ${_PZC_CONFIG_VERSION_NEEDED[2]} ]] \
|| [[ ! ${_PZC_CONFIG_VERSION[3]} = ${_PZC_CONFIG_VERSION_NEEDED[3]} ]]
then
  echo "\033[0;103m\033[30m   Warning: Your .zshrc file is not up to date (${HOME}/.zshrc). \
Please update it with the newest (template available here: ${_PZC_PZC_DIR}/home.zshrc). \033[0m"
  echo "\033[0;103m\033[30m             Your .zshrc version: v${_PZC_CONFIG_VERSION[1]}.${_PZC_CONFIG_VERSION[2]}.${_PZC_CONFIG_VERSION[3]} \033[0m"
  echo "\033[0;103m\033[30m             Needed version:      v${_PZC_CONFIG_VERSION_NEEDED[1]}.${_PZC_CONFIG_VERSION_NEEDED[2]}.${_PZC_CONFIG_VERSION_NEEDED[3]} \033[0m"

else
  _pzc_debug ".zshrc Checker OK"
fi
