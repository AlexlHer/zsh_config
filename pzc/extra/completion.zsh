# -*- tab-width: 2; indent-tabs-mode: nil; coding: utf-8 -*-
# ------------------------------------------------------------------------------
# Copyright 2022-2026 Alexandre l'Heritier
# See the top-level LICENSE file for details.
# SPDX-License-Identifier: Apache-2.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# completion.zsh
#
# Main completion section.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------



if [[ ${_PZC_OMP_AVAILABLE} = 1 ]]
then
  source ${PZC_PZC_DIR}/plugins/oh-my-posh/oh-my-posh.zsh
fi



if [[ ${_PZC_TASK_AVAILABLE} = 1 ]]
then
  source ${PZC_PZC_DIR}/plugins/taskwarrior/taskwarrior.plugin.zsh
fi
