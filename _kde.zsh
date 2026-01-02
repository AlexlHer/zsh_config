# -*- tab-width: 2; indent-tabs-mode: nil; coding: utf-8 -*-
# ------------------------------------------------------------------------------
# Copyright 2022-2026 Alexandre l'Heritier
# See the top-level LICENSE file for details.
# SPDX-License-Identifier: Apache-2.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# _kde.zsh
#
# KDE specific aliases.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------



# ---------------------------------------------------------------
# ------------------------ KDE aliases --------------------------
# ---------------------------------------------------------------

alias restartkde='_pzc_coal_eval "killall -s KILL plasmashell"'



# ---------------------------------------------------------------
# ------------------- Pacman/YAY aliases ------------------------
# ---------------------------------------------------------------

alias pa='_pzc_coal "sudo pacman" ; sudo pacman'
alias pas='_pzc_coal "sudo pacman -Sy" ; sudo pacman -Sy'
alias pass='_pzc_coal "sudo pacman -Sys" ; sudo pacman -Sys'
alias paup='_pzc_coal "sudo pacman -Syu" ; sudo pacman -Syu'
alias yup='_pzc_coal_eval "yay -Syua"'
