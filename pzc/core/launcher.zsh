# -*- tab-width: 2; indent-tabs-mode: nil; coding: utf-8 -*-
# ------------------------------------------------------------------------------
# Copyright 2022-2026 Alexandre l'Heritier
# See the top-level LICENSE file for details.
# SPDX-License-Identifier: Apache-2.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# launcher.zsh
#
# Core functions.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------



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

  _pzc_debug "Debug mode activated. Edit your pzcrc to disable it."
}



# ---------------------------------------------------------------
# -------------------------- Sources ----------------------------
# ---------------------------------------------------------------

_pzc_sources()
{
  # Source manjaro-zsh-configuration
  source ${PZC_PZC_DIR}/plugins/manjaro-zsh-config/manjaro-zsh-config

  # Source needed dirs creation
  source ${PZC_PZC_DIR}/pzc/core/dirs.zsh
  if [[ ${_PZC_FATAL_ERROR} = 1 ]]
  then
    return 0
  fi

  # Source Mise-en-place part (optional)
  source ${PZC_PZC_DIR}/pzc/extra/mise.zsh

  # Source Spack part (optional)
  source ${PZC_PZC_DIR}/pzc/extra/spack.zsh

  # Source external program needed
  source ${PZC_PZC_DIR}/pzc/core/external.zsh

  # Source variable export
  source ${PZC_PZC_DIR}/pzc/core/export.zsh

  # Source perso alias (optional)
  source ${PZC_PZC_DIR}/pzc/extra/aliases.zsh

  # Source perso KDE specific part (optional)
  source ${PZC_PZC_DIR}/pzc/extra/kde.zsh

  # Source perso encrypt/decrypt functions (optional)
  source ${PZC_PZC_DIR}/pzc/extra/enc_functions.zsh

  # Source perso functions (optional)
  source ${PZC_PZC_DIR}/pzc/extra/functions.zsh

  # Source internal CMake specific functions (for cmake_projects.zsh et arcane.zsh) (optional)
  source ${PZC_PZC_DIR}/pzc/extra/internal_cmake_projects.zsh

  # Source CMake specific functions (optional)
  source ${PZC_PZC_DIR}/pzc/extra/cmake_projects.zsh

  # Source Arcane specific functions (optional)
  source ${PZC_PZC_DIR}/pzc/extra/arcane.zsh

  # Source Podman/Docker specific functions (optional)
  source ${PZC_PZC_DIR}/pzc/extra/podman.zsh

  # Source Python specific functions (optional)
  source ${PZC_PZC_DIR}/pzc/extra/python.zsh

  # Source Completion scripts (optional)
  source ${PZC_PZC_DIR}/pzc/extra/completion.zsh
}



# ---------------------------------------------------------------
# --------------------------- Prompt ----------------------------
# ---------------------------------------------------------------

_pzc_prompt()
{
  if [[ -v SIMPLE_TERM ]]
  then
    setopt PROMPT_SUBST
    NEWLINE=$'\n'
    #PROMPT="[RET=%?][%*]${NEWLINE}${NEWLINE}[%n][%m]${NEWLINE}[%~]${NEWLINE}> "
    PROMPT="%F{006}[RET=%?]%f%F{006}[%*]%f${NEWLINE}${NEWLINE}%F{001}[%n]%f%F{003}[%m]%f${NEWLINE}%F{002}[%~]%f${NEWLINE}%F{006}>%f "
    #PROMPT="%F{006}[RET=%?]%f%F{014}[%*]%f${NEWLINE}${NEWLINE}%F{009}[%n]%f%F{011}[%m]%f${NEWLINE}%F{010}[%~]%f${NEWLINE}%F{014}>%f "

  elif [[ ${_PZC_OMP_AVAILABLE} = 1 ]]
  then
    eval "$(${_PZC_OMP_BIN} init zsh --config ${_PZC_OMP_THEME_FILE})"

  else
    setopt PROMPT_SUBST
    NEWLINE=$'\n'

    function preexec() {
      timer=${timer:-$SECONDS}
    }

    function precmd() {
      if [ $timer ]; then
        timer_show=$(($SECONDS - $timer))
        TIME_PROMPT="\
%K{038}%F{000}%f%F{000} 󰣐 %? %k%f\
%K{044}%F{038}%f%F{000}  ${timer_show}s %k%f\
%K{050}%F{044}%f%F{000}  %* %k%f\
%K{000}%F{050}%f%k"

        PROMPT="${TIME_PROMPT}\
${NEWLINE}${NEWLINE}\
%K{196}%F{000}%f%F{000}  %n %k%f\
%K{003}%F{196}%f%F{000}  %m %k%f\
%K{000}%F{003}%f%k \
${NEWLINE}\
%K{046}%F{000}%f%F{000}  %~ %k%f\
%K{000}%F{046}%f%k \
${NEWLINE}\
 "
        unset timer
      fi
    }

    function time-prompt-accept-line() {
      OLD_PROMPT="$PROMPT"
      PROMPT="${TIME_PROMPT}${NEWLINE}${NEWLINE} "
      zle reset-prompt
      PROMPT="$OLD_PROMPT"
      zle accept-line
    }

    zle -N time-prompt-accept-line
    bindkey "^M" time-prompt-accept-line

    PROMPT="\
%K{038}%F{000}%f%F{000} 󰣐 %? %k%f\
%K{044}%F{038}%f%F{000}  0s %k%f\
%K{050}%F{044}%f%F{000}  %* %k%f\
%K{000}%F{050}%f%k \
${NEWLINE}${NEWLINE}\
%K{196}%F{000}%f%F{000}  %n %k%f\
%K{003}%F{196}%f%F{000}  %m %k%f\
%K{000}%F{003}%f%k \
${NEWLINE}\
%K{046}%F{000}%f%F{000}  %~ %k%f\
%K{000}%F{046}%f%k \
${NEWLINE}\
 "

  fi

  if [[ ! -v SIMPLE_TERM ]]
  then
    if [[ ${_PZC_FZF_AVAILABLE} = 1 ]]
    then
      source <(fzf --zsh)
    fi

    if [[ ${_PZC_ATUIN_AVAILABLE} = 1 ]]
    then
      eval "$(${PZC_ATUIN_BIN} init zsh)"
    fi
  fi
}
