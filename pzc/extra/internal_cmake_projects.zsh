# -*- tab-width: 2; indent-tabs-mode: nil; coding: utf-8 -*-
# ------------------------------------------------------------------------------
# Copyright 2022-2026 Alexandre l'Heritier
# See the top-level LICENSE file for details.
# SPDX-License-Identifier: Apache-2.0
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# internal_cmake_projects.zsh
#
# Internal functions to configure CMake projects and Arcane.
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------



# ---------------------------------------------------------------
# --------------- Create folder for init scripts ----------------
# ---------------------------------------------------------------

export PZC_EDIT_SCRIPTS=${PZC_USER_CONFIG_DIR}/cmake_scripts
mkdir -p ${PZC_EDIT_SCRIPTS}



# ---------------------------------------------------------------
# ------------------ Generate preset functions ------------------
# ---------------------------------------------------------------

#! \brief Fonction permettant de générer un preset final "generated_".
#!
#! \param 1 Le fichier à configurer.
#! \param 2 Le fichier généré.
#! \return 0 Ok.
#! \return 11 Le fichier d'entrée n'est pas spécifié ou n'existe pas.
#! \return 12 Le fichier de sortie n'est pas spécifié.
function _pzc_common_configure_preset()
{
  if [[ -v 1 ]] && [[ -e "${1}" ]]
  then
    local PZC_TO_CONFIG=${1}
  else
    return 11
  fi

  if [[ -v 2 ]]
  then
    local PZC_TARGET=${2}
  else
    return 12
  fi

  local ARCANE_BUILD_TYPE=""
  local ARCANE_ACCELERATOR_MODE="null"
  local ARCANE_CXX_SYCL_FLAGS="null"
  local _PZC_CMAKE_PREFIX_PATH=""
  local CMAKE_CUDA_COMPILER="null"
  local CMAKE_CUDA_FLAGS="null"
  local CMAKE_CUDA_ARCHITECTURES="null"
  local CMAKE_SYCL_COMPILER="null"

  if [[ ${PZC_GPU_AVAILABLE} = 1 ]]
  then

    if [[ "${PZC_GPU_DEFAULT_COMPILER}" == "NVCC" ]]
    then
      ARCANE_ACCELERATOR_MODE="CUDA"
      CMAKE_CUDA_COMPILER="${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        CMAKE_CUDA_FLAGS="${PZC_GPU_FLAGS}"
      fi
      if [[ -v PZC_GPU_TARGET_ARCH ]]
      then
        CMAKE_CUDA_ARCHITECTURES="${PZC_GPU_TARGET_ARCH}"
      fi

    else
      ARCANE_ACCELERATOR_MODE="SYCL"
      CMAKE_SYCL_COMPILER="${PZC_GPU_COMPILER}"
      if [[ -v PZC_GPU_FLAGS ]]
      then
        ARCANE_CXX_SYCL_FLAGS="${PZC_GPU_FLAGS}"
      fi
    fi
  fi

  if [[ ${CMP_BUILD_TYPE} == "debug" ]]
  then
    ARCANE_BUILD_TYPE="Debug"
  elif [[ ${CMP_BUILD_TYPE} == "check" ]]
  then
    ARCANE_BUILD_TYPE="Check"
  elif [[ ${CMP_BUILD_TYPE} == "release" ]]
  then
    ARCANE_BUILD_TYPE="Release"
  else
    _pzc_debug "Bad CMP_BUILD_TYPE"
    return 2
  fi

  sed \
    -e "s|@CMP_PROJECT_NAME@|${CMP_PROJECT_NAME}|g" \
    -e "s|@CMP_SOURCE_DIR@|${CMP_SOURCE_DIR}|g" \
    -e "s|@CMP_BUILD_DIR@|${CMP_BUILD_DIR}|g" \
    -e "s|@CMP_INSTALL_DIR@|${CMP_INSTALL_DIR}|g" \
    -e "s|@CMP_DIR_BUILD_TYPE@|${TYPE_BUILD_DIR}|g" \
    -e "s|@CMP_BUILD_TYPE@|${CMP_BUILD_TYPE}|g" \
    -e "s|@CMP_VARIANT@|${CMP_VARIANT}|g" \
    -e "s|@CMP_CMAKE_BUILD_TYPE@|${PZC_CMAKE_BUILD_TYPE}|g" \
    -e "s|@CMP_CMAKE_GENERATOR@|${PZC_CMAKE_GENERATOR}|g" \
    -e "s|@CMP_CMAKE_C_CXX_COMPILER_LAUNCHER@|${PZC_CMAKE_C_COMPILER_LAUNCHER}|g" \
    -e "s|@CMP_CMAKE_LINKER_TYPE@|${PZC_CMAKE_LINKER_TYPE}|g" \
    -e "s|@CMP_CMAKE_C_COMPILER@|${PZC_C_COMPILER}|g" \
    -e "s|@CMP_CMAKE_CXX_COMPILER@|${PZC_CXX_COMPILER}|g" \
    -e "s|@CMP_GPU_HOST_COMPILER@|${PZC_GPU_HOST_COMPILER}|g" \
    -e "s|@CMP_CMAKE_CUDA_COMPILER@|${CMAKE_CUDA_COMPILER}|g" \
    -e "s|@CMP_CMAKE_CUDA_FLAGS@|${CMAKE_CUDA_FLAGS}|g" \
    -e "s|@CMP_CMAKE_CUDA_ARCHITECTURES@|${CMAKE_CUDA_ARCHITECTURES}|g" \
    -e "s|@CMP_CMAKE_SYCL_COMPILER@|${CMAKE_SYCL_COMPILER}|g" \
    -e "s|@CMP_CMAKE_PREFIX_PATH@|${_PZC_CMAKE_PREFIX_PATH}|g" \
    -e "s|@CMP_ARCANE_BUILD_TYPE@|${ARCANE_BUILD_TYPE}|g" \
    -e "s|@CMP_ARCANE_CXX_SYCL_FLAGS@|${ARCANE_CXX_SYCL_FLAGS}|g" \
    -e "s|@CMP_ARCANE_ACCELERATOR_MODE@|${ARCANE_ACCELERATOR_MODE}|g" \
    \
    "${1}" > "${2}"

  # Comme les guillemets sont dans le template, on doit faire le remplacement des null dans un second temps.
  sed -i 's|"null"|null|g' "${2}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

#! \brief Fonction permettant de générer le preset par defaut "generated_default_" et le preset
#!        utilisateur "user_" (1/2).
#!
#! \return 0 Ok
#! \return 10 Projet non initialisé.
function _pzc_common_pcmp()
{
  if [[ ! -v CMP_SOURCE_DIR ]]
  then
    return 10
  fi

  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    return 10
  fi

  local _PZC_SAVED_USER_PRESET_GENERIC_GENERIC_PATH="${PZC_EDIT_SCRIPTS}/user_${CMP_PROJECT_NAME}.json"
  local _PZC_SAVED_USER_PRESET_GENERIC_PATH="${PZC_EDIT_SCRIPTS}/user_${CMP_PROJECT_NAME}_${CMP_VARIANT}.json"
  local _PZC_SAVED_USER_PRESET_PATH="${PZC_EDIT_SCRIPTS}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_PRESET_PATH="${CMP_BUILD_DIR}/generated_default_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  _pzc_info "Creation of default configuration preset in build dir (${_PZC_TMP_PRESET_PATH})..."

  local _PZC_TEMPLATE_PRESET_PATH="${PZC_PZC_DIR}/progs/cmake/preset_templates/${CMP_PROJECT}/config.json.in"

  # Si le preset config n'existe pas, on n'en a pas besoin, on prend le generic.
  if [[ ! -e "${_PZC_TEMPLATE_PRESET_PATH}" ]]
  then
    _PZC_TEMPLATE_PRESET_PATH="${PZC_PZC_DIR}/progs/cmake/preset_templates/generic/config.json.in"
  fi

  _pzc_common_configure_preset "${_PZC_TEMPLATE_PRESET_PATH}" "${_PZC_TMP_PRESET_PATH}"
  local RET_CODE=$?
  if [[ ${RET_CODE} != 0 ]]
  then
    _pzc_debug "Error _pzc_common_configure_preset"
    return ${RET_CODE}
  fi

  if [[ -e "${_PZC_TMP_USER_PRESET_PATH}" ]]
  then
    _pzc_info "Configuration user preset found (${_PZC_TMP_USER_PRESET_PATH})."
    return 0
  fi

  if [[ -e "${_PZC_SAVED_USER_PRESET_PATH}" ]]
  then
    _pzc_info "Copying saved configuration user preset in build dir (${_PZC_SAVED_USER_PRESET_PATH})..."
    cp "${_PZC_SAVED_USER_PRESET_PATH}" "${_PZC_TMP_USER_PRESET_PATH}"
    return 0
  fi

  if [[ -e "${_PZC_SAVED_USER_PRESET_GENERIC_PATH}" ]]
  then
    _pzc_info "Copying saved general configuration user preset in build dir (${_PZC_SAVED_USER_PRESET_GENERIC_PATH})..."
    cp "${_PZC_SAVED_USER_PRESET_GENERIC_PATH}" "${_PZC_TMP_USER_PRESET_PATH}"
    return 0
  fi

  if [[ -e "${_PZC_SAVED_USER_PRESET_GENERIC_GENERIC_PATH}" ]]
  then
    _pzc_info "Copying saved general general configuration user preset in build dir (${_PZC_SAVED_USER_PRESET_GENERIC_GENERIC_PATH})..."
    cp "${_PZC_SAVED_USER_PRESET_GENERIC_GENERIC_PATH}" "${_PZC_TMP_USER_PRESET_PATH}"
    return 0
  fi

  _pzc_info "Creation of configuration user preset in build dir (${_PZC_TMP_USER_PRESET_PATH})..."

  local _PZC_EMPTY_TEMPLATE_PRESET_PATH="${PZC_PZC_DIR}/progs/cmake/preset_templates/empty.json.in"

  sed \
    -e "s|@PZC_CMP_SOURCE_DIR@|${CMP_SOURCE_DIR}|g" \
    -e "s|@PZC_CMP_BUILD_DIR@|${CMP_BUILD_DIR}|g" \
    -e "s|@PZC_CMP_INSTALL_DIR@|${CMP_INSTALL_DIR}|g" \
    -e "s|@PZC_CMP_OTHER_VAR@||g" \
    \
    "${_PZC_EMPTY_TEMPLATE_PRESET_PATH}" > "${_PZC_TMP_USER_PRESET_PATH}"

  if [[ ${CMP_PROJECT_TYPE} = 3 ]]
  then
    _pzc_common_depcmp framework @ @CMP_VARIANT@ 1
    return $?
  fi
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

#! \brief Fonction permettant de générer le preset generated_user_ à partir du preset user_.
#!
#! \return 0 Ok
#! \return 10 Projet non initialisé.
#! \return 16 Preset d'installation d'une dep non trouvé
function _pzc_common_generate_user_preset()
{
  if [[ ! -v CMP_SOURCE_DIR ]]
  then
    return 10
  fi

  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    return 10
  fi

  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_GEN_USER_PRESET_PATH="${CMP_BUILD_DIR}/generated_user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  _pzc_info "Generation of final configuration user preset in build dir (${_PZC_TMP_GEN_USER_PRESET_PATH})..."
  _pzc_common_configure_preset "${_PZC_TMP_USER_PRESET_PATH}" "${_PZC_TMP_GEN_USER_PRESET_PATH}"
  local RET_CODE=$?
  if [[ ${RET_CODE} != 0 ]]
  then
    _pzc_debug "Error _pzc_common_configure_preset"
    return ${RET_CODE}
  fi

  jq -r '.vendor.pzc.cmpDependencies[] | @tsv' "${_PZC_TMP_GEN_USER_PRESET_PATH}" | while read -r var1 var2 var3
  do
    _pzc_info "Add dependency -- Name : ${var1} -- Type : ${var2} -- Variant : ${var3}"

    local _PZC_TYPE_BUILD_DIR="${var2}"
    if [[ ${var3} != "_" ]]
    then
      _PZC_TYPE_BUILD_DIR=${_PZC_TYPE_BUILD_DIR}_${var3}
    fi

    local _PZC_INSTALL_PRESET="${INSTALL_DIR}/install_${var1}/${_PZC_TYPE_BUILD_DIR}/generated_install_${var1}_${_PZC_TYPE_BUILD_DIR}.json"
    if [[ ! -e "${_PZC_INSTALL_PRESET}" ]]
    then
      _pzc_warning "Dependency install preset not found. Check dependency install dir or execute 'bidep' command (${_PZC_INSTALL_PRESET})."
    fi

    jq \
      ".include += [\"${_PZC_INSTALL_PRESET}\"]" \
      "${_PZC_TMP_GEN_USER_PRESET_PATH}" > "${_PZC_TMP_GEN_USER_PRESET_PATH}.tmp"
    \mv "${_PZC_TMP_GEN_USER_PRESET_PATH}.tmp" "${_PZC_TMP_GEN_USER_PRESET_PATH}"

    jq \
      ".configurePresets[].inherits += [\"${var1}_${var2}_${var3}\"]" \
      "${_PZC_TMP_GEN_USER_PRESET_PATH}" > "${_PZC_TMP_GEN_USER_PRESET_PATH}.tmp"
    \mv "${_PZC_TMP_GEN_USER_PRESET_PATH}.tmp" "${_PZC_TMP_GEN_USER_PRESET_PATH}"

  done
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

#! \brief Fonction permettant de générer le preset d'installation utilisateur "install_" (1/2).
#!
#! \return 0 Ok.
#! \return 10 Projet non initialisé.
function _pzc_common_ipcmp()
{
  if [[ ! -v CMP_SOURCE_DIR ]]
  then
    return 10
  fi

  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    return 10
  fi

  local _PZC_SAVED_INSTALL_PRESET_GENERIC_GENERIC_PATH="${PZC_EDIT_SCRIPTS}/install_${CMP_PROJECT_NAME}.json"
  local _PZC_SAVED_INSTALL_PRESET_GENERIC_PATH="${PZC_EDIT_SCRIPTS}/install_${CMP_PROJECT_NAME}_${CMP_VARIANT}.json"
  local _PZC_SAVED_INSTALL_PRESET_PATH="${PZC_EDIT_SCRIPTS}/install_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  local _PZC_TMP_INSTALL_PRESET_PATH="${CMP_BUILD_DIR}/install_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"


  if [[ -e "${_PZC_TMP_INSTALL_PRESET_PATH}" ]]
  then
    _pzc_info "Installation user preset found (${_PZC_TMP_INSTALL_PRESET_PATH})."
    return 0
  fi

  if [[ -e "${_PZC_SAVED_INSTALL_PRESET_PATH}" ]]
  then
    _pzc_info "Copying saved installation user preset in build dir (${_PZC_SAVED_INSTALL_PRESET_PATH})..."
    cp "${_PZC_SAVED_INSTALL_PRESET_PATH}" "${_PZC_TMP_INSTALL_PRESET_PATH}"
    return 0
  fi

  if [[ -e "${_PZC_SAVED_INSTALL_PRESET_GENERIC_PATH}" ]]
  then
    _pzc_info "Copying saved general installation user preset in build dir (${_PZC_SAVED_INSTALL_PRESET_GENERIC_PATH})..."
    cp "${_PZC_SAVED_INSTALL_PRESET_GENERIC_PATH}" "${_PZC_TMP_INSTALL_PRESET_PATH}"
    return 0
  fi

  if [[ -e "${_PZC_SAVED_INSTALL_PRESET_GENERIC_GENERIC_PATH}" ]]
  then
    _pzc_info "Copying saved general general installation user preset in build dir (${_PZC_SAVED_INSTALL_PRESET_GENERIC_GENERIC_PATH})..."
    cp "${_PZC_SAVED_INSTALL_PRESET_GENERIC_GENERIC_PATH}" "${_PZC_TMP_INSTALL_PRESET_PATH}"
    return 0
  fi

  _pzc_info "Creation of installation user preset in build dir (${_PZC_TMP_INSTALL_PRESET_PATH})..."

  local _PZC_EMPTY_TEMPLATE_PRESET_PATH="${PZC_PZC_DIR}/progs/cmake/preset_templates/${CMP_PROJECT}/install.json.in"

  # Si le preset install n'existe pas, on n'en a pas besoin, on prend le generic.
  if [[ ! -e "${_PZC_EMPTY_TEMPLATE_PRESET_PATH}" ]]
  then
    _PZC_EMPTY_TEMPLATE_PRESET_PATH="${PZC_PZC_DIR}/progs/cmake/preset_templates/generic/install.json.in"
  fi

  sed \
    -e "s|@PZC_CMP_SOURCE_DIR@|${CMP_SOURCE_DIR}|g" \
    -e "s|@PZC_CMP_BUILD_DIR@|${CMP_BUILD_DIR}|g" \
    -e "s|@PZC_CMP_INSTALL_DIR@|${CMP_INSTALL_DIR}|g" \
    -e "s|@PZC_CMP_OTHER_VAR@|${_PZC_ARCANE_INSTALL_DIR}|g" \
    \
    "${_PZC_EMPTY_TEMPLATE_PRESET_PATH}" > "${_PZC_TMP_INSTALL_PRESET_PATH}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

#! \brief Fonction permettant de générer le preset d'installation "generated_install_" (2/2).
#!
#! Ce preset permet d'importer l'installation de ce projet dans un autre projet.
#!
#! \return 0 Ok.
#! \return 10 Projet non initialisé.
function _pzc_common_generate_install_preset()
{
  if [[ ! -v CMP_SOURCE_DIR ]]
  then
    return 10
  fi

  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    return 10
  fi


  local _PZC_TMP_INSTALL_PRESET_PATH="${CMP_BUILD_DIR}/install_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  local _PZC_TMP_GEN_INSTALL_PRESET_PATH="${CMP_INSTALL_DIR}/generated_install_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  _pzc_info "Generation of final installation user preset in build dir (${_PZC_TMP_GEN_INSTALL_PRESET_PATH})..."

  _pzc_common_configure_preset "${_PZC_TMP_INSTALL_PRESET_PATH}" "${_PZC_TMP_GEN_INSTALL_PRESET_PATH}"
  local RET_CODE=$?
  if [[ ${RET_CODE} != 0 ]]
  then
    return ${RET_CODE}
  fi
}



# ---------------------------------------------------------------
# ----------------------- Init functions ------------------------
# ---------------------------------------------------------------

function _pzc_common_find_project()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    return 10
  fi

  local _PZC_SOURCE_PRESET="${CMP_SOURCE_DIR}/CMakeUserPresets.json"

  if [[ -e "${_PZC_SOURCE_PRESET}" ]]
  then
    _pzc_info "To reload project detection, remove '${CMP_SOURCE_DIR}/CMakeUserPresets.json' file."
    CMP_PROJECT=$(jq -r '.vendor.pzc.cmpProject' ${_PZC_SOURCE_PRESET})
    return 0
  fi

  local _PZC_FIND_PROJECT_JSON="${PZC_PZC_DIR}/progs/cmake/preset_templates/find_project.json"

  CMP_PROJECT="generic"

  jq -r '.projects | to_entries[] | .key as $p | .value[] | "\($p)\t\(.)"' ${_PZC_FIND_PROJECT_JSON} | while IFS=$'\t' read -r PROJECT_NAME FILE_PATH; do
    _pzc_debug "Search ${FILE_PATH}"

    if [[ -e "${CMP_SOURCE_DIR}/${FILE_PATH}" ]]
    then
      CMP_PROJECT="$PROJECT_NAME"
      break
    fi
  done
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

#! \brief Fonction permettant d'initaliser le projet. Appel obligatoire pour pouvoir utiliser les autres fonctions.
#!
#! Cette fonction va initialiser les variables d'environnement nécessaires pour les autres fonctions.
#!
#! \param 1 Le nom du projet.
#! \param 2 Le type build du projet.
#! \param 3 Le variant du projet.
#! \return 0 Ok.
#! \return 1 Erreur avec message.
#! \return 10 Projet non initialisé.
function _pzc_common_initcmp()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    return 10
  fi

  if [[ -v 1 ]]
  then
    CMP_PROJECT_NAME=${1}
  else
    _pzc_error "Need project name (first arg)"
    return 1
  fi

  if [[ -v 2 ]] && [[ ${2} != "_" ]] && [[ ${2} != "none" ]]
  then
    if [[ ${2} == "d" ]] || [[ ${2} == "debug" ]] || [[ ${2} == "D" ]] || [[ ${2} == "Debug" ]]
    then
      CMP_BUILD_TYPE="debug"
      PZC_CMAKE_BUILD_TYPE="Debug"
    elif [[ ${2} == "c" ]] || [[ ${2} == "check" ]] || [[ ${2} == "C" ]] || [[ ${2} == "Check" ]]
    then
      CMP_BUILD_TYPE="check"
      PZC_CMAKE_BUILD_TYPE="RelWithDebInfo"
    elif [[ ${2} == "r" ]] || [[ ${2} == "release" ]] || [[ ${2} == "R" ]] || [[ ${2} == "Release" ]]
    then
      CMP_BUILD_TYPE="release"
      PZC_CMAKE_BUILD_TYPE="Release"
    else
      _pzc_error "Invalid 'CMP_BUILD_TYPE' [D or C or R] (second arg)"
      return 1
    fi
  else
    _pzc_info "No argument, defining 'CMP_BUILD_TYPE' to 'release'"
    CMP_BUILD_TYPE="release"
    PZC_CMAKE_BUILD_TYPE="Release"
  fi

  if [[ -v 3 ]] && [[ ${3} != "_" ]] && [[ ${3} != "none" ]]
  then
    CMP_VARIANT=${3}
    TYPE_BUILD_DIR=${CMP_BUILD_TYPE}_${3}
  else
    CMP_VARIANT="_"
    TYPE_BUILD_DIR=${CMP_BUILD_TYPE}
  fi

  local _PZC_SAVED_USER_PRESET_GENERIC_GENERIC_PATH="${PZC_EDIT_SCRIPTS}/user_${CMP_PROJECT_NAME}.json"
  local _PZC_SAVED_USER_PRESET_GENERIC_PATH="${PZC_EDIT_SCRIPTS}/user_${CMP_PROJECT_NAME}_${CMP_VARIANT}.json"

  local _PZC_SAVED_USER_PRESET_PATH="${PZC_EDIT_SCRIPTS}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"


  # D'abord, on définit les chemins par défauts.
  # Ensuite, on regarde s'il y a des presets de config user 1/2 sauvegardés.
  # - Si le preset général existe, on remplace les valeurs par défaut par celles du preset de config général.
  # - Si le preset typé existe, on remplace les valeurs déjà définies par celles du preset de config typé.
  # Enfin, si un preset de configuration user 1/2 est trouvé dans le chemin du build dir déjà défini (par défaut ou
  # grâce au preset typé), il sera utilisé pour remplacer les valeurs déjà définies.

  # Valeurs par défaut.
  if [[ ${CMP_PROJECT_TYPE} = 2 ]]
  then
    # Pour compatibilité avec l'existant.
    CMP_SOURCE_DIR="${WORK_DIR}/arcane/${CMP_PROJECT_NAME}"
  else
    CMP_SOURCE_DIR="${WORK_DIR}/${CMP_PROJECT_NAME}"
  fi
  CMP_BUILD_DIR="${BUILD_DIR}/build_${CMP_PROJECT_NAME}/${TYPE_BUILD_DIR}"
  CMP_INSTALL_DIR="${INSTALL_DIR}/install_${CMP_PROJECT_NAME}/${TYPE_BUILD_DIR}"

  # Si le preset sauvegardé de configuration général2 user 1/2 contient des infos d'initialisation.
  if [[ -e ${_PZC_SAVED_USER_PRESET_GENERIC_GENERIC_PATH} ]]
  then
    _pzc_info "A saved general general configuration user preset found. Overwrite default initialization."
    local _PZC_CMP_SOURCE_DIR=$(jq -r '.vendor.pzc.cmpSourceDir' ${_PZC_SAVED_USER_PRESET_GENERIC_GENERIC_PATH})

    if [[ ${_PZC_CMP_SOURCE_DIR} != "null" ]]
    then
      CMP_SOURCE_DIR=${_PZC_CMP_SOURCE_DIR}
    fi
  fi

  # Si le preset sauvegardé de configuration général user 1/2 contient des infos d'initialisation.
  if [[ -e ${_PZC_SAVED_USER_PRESET_GENERIC_PATH} ]]
  then
    _pzc_info "A saved general configuration user preset found. Overwrite default initialization."
    local _PZC_CMP_SOURCE_DIR=$(jq -r '.vendor.pzc.cmpSourceDir' ${_PZC_SAVED_USER_PRESET_GENERIC_PATH})

    if [[ ${_PZC_CMP_SOURCE_DIR} != "null" ]]
    then
      CMP_SOURCE_DIR=${_PZC_CMP_SOURCE_DIR}
    fi
  fi

  # Si le preset sauvegardé de configuration typé user 1/2 contient des infos d'initialisation.
  if [[ -e ${_PZC_SAVED_USER_PRESET_PATH} ]]
  then
    _pzc_info "A saved configuration user preset found. Overwrite default initialization."
    local _PZC_CMP_SOURCE_DIR=$(jq -r '.vendor.pzc.cmpSourceDir' ${_PZC_SAVED_USER_PRESET_PATH})
    local _PZC_CMP_BUILD_DIR=$(jq -r '.vendor.pzc.cmpBuildDir' ${_PZC_SAVED_USER_PRESET_PATH})
    local _PZC_CMP_INSTALL_DIR=$(jq -r '.vendor.pzc.cmpInstallDir' ${_PZC_SAVED_USER_PRESET_PATH})

    if [[ ${_PZC_CMP_SOURCE_DIR} != "null" ]]
    then
      CMP_SOURCE_DIR=${_PZC_CMP_SOURCE_DIR}
    fi
    if [[ ${_PZC_CMP_BUILD_DIR} != "null" ]]
    then
      CMP_BUILD_DIR=${_PZC_CMP_BUILD_DIR}
    fi
    if [[ ${_PZC_CMP_INSTALL_DIR} != "null" ]]
    then
      CMP_INSTALL_DIR=${_PZC_CMP_INSTALL_DIR}
    fi
  fi

  # Si le preset de configuration user 1/2 contient des infos d'initialisation.
  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  if [[ -e ${_PZC_TMP_USER_PRESET_PATH} ]]
  then
    _pzc_info "A configuration user preset found. Overwrite default initialization."
    local _PZC_CMP_SOURCE_DIR=$(jq -r '.vendor.pzc.cmpSourceDir' ${_PZC_TMP_USER_PRESET_PATH})
    local _PZC_CMP_BUILD_DIR=$(jq -r '.vendor.pzc.cmpBuildDir' ${_PZC_TMP_USER_PRESET_PATH})
    local _PZC_CMP_INSTALL_DIR=$(jq -r '.vendor.pzc.cmpInstallDir' ${_PZC_TMP_USER_PRESET_PATH})

    if [[ ${_PZC_CMP_SOURCE_DIR} != "null" ]]
    then
      CMP_SOURCE_DIR=${_PZC_CMP_SOURCE_DIR}
    fi
    if [[ ${_PZC_CMP_BUILD_DIR} != "null" ]]
    then
      CMP_BUILD_DIR=${_PZC_CMP_BUILD_DIR}
    fi
    if [[ ${_PZC_CMP_INSTALL_DIR} != "null" ]]
    then
      CMP_INSTALL_DIR=${_PZC_CMP_INSTALL_DIR}
    fi
  fi

  _pzc_common_find_project
  local RET_CODE=$?
  if [[ ${RET_CODE} != 0 ]]
  then
    return ${RET_CODE}
  fi

  _pzc_info "Detected project: ${CMP_PROJECT}"

  mkdir -p "${CMP_BUILD_DIR}"
  mkdir -p "${CMP_INSTALL_DIR}"

  cd "${CMP_BUILD_DIR}"
}



# ---------------------------------------------------------------
# ---------------------- Config functions -----------------------
# ---------------------------------------------------------------

#! \brief Fonction permettant de configurer le projet avec CMake.
#!
#! Le preset de configuration utilisateur 2/2 "generated_user_" va être généré (écrasé si existant).
#! Le preset source va être généré dans les sources du projet.
#!
#! \param 1 Si =1 alors version GPU.
#! \return 0 Ok.
#! \return 10 Projet non initialisé.
#! \return 13 Preset de configuration utilisateur 1/2 non trouvé
function _pzc_common_configcmp()
{
  if [[ ! -v 1 ]]
  then
    _pzc_debug "First param not found"
    return 2
  fi

  if [[ ! -v CMP_BUILD_DIR ]]
  then
    return 10
  fi

  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  if [[ ! -e "${_PZC_TMP_USER_PRESET_PATH}" ]]
  then
    return 13
  fi

  local _PZC_TMP_GEN_USER_PRESET_PATH="${CMP_BUILD_DIR}/generated_user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"

  _pzc_common_generate_user_preset
  local RET_CODE=$?
  if [[ ${RET_CODE} != 0 ]]
  then
    return ${RET_CODE}
  fi

  _pzc_info "Generation of CMakeUserPresets.json in ${CMP_PROJECT_NAME} source..."
  echo "{\"version\":4,\"vendor\":{\"pzc\": {\"cmpProject\":\"${CMP_PROJECT}\"}},\"include\":[\"${_PZC_TMP_GEN_USER_PRESET_PATH}\"]}" > "${CMP_SOURCE_DIR}/CMakeUserPresets.json"

  _pzc_pensil_begin


  if [[ ${1} == "_" ]]
  then
    echo "cmake \\"
    echo "  -S ${CMP_SOURCE_DIR} \\"
    echo "  --preset ${CMP_BUILD_TYPE}"
  else
    echo "cmake \\"
    echo "  -S ${CMP_SOURCE_DIR} \\"
    echo "  --preset ${CMP_BUILD_TYPE}_${1}"
  fi


  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    echo "chmod u+x ${CMP_BUILD_DIR}/bin/*"
  fi

  _pzc_pensil_end

  if [[ ${1} == "_" ]]
  then
    cmake \
      -S ${CMP_SOURCE_DIR} \
      --preset "${CMP_BUILD_TYPE}"
  else
    cmake \
      -S ${CMP_SOURCE_DIR} \
      --preset "${CMP_BUILD_TYPE}_${1}"
  fi


  if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
  then
    chmod u+x "${CMP_BUILD_DIR}/bin/*"
  fi
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

#! \brief Fonction permettant de configurer le projet CMake. S'occupe de la génération des presets 1/2 si nécessaire.
#!
#! \param 1 Si =1 alors version GPU.
#! \return Voir les autres commentaires.
function _pzc_common_generate_and_configcmp()
{
  if [[ ! -v 1 ]]
  then
    _pzc_debug "Argument 1 not found"
    return 2
  fi

  _pzc_common_configcmp $1

  local RET_CODE=$?
  if [[ $RET_CODE = 13 ]]
  then
    _pzc_info "Configuration user preset not found. Generation..."

    _pzc_common_pcmp
    local RET_CODE2=$?
    if [[ ${RET_CODE2} != 0 ]]
    then
      return ${RET_CODE2}
    fi

    _pzc_common_ipcmp
    local RET_CODE2=$?
    if [[ ${RET_CODE2} != 0 ]]
    then
      return ${RET_CODE2}
    fi

    _pzc_common_configcmp $1
    local RET_CODE2=$?
    if [[ ${RET_CODE2} != 0 ]]
    then
      return ${RET_CODE2}
    fi

  elif [[ $RET_CODE != 0 ]]
  then
    return $RET_CODE
  fi
}



# ---------------------------------------------------------------
# -------------------- Dependencies functions -------------------
# ---------------------------------------------------------------

#! \brief Fonction permettant d'ajouter ou supprimer une dépendance du preset de configuration utilisateur 1/2.
#!
#! Le preset de configuration utilisateur 2/2 "generated_user_" va être généré (écrasé si existant).
#! Le preset source va être généré dans les sources du projet.
#!
#! \param 1 Le nom du projet dépendant.
#! \param 2 Le type build du projet dépendant.
#! \param 3 Le variant du projet dépendant.
#! \param 4 Si =1 alors ajout de dep, sinon suppression.
#! \return 0 Ok.
#! \return 1 Erreur avec message.
#! \return 2 Erreur interne.
#! \return 10 Projet non initialisé.
#! \return 13 Preset de configuration utilisateur 1/2 non trouvé
function _pzc_common_depcmp()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    return 10
  fi

  if [[ -v 1 ]]
  then
    local ADD_CMP_PROJECT_NAME=${1}
  else
    _pzc_error "Need dep project name (first arg)"
    return 1
  fi

  if [[ -v 2 ]] && [[ ${2} != "_" ]] && [[ ${2} != "none" ]] && [[ ${2} != "@" ]]
  then
    if [[ ${2} == "d" ]] || [[ ${2} == "debug" ]] || [[ ${2} == "D" ]] || [[ ${2} == "Debug" ]]
    then
      local ADD_CMP_BUILD_TYPE=debug
    elif [[ ${2} == "c" ]] || [[ ${2} == "check" ]] || [[ ${2} == "C" ]] || [[ ${2} == "Check" ]]
    then
      local ADD_CMP_BUILD_TYPE=check
    elif [[ ${2} == "r" ]] || [[ ${2} == "release" ]] || [[ ${2} == "R" ]] || [[ ${2} == "Release" ]]
    then
      local ADD_CMP_BUILD_TYPE=release
    else
      _pzc_error "Invalid 'ADD_CMP_BUILD_TYPE' [D or C or R] (second arg)"
      return 1
    fi
  else
    local ADD_CMP_BUILD_TYPE="@CMP_BUILD_TYPE@"
  fi

  if [[ -v 3 ]] && [[ ${3} != "_" ]] && [[ ${3} != "none" ]]
  then
    local ADD_CMP_VARIANT=${3}
  else
    local ADD_CMP_VARIANT="_"
  fi

  local _PZC_TMP_USER_PRESET_PATH="${CMP_BUILD_DIR}/user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  if [[ ! -e "${_PZC_TMP_USER_PRESET_PATH}" ]]
  then
    return 13
  fi

  if [[ -v 4 ]]
  then
    if [[ ${4} == 1 ]]
    then
      # Ajout
      jq \
        ".vendor.pzc.cmpDependencies = (.vendor.pzc.cmpDependencies + [[\"${ADD_CMP_PROJECT_NAME}\", \"${ADD_CMP_BUILD_TYPE}\", \"${ADD_CMP_VARIANT}\"]] | unique)" \
        "${_PZC_TMP_USER_PRESET_PATH}" > "${_PZC_TMP_USER_PRESET_PATH}.tmp"
    elif [[ ${4} == 2 ]]
    then
      # Suppression
      jq \
        ".vendor.pzc.cmpDependencies -= [[\"${ADD_CMP_PROJECT_NAME}\", \"${ADD_CMP_BUILD_TYPE}\", \"${ADD_CMP_VARIANT}\"]]" \
        "${_PZC_TMP_USER_PRESET_PATH}" > "${_PZC_TMP_USER_PRESET_PATH}.tmp"
    fi
  else
    _pzc_debug "Argument 4 not found"
    return 2
  fi

  \mv "${_PZC_TMP_USER_PRESET_PATH}.tmp" "${_PZC_TMP_USER_PRESET_PATH}"
}

# ---------------------------------------------------------------
# ---------------------------------------------------------------

#! \brief Fonction permettant de compiler toutes les dépendences du projet en cours.
#!
#! \return 0 Ok.
#! \return 1 Erreur avec message.
#! \return 10 Projet non initialisé.
#! \return 14 Preset de configuration utilisateur 2/2 "generated_user_" non trouvé.
function _pzc_common_bidep()
{
  if [[ ! -v CMP_PROJECT_TYPE ]]
  then
    return 10
  fi

  # On génère le preset de configuration user 2/2 pour avoir les cmpDependencies 2/2.
  _pzc_common_generate_user_preset
  local RET_CODE=$?
  if [[ ${RET_CODE} != 0 ]]
  then
    return ${RET_CODE}
  fi

  local _PZC_TMP_GEN_USER_PRESET_PATH="${CMP_BUILD_DIR}/generated_user_${CMP_PROJECT_NAME}_${TYPE_BUILD_DIR}.json"
  if [[ ! -e "${_PZC_TMP_GEN_USER_PRESET_PATH}" ]]
  then
    return 14
  fi

  local ACTUAL_CMP_PROJECT_TYPE=${CMP_PROJECT_TYPE}
  local ACTUAL_CMP_PROJECT_NAME=${CMP_PROJECT_NAME}
  local ACTUAL_CMP_BUILD_TYPE=${CMP_BUILD_TYPE}
  local ACTUAL_CMP_VARIANT=${CMP_VARIANT}

  jq -r '.vendor.pzc.cmpDependencies[] | @tsv' "${_PZC_TMP_GEN_USER_PRESET_PATH}" | while read -r var1 var2 var3
  do
    echo ""
    _pzc_info "Build and install dependency -- Name : ${var1} -- Type : ${var2} -- Variant : ${var3}"
    echo ""

    # Aujourd'hui, framework est un nom réservé désignant Arcane framework (donc CMP_PROJECT_TYPE=2).
    if [[ ${var1} == "framework" ]]
    then
      CMP_PROJECT_TYPE=2
    else
      CMP_PROJECT_TYPE=1
    fi

    _pzc_common_initcmp ${var1} ${var2} ${var3}

    _pzc_info "Configure CMake Project: ${CMP_PROJECT_NAME}..."

    _pzc_common_generate_and_configcmp 0
    local RET_CODE=$?
    if [[ ${RET_CODE} != 0 ]]
    then
      _pzc_cmp_error_message ${RET_CODE}
      return $?
    fi

    if [[ ${PZC_CHMOD_COMPILING} = 1 ]]
    then
      chmod u+x ${CMP_BUILD_DIR}/bin/*
    fi
    cmake --build ${CMP_BUILD_DIR} --target install

    if [[ $? != 0 ]]
    then
      return 1
    fi

    _pzc_info "${CMP_PROJECT_NAME} is installed in dir: \"${CMP_INSTALL_DIR}\""
    _pzc_common_generate_install_preset
    local RET_CODE=$?
    if [[ ${RET_CODE} != 0 ]]
    then
      return ${RET_CODE}
    fi

  done

  CMP_PROJECT_TYPE=${ACTUAL_CMP_PROJECT_TYPE}

  echo ""
  _pzc_info "Reload project -- Name : ${ACTUAL_CMP_PROJECT_NAME} -- Type : ${ACTUAL_CMP_BUILD_TYPE} -- Variant : ${ACTUAL_CMP_VARIANT}"
  _pzc_common_initcmp ${ACTUAL_CMP_PROJECT_NAME} ${ACTUAL_CMP_BUILD_TYPE} ${ACTUAL_CMP_VARIANT}
  _pzc_pensil_begin
  echo "CMP_PROJECT_NAME=${CMP_PROJECT_NAME}"
  echo "TYPE_BUILD_DIR=${TYPE_BUILD_DIR}"
  echo ""
  echo "CMP_BUILD_TYPE=${CMP_BUILD_TYPE}"
  echo "CMP_SOURCE_DIR=${CMP_SOURCE_DIR}"
  echo "CMP_BUILD_DIR=${CMP_BUILD_DIR}"
  echo "CMP_INSTALL_DIR=${CMP_INSTALL_DIR}"
  echo ""
  echo "mkdir -p ${CMP_BUILD_DIR}"
  echo "cd ${CMP_BUILD_DIR}"
  _pzc_pensil_end
}
