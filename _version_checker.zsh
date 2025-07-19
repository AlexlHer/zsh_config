
# ---------------------------------------------------------------
# ----------------------- .zshrc Checker ------------------------
# ---------------------------------------------------------------

# 0 = $1 = $2  /  1 = $1 < $2  /  2 = $1 > $2
_pzc_version_checker()
{
  if [[ "${=1}" -lt "${=4}" ]]
  then
    _PZC_VERSION_CHECKER_RET=1
    return 0
  elif [[ "${=1}" -gt "${=4}" ]]
  then
    _PZC_VERSION_CHECKER_RET=2
    return 0
  else

    if [[ "${=2}" -lt "${=5}" ]]
    then
      _PZC_VERSION_CHECKER_RET=1
      return 0
    elif [[ "${=2}" -gt "${=5}" ]]
    then
      _PZC_VERSION_CHECKER_RET=2
      return 0
    else

      if [[ "${=3}" -lt "${=6}" ]]
      then
      _PZC_VERSION_CHECKER_RET=1
        return 0
      elif [[ "${=3}" -gt "${=6}" ]]
      then
      _PZC_VERSION_CHECKER_RET=2
        return 0
      else

        _PZC_VERSION_CHECKER_RET=0
        return 0

      fi

    fi

  fi
}

# _pzc_version_check()
# {
#   _pzc_version_checker ${_PZC_CONFIG_VERSION} ${_PZC_CONFIG_VERSION_NEEDED}

#   if [[ ${_PZC_VERSION_CHECKER_RET} = 1 ]]
#   then
#     echo "\033[0;101m\033[30m   Error: Your .zshrc is too old for PZC. Please update it to use PZC. \033[0m"
#     echo "\033[0;101m\033[30m             Your .zshrc version: v${_PZC_CONFIG_VERSION[1]}.${_PZC_CONFIG_VERSION[2]}.${_PZC_CONFIG_VERSION[3]} \033[0m"
#     echo "\033[0;101m\033[30m             Needed version:      v${_PZC_CONFIG_VERSION_NEEDED[1]}.${_PZC_CONFIG_VERSION_NEEDED[2]}.${_PZC_CONFIG_VERSION_NEEDED[3]} \033[0m"
#     _PZC_FATAL_ERROR=1
#   else

#     _pzc_version_checker ${_PZC_CONFIG_VERSION} ${_PZC_CONFIG_LAST_VERSION}

#     if [[ ${_PZC_VERSION_CHECKER_RET} = 2 ]]
#     then
#       echo "\033[0;101m\033[30m   Error: PZC is too old to read your .zshrc. Please update PZC (git pull). \033[0m"
#       echo "\033[0;101m\033[30m             Your .zshrc version:                     v${_PZC_CONFIG_VERSION[1]}.${_PZC_CONFIG_VERSION[2]}.${_PZC_CONFIG_VERSION[3]} \033[0m"
#       echo "\033[0;101m\033[30m             Latest version supported by PZC v${PZC_VERSION[1]}.${PZC_VERSION[2]}.${PZC_VERSION[3]}: v${_PZC_CONFIG_VERSION_NEEDED[1]}.${_PZC_CONFIG_VERSION_NEEDED[2]}.${_PZC_CONFIG_VERSION_NEEDED[3]} \033[0m"
#       _PZC_FATAL_ERROR=1

#     elif [[ ${_PZC_VERSION_CHECKER_RET} = 1 ]]
#     then
#         echo "\033[0;103m\033[30m   Warning: Your .zshrc file is not up to date (${HOME}/.zshrc). \
#   Please update it with the newest (template available here: ${PZC_PZC_DIR}/home.zshrc). \033[0m"
#         echo "\033[0;103m\033[30m             Your .zshrc version: v${_PZC_CONFIG_VERSION[1]}.${_PZC_CONFIG_VERSION[2]}.${_PZC_CONFIG_VERSION[3]} \033[0m"
#         echo "\033[0;103m\033[30m             Latest version:      v${_PZC_CONFIG_LAST_VERSION[1]}.${_PZC_CONFIG_LAST_VERSION[2]}.${_PZC_CONFIG_LAST_VERSION[3]} \033[0m"

#     else
#     _pzc_debug ".zshrc Checker OK"

#     fi

#   fi

#   unset _PZC_VERSION_CHECKER_RET
# }
