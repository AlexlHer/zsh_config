
## --- Functions section ---



# ---------------------------------------------------------------
# -------------------- EXA-LS/LS Functions ----------------------
# ---------------------------------------------------------------

# If EXA-LS is installed.
if [[ $EXA_AVAILABLE = 1 ]]
then
  # Color $1 or 3 last edited files.
  ll()
  {
    local DEPTH="${1:-1}"
    _coal_eval 'l -TL "${DEPTH}"'
  }

  # Color $1 or 3 last edited files.
  lll()
  {
    local NUM_FILES="${1:-3}"
    grep --color=always -E -- "$(l -snew | tail -n${NUM_FILES})|$" <(l)
  }

  # Color $1 or 3 last edited files (cache edition).
  lla()
  {
    local NUM_FILES="${1:-3}"
    grep --color=always -E -- "$(la -snew | tail -n${NUM_FILES})|$" <(la)
  }

else
  # Color $1 or 3 last edited files.
  lll()
  {
    local NUM_FILES="${1:-3}"
    grep --color=always -E -- "$(l -rt | tail -n${NUM_FILES})|$" <(l)
  }

  # Color $1 or 3 last edited files (cache edition).
  lla()
  {
    local NUM_FILES="${1:-3}"
    grep --color=always -E -- "$(la -rt | tail -n${NUM_FILES})|$" <(la)
  }

fi



# ---------------------------------------------------------------
# ---------------------- Short Functions ------------------------
# ---------------------------------------------------------------

# Size of folders/files with custom depth.
dum()
{
  local DEPTH="${1:-0}"
  local CMDD=`du -ahc --time --max-depth=${DEPTH}`
  grep --color=always -E -- '$(echo "${CMDD}" | tail -n1)|$' <(echo "${CMDD}" | sort -h)
}

# "Find" alias with symlinks follow.
dinf()
{
  _coal 'find -L . -name "${1}" 2> /dev/null'
  find -L . -name "${1}" 2> /dev/null
}



# ---------------------------------------------------------------
# ---------------------- Export Functions -----------------------
# ---------------------------------------------------------------

# Define "CLang" to CMake default compiler.
uclang()
{
  _coal_eval "export CC=clang"
  _coal_eval "export CXX=clang++"
  if [[ -x "$(command -v mold)" ]]
  then
  _coal_eval "export CFLAGS='-fuse-ld=mold'"
  _coal_eval "export CXXFLAGS='-fuse-ld=mold'"
  fi
}

# Define "GCC" to CMake default compiler.
ugcc()
{
  _coal_eval "export CC=gcc"
  _coal_eval "export CXX=g++"
  if [[ -x "$(command -v mold)" ]]
  then
  _coal_eval "export CFLAGS='-fuse-ld=mold'"
  _coal_eval "export CXXFLAGS='-fuse-ld=mold'"
  fi
}



# ---------------------------------------------------------------
# ---------------------- CTest Functions ------------------------
# ---------------------------------------------------------------

cti()
{
  local ARG1="${1:-0}"
  local ARG2="${2:-${ARG1}}"
  _coal_eval "ctest -I ${ARG1},${ARG2},1 --output-on-failure ${*:3}"
}

ctr()
{
  local ARG1="${1:-0}"
  _coal_eval "ctest -R \"${ARG1}\" --output-on-failure ${*:2}"
}

ctnr()
{
  local ARG1="${1:-0}"
  _coal_eval "ctest -N -R \"${ARG1}\" ${*:2}"
}

cta()
{
  local ARG1="${1:-1}"
  _coal_eval "ctest -j${ARG1} --repeat until-pass:3 --output-on-failure ${*:2}"
}
