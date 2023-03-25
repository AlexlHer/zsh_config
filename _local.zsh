
## ----- Local part -----



# ---------------------------------------------------------------
# -------------------------- Sources ----------------------------
# ---------------------------------------------------------------

# Source of specific local zsh config
if [[ -v _PZC_PC_ID ]]
then
  if [[ -e ${_PZC_PZC_DIR}/_local_${_PZC_PC_ID}.zsh ]]
  then
    source ${_PZC_PZC_DIR}/_local_${_PZC_PC_ID}.zsh
    _pzc_debug "_local_${_PZC_PC_ID}.zsh found and sourced."

  elif [[ -e ${_PZC_PZC_DIR}/_local_${_PZC_PC_ID}.txt ]]
  then
    if [[ -v _PZC_AGE_PATH ]]
    then
      _pzc_info "Local config decryption in progress..."
      if [[ -v _PZC_SSH_PRI ]]
      then
        ${_PZC_AGE_PATH} -d -i ${_PZC_SSH_PRI} -o ${_PZC_PZC_DIR}/_local_${_PZC_PC_ID}.zsh ${_PZC_PZC_DIR}/_local_${_PZC_PC_ID}.txt
        if [[ -e ${_PZC_PZC_DIR}/_local_${_PZC_PC_ID}.zsh ]]
        then
          source ${_PZC_PZC_DIR}/_local_${_PZC_PC_ID}.zsh
          _pzc_info "_local_${_PZC_PC_ID}.zsh created and sourced."

        else
          _pzc_error "Unknown error, please retry."

        fi
      else
        _pzc_warning "Private SSH key not found, not possible to decrypt local config. Check .zshrc."

      fi
    else
      _pzc_warning "Age not found, not possible to decrypt local config."
      
    fi

  else
    _pzc_warning "_local_${_PZC_PC_ID}.zsh not found."

  fi

else
  _pzc_warning "_PZC_PC_ID is not defined. Check .zshrc."

fi
