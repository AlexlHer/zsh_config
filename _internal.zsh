
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
  if [[ ${PZC_LOG_INFO} = 1 ]]
  then
    if [[ ${PZC_LOG_DEBUG} = 1 ]]
    then
      echo "\033[0;102m\033[30m   Info: [${funcfiletrace[1]##*/}] ${1} \033[0m"
    else
      echo "\033[0;102m\033[30m   Info: ${1} \033[0m"
    fi
  fi
}

_pzc_warning()
{
  if [[ ${PZC_LOG_WARNING} = 1 ]]
  then
    if [[ ${PZC_LOG_DEBUG} = 1 ]]
    then
      echo "\033[0;103m\033[30m   Warning: [${funcfiletrace[1]##*/}] ${1} \033[0m"
    else
      echo "\033[0;103m\033[30m   Warning: ${1} \033[0m"
    fi
  fi
}

_pzc_error()
{
  if [[ ${PZC_LOG_ERROR} = 1 ]]
  then
    if [[ ${PZC_LOG_DEBUG} = 1 ]]
    then
      echo "\033[0;101m\033[30m   Error: [${funcfiletrace[1]##*/}] ${1} \033[0m"
    else
      echo "\033[0;101m\033[30m   Error: ${1} \033[0m"
    fi
  fi
}

_pzc_debug()
{
  if [[ ${PZC_LOG_DEBUG} = 1 ]]
  then
    echo "\033[0;104m\033[30m   Debug: [${funcfiletrace[1]##*/}] ${1} \033[0m"
  fi
}

_pzc_debug_eval()
{
  if [[ ${PZC_LOG_DEBUG} = 1 ]]
  then
    echo "\033[0;104m\033[30m   Debug Eval: [${funcfiletrace[1]##*/}] \033[0m"
    echo "\033[0;104m\033[30m   \uE285 ${1} \033[0m"
    eval ${1}
  fi
}
