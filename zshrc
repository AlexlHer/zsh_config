# -*- tab-width: 2; indent-tabs-mode: nil; coding: utf-8 -*-
# ------------------------------------------------------------------------------
# Copyright 2022-2026 Alexandre l'Heritier
# See the top-level LICENSE file for details.
# SPDX-License-Identifier: Apache-2.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# zshrc
#
# Compatibility file for PZC v5 or lower.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------



## ----- Old main zshrc -----
# For PZC before v6 compatibility.
# TODO : Delete this file in PZC v7.


echo "---------------------------"
echo "--- Major update of PZC ---"
echo "---------------------------"
echo "You are coming from PZC version 5 or lower."
echo "You have updated PZC to version 6+."
echo "This version has a different configuration file architecture and your configuration files need to be updated."
echo "If you have been defined a PATH modification or other things in your .zshrc, you must add this in the new .zshrc."
echo "---------------------------"

echo "A copy of your old .zshrc is available here : ${HOME}/.zshrc.old"

cp ${HOME}/.zshrc ${HOME}/.zshrc.old

mv ${HOME}/.zshrc ${HOME}/.pzcrc
sed -i 's/source/#source/g' ${HOME}/.pzcrc

if [[ ! -v _PZC_CONFIG_VERSION ]]
then
  if [[ ! -v _PZC_PZC_DIR ]]
  then
    echo "Your .zshrc is too old (from PZC v3 or before) and the variable _PZC_PZC_DIR is not available. Trying older variable ZSH_DIR..."
    if [[ ! -v ZSH_DIR ]]
    then
      echo "Your .zshrc is too old (from PZC v1). Set the _PZC_PZC_DIR variable to PZC v1 value (${HOME}/.zsh)"
      _PZC_PZC_DIR=${HOME}/.zsh
    else
      echo "ZSH_DIR found. Use it as value of _PZC_PZC_DIR"
      _PZC_PZC_DIR=${ZSH_DIR}
    fi
  fi
  echo "Your .zshrc file come from PZC v5.16.0 or before. It will be updated, but you need to check that all your options have been copied correctly."
  echo "local _PZC_CONFIG_VERSION=(5 99 99)" >> ${HOME}/.pzcrc
fi

cp ${_PZC_PZC_DIR}/template.zshrc ${HOME}/.zshrc
sed -i "s:PZC_PZC_DIR=\${HOME}/.pzc:PZC_PZC_DIR=\"${_PZC_PZC_DIR}\":g" ${HOME}/.zshrc

echo "Your old configuration file will be updated."

echo "---------------------------"
echo "First step of the update is done. Restarting zsh..."
read -s -k $'?Press any key to continue.\n'
exec zsh
