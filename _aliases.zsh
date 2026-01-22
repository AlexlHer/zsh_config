# -*- tab-width: 2; indent-tabs-mode: nil; coding: utf-8 -*-
# ------------------------------------------------------------------------------
# Copyright 2022-2026 Alexandre l'Heritier
# See the top-level LICENSE file for details.
# SPDX-License-Identifier: Apache-2.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# _aliases.zsh
#
# General aliases.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------



# ---------------------------------------------------------------
# ---------------------- LS/EZA aliases -------------------------
# ---------------------------------------------------------------

# File and Dir colors for ls and other outputs
export LS_OPTIONS='--color=auto'
eval "$(dircolors -b)"

## --- With EZA-LS ---
if [[ ${_PZC_EZA_AVAILABLE} = 1 ]]
then
  _pzc_debug "Aliases for EZA-LS."
  alias ls='${PZC_EZA_BIN} --icons'

  alias l='${PZC_EZA_BIN} --icons --color-scale --time-style long-iso --git --group-directories-first -bghHlM'
  alias la='${PZC_EZA_BIN} --icons --color-scale --time-style long-iso --git --group-directories-first -BghHlMa'

  alias ldum='${PZC_EZA_BIN} --icons --color-scale --time-style long-iso --git --total-size --group-directories-first -bghHlM'
  alias ladum='${PZC_EZA_BIN} --icons --color-scale --time-style long-iso --git --total-size --group-directories-first -BghHlMa'

## --- Without EZA-LS ---
else
  _pzc_debug "Aliases for LS (not EZA-LS)."
  alias ls='ls $LS_OPTIONS'

  alias l='ls -l $LS_OPTIONS'
  alias la='ls -la $LS_OPTIONS'

  alias ldum='ls -l $LS_OPTIONS'
  alias ladum='ls -la $LS_OPTIONS'
fi



# ---------------------------------------------------------------
# ----------------------- GREP aliases --------------------------
# ---------------------------------------------------------------

alias grep='grep --color=always'



# ---------------------------------------------------------------
# ------------------------ GIT aliases --------------------------
# ---------------------------------------------------------------

alias g='_pzc_coal "git status" ; git status'
alias gita='_pzc_coal "git add" ; git add'
alias gitc='_pzc_coal "git commit" ; git commit'
alias gitca='_pzc_coal "git commit --amend --no-edit" ; git commit --amend --no-edit'
alias gitco='_pzc_coal "git checkout" ; git checkout'
alias gitp='_pzc_coal "git push" ; git push'
alias gitw='_pzc_coal "git switch -c" ; git switch -c'
alias gitf='_pzc_coal "git fetch origin" ; git fetch origin'
alias gitup='_pzc_coal "git rebase origin/main" ; git rebase origin/main'


alias gitka='_pzc_coal "gitk --all" ; gitk --all'



# ---------------------------------------------------------------
# ----------------------- CP/MV aliases -------------------------
# ---------------------------------------------------------------

alias cpf='_pzc_coal "cp" ; cp'
alias cp='_pzc_coal "cp -i" ; cp -i'

alias mvf='_pzc_coal "mv" ; mv'
alias mv='_pzc_coal "mv -i" ; mv -i'

alias df='_pzc_coal "df -h" ; df -h'
alias free='_pzc_coal "free -m" ; free -m'



# ---------------------------------------------------------------
# ------------------------ CD aliases ---------------------------
# ---------------------------------------------------------------

alias cdb='_pzc_coal_eval "cd ${BUILD_DIR}"'
alias cdi='_pzc_coal_eval "cd ${INSTALL_DIR}"'
alias cdcbi='_pzc_coal_eval "cd ${CONTAINER_LARGE_DIR}"'
alias cdw='_pzc_coal_eval "cd ${WORK_DIR}"'
alias cde='_pzc_coal_eval "cd ${ENVI_DIR}"'



# ---------------------------------------------------------------
# ------------------------ TAR aliases --------------------------
# ---------------------------------------------------------------

alias tarcxz='_pzc_coal "tar -Ipixz -cf" ; tar -Ipixz -cf'
alias tarxxz='_pzc_coal "tar -Ipixz -xf" ; tar -Ipixz -xf'



# ---------------------------------------------------------------
# ------------------------ Task aliases -------------------------
# ---------------------------------------------------------------

if [[ ${_PZC_TASK_AVAILABLE} = 1 ]]
then
  source ${PZC_PZC_DIR}/plugins/taskwarrior/taskwarrior.plugin.zsh
fi



# ---------------------------------------------------------------
# ----------------------- Other aliases -------------------------
# ---------------------------------------------------------------

alias c='clear'
