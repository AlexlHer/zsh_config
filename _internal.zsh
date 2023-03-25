
## --- Internal section ---
## --- Function for _aliases.zsh and _functions.zsh ---



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
