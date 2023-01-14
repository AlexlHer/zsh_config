
## ----- Arcane aliases/functions section -----



# ---------------------------------------------------------------
# -------------------------- Aliases ----------------------------
# ---------------------------------------------------------------

alias gitarc='_coal_eval "cd ${WORK_DIR}/arcane/framework"'
alias gitqama='_coal_eval "cd ${WORK_DIR}/arcane/arcane-benchs"'



# ---------------------------------------------------------------
# ----------------------- Init functions ------------------------
# ---------------------------------------------------------------

initarc()
{
  _pensil_begin
  _ecal_eval "ARCANE_TYPE_BUILD=${1}"
  _ecal_eval "ARCANE_SOURCE_DIR=${WORK_DIR}/arcane/framework"
  _ecal_eval "ARCANE_BUILD_DIR=${BUILD_DIR}/build_framework/${ARCANE_TYPE_BUILD}"
  _ecal_eval "ARCANE_INSTALL_PATH=${BUILD_DIR}/install_framework/${ARCANE_TYPE_BUILD}"
  echo ""
  _ecal_eval "mkdir -p ${ARCANE_BUILD_DIR}"
  _ecal_eval "mkdir -p ${ARCANE_INSTALL_PATH}"
  echo ""
  _ecal_eval "cd ${ARCANE_BUILD_DIR}"
  _pensil_end
}

initarcfork()
{
  _pensil_begin
  _ecal_eval "ARCANE_TYPE_BUILD=${1}"
  _ecal_eval "ARCANE_SOURCE_DIR=${WORK_DIR}/arcane/forks/framework"
  _ecal_eval "ARCANE_BUILD_DIR=${BUILD_DIR}/build_framework_fork/${ARCANE_TYPE_BUILD}"
  _ecal_eval "ARCANE_INSTALL_PATH=${BUILD_DIR}/install_framework_fork/${ARCANE_TYPE_BUILD}"
  echo ""
  _ecal_eval "mkdir -p ${ARCANE_BUILD_DIR}"
  _ecal_eval "mkdir -p ${ARCANE_INSTALL_PATH}"
  echo ""
  _ecal_eval "cd ${ARCANE_BUILD_DIR}"
  _pensil_end
}

initqama()
{
  _pensil_begin
  _ecal_eval "ARCANE_TYPE_BUILD=${1}"
  _ecal_eval "ARCANE_INSTALL_PATH=${BUILD_DIR}/install_framework/${ARCANE_TYPE_BUILD}"
  echo ""
  _ecal_eval "QS_BUILD_TYPE=${1}"
  _ecal_eval "QS_SOURCE_DIR=${WORK_DIR}/arcane/arcane-benchs/quicksilver"
  _ecal_eval "QS_BUILD_DIR=${BUILD_DIR}/build_arcane-benchs/${QS_BUILD_TYPE}"
  _ecal_eval "QS_EXE=${QS_BUILD_DIR}/src/Quicksilver"
  _ecal_eval "QS_ARC=${QS_SOURCE_DIR}/data/tests/ExampleFull.arc"
  echo ""
  _ecal_eval "mkdir -p ${QS_BUILD_DIR}"
  echo ""
  _ecal_eval "cd ${QS_BUILD_DIR}"
  _pensil_end
}



# ---------------------------------------------------------------
# ---------------------- Config functions -----------------------
# ---------------------------------------------------------------

configarc()
{
  if [[ -v ARCANE_BUILD_DIR ]]
  then
    _pensil_begin
    echo "cmake \\"
    echo "  -S ${ARCANE_SOURCE_DIR} \\"
    echo "  -B ${ARCANE_BUILD_DIR} \\"
    echo "  -GNinja \\"
    echo "  -DCMAKE_INSTALL_PREFIX=${ARCANE_INSTALL_PATH} \\"
    echo "  -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD}"
    _pensil_end

    cmake \
      -S ${ARCANE_SOURCE_DIR} \
      -B ${ARCANE_BUILD_DIR} \
      -GNinja \
      -DCMAKE_INSTALL_PREFIX=${ARCANE_INSTALL_PATH} \
      -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD}
  
    _ecal_eval "chmod u+x ${ARCANE_BUILD_DIR}/bin/*"
  else
    echo "Lancer initarc avant"
    return 1
  fi
}

configarcgpu()
{
  if [[ -v ARCANE_BUILD_DIR ]]
  then
    _pensil_begin
    echo "cmake \\"
    echo "  -S ${ARCANE_SOURCE_DIR} \\"
    echo "  -B ${ARCANE_BUILD_DIR} \\"
    echo "  -GNinja \\"
    echo "  -DCMAKE_INSTALL_PREFIX=${ARCANE_INSTALL_PATH} \\"
    echo "  -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \\"
    echo "  -DARCANE_ACCELERATOR_MODE=CUDANVCC -DCMAKE_CUDA_COMPILER=nvcc"
    _pensil_end

    cmake \
      -S ${ARCANE_SOURCE_DIR} \
      -B ${ARCANE_BUILD_DIR} \
      -GNinja \
      -DCMAKE_INSTALL_PREFIX=${ARCANE_INSTALL_PATH} \
      -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \
      -DARCANE_ACCELERATOR_MODE=CUDANVCC -DCMAKE_CUDA_COMPILER=nvcc

    _ecal_eval "chmod u+x ${ARCANE_BUILD_DIR}/bin/*"
  else
    echo "Lancer initarc avant"
    return 1
  fi
}

configqama()
{
  if [[ -v QS_BUILD_DIR ]]
  then
    _pensil_begin
    echo "cmake \\"
    echo "  -S ${QS_SOURCE_DIR} \\"
    echo "  -B ${QS_BUILD_DIR} \\"
    echo "  -GNinja \\"
    echo "  -DCMAKE_PREFIX_PATH=${ARCANE_INSTALL_PATH} \\"
    echo "  -DCMAKE_BUILD_TYPE=${QS_BUILD_TYPE}"
    _pensil_end

    cmake \
      -S ${QS_SOURCE_DIR} \
      -B ${QS_BUILD_DIR} \
      -GNinja \
      -DCMAKE_PREFIX_PATH=${ARCANE_INSTALL_PATH} \
      -DCMAKE_BUILD_TYPE=${QS_BUILD_TYPE}
  else
    echo "Lancer initqama avant"
    return 1
  fi
}



# ---------------------------------------------------------------
# ------------------- Build/Install functions -------------------
# ---------------------------------------------------------------

biarc()
{
  if [[ -v ARCANE_BUILD_DIR ]]
  then
    _pensil_begin
    echo "chmod u+x ${ARCANE_BUILD_DIR}/bin/*"
    echo "cmake --build ${ARCANE_BUILD_DIR} --target install"
    _pensil_end

    chmod u+x ${ARCANE_BUILD_DIR}/bin/*
    cmake --build ${ARCANE_BUILD_DIR} --target install

  else
    echo "Lancer initarc avant"
    return 1
  fi
}

docarc()
{
  if [[ -v ARCANE_BUILD_DIR ]]
  then
    _pensil_begin
    echo "chmod u+x ${ARCANE_BUILD_DIR}/bin/*"
    echo "cmake --build ${ARCANE_BUILD_DIR} --target ${1}doc"
    _pensil_end

    chmod u+x ${ARCANE_BUILD_DIR}/bin/*
    cmake --build ${ARCANE_BUILD_DIR} --target ${1}doc

  else
    echo "Lancer initarc avant"
    return 1
  fi
}
