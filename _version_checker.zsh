# -*- tab-width: 2; indent-tabs-mode: nil; coding: utf-8 -*-
# ------------------------------------------------------------------------------
# Copyright 2022-2026 Alexandre l'Heritier
# See the top-level LICENSE file for details.
# SPDX-License-Identifier: Apache-2.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# _version_checker.zsh
#
# Version checker function.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------



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
