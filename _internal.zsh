
## --- Internal section ---
## --- Function for _aliases.zsh and _functions.zsh ---



# Note: Eval first param = break autocompletion.
# COlor ALias
_coal()
{
  echo "\033[0;102m\033[30m   ${1} \033[0m"
}

_coal_eval()
{
  echo "\033[0;102m\033[30m   ${1} \033[0m"
  eval ${1}
}

# ECho ALias
_ecal_eval()
{
  echo "${1}"
  eval ${1}
}

_pensil_begin()
{
  echo "\033[0;102m\033[30m   \033[0m"
}

_pensil_end()
{
  echo "\033[0;102m\033[30m   \033[0m"
}

local EXA_AVAILABLE=0
