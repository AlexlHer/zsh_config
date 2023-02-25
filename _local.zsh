
## ----- Local part -----



# ---------------------------------------------------------------
# -------------------------- Sources ----------------------------
# ---------------------------------------------------------------

# Source of specific local zsh config
if [[ -v PC_ID ]]
then
  if [[ -e ${ZSH_DIR}/_local_${PC_ID}.zsh ]]
  then
    source ${ZSH_DIR}/_local_${PC_ID}.zsh

  elif [[ -e ${ZSH_DIR}/_local_${PC_ID}.txt ]]
  then
    echo "Local config decryption in progress..."
    if [[ -x "$(command -v age)" ]]
    then
      if [[ -v SSH_PRI ]]
      then
        age -d -i ${SSH_PRI} -o ${ZSH_DIR}/_local_${PC_ID}.zsh ${ZSH_DIR}/_local_${PC_ID}.txt
        if [[ -e ${ZSH_DIR}/_local_${PC_ID}.zsh ]]
        then
          source ${ZSH_DIR}/_local_${PC_ID}.zsh
          echo "_local_${PC_ID}.zsh created and sourced."

        else
          echo "Unknown error, please retry."

        fi
      else
        echo "Private SSH key not found, not possible to decrypt local config. Check .zshrc."

      fi
    else
      echo "Age not found, not possible to decrypt local config."
      
    fi

  else
    echo "Warning: _local_${PC_ID}.zsh not found."

  fi

else
  echo "Warning: PC_ID is not defined. Check .zshrc."

fi
