
## ----- Python specific section -----



# ---------------------------------------------------------------
# ------------------ Python virtual env init --------------------
# ---------------------------------------------------------------

export PYTHON_ENV=${ENVI_DIR}/python_venv
mkdir -p ${PYTHON_ENV}

_pzc_debug "Set PYTHON_ENV directory = ${PYTHON_ENV}"



# ---------------------------------------------------------------
# ---------------- Python virtual env functions -----------------
# ---------------------------------------------------------------

pyenv()
{
  local NAME="${1:-default}"

  if [[ ! -e ${PYTHON_ENV}/${NAME}/bin/activate ]]
  then
    _pzc_debug "Check file ${PYTHON_ENV}/${NAME}/bin/activate"
    _pzc_error "Python venv '${NAME}' don't exist or is invalid. You can create it with command: 'pyenvnew ${NAME}'."
    return 1
  fi
  _pzc_info "Load python venv '${NAME}'. You can deactivate it with command: 'deactivate'"
  _pzc_coal_eval "source ${PYTHON_ENV}/${NAME}/bin/activate"
}

pyenvnew()
{
  local NAME="${1:-default}"

  if [[ -e ${PYTHON_ENV}/${NAME}/bin/activate ]]
  then
    _pzc_debug "Check file ${PYTHON_ENV}/${NAME}/bin/activate"
    _pzc_error "Python venv '${NAME}' already exist. You can load it with command: 'pyenv ${NAME}' or remove it with command: 'pyenvrem ${NAME}'."
    return 1
  fi

  _pzc_info "Creating python venv '${NAME}'... The command to activate it is: 'pyenv ${NAME}'"
  _pzc_coal_eval "python -m venv ENV_DIR ${PYTHON_ENV}/${NAME}"
}

pyenvrem()
{
  local NAME="${1:-default}"

  if [[ ! -d ${PYTHON_ENV}/${NAME} ]]
  then
    _pzc_debug "Check dir ${PYTHON_ENV}/${NAME}"
    _pzc_error "Python venv '${NAME}' don't exist."
    return 1
  fi

  _pzc_info "Removing python venv '${NAME}'..."
  _pzc_coal_eval "rm -r ${PYTHON_ENV}/${NAME}"
}
