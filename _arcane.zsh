
## ----- Arcane aliases/functions section -----



# ---------------------------------------------------------------
# -------------------------- Aliases ----------------------------
# ---------------------------------------------------------------

alias gitarc='_coal_eval "cd ${WORK_DIR}/arcane/framework"'
alias gitbenchs='_coal_eval "cd ${WORK_DIR}/arcane/arcane-benchs"'



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

initbenchs()
{
  _pensil_begin
  _ecal_eval "ARCANE_TYPE_BUILD=${1}"
  _ecal_eval "ARCANE_INSTALL_PATH=${BUILD_DIR}/install_framework/${ARCANE_TYPE_BUILD}"
  echo ""
  _ecal_eval "AB_BUILD_TYPE=${1}"
  _ecal_eval "AB_SOURCE_DIR=${WORK_DIR}/arcane/arcane-benchs"
  _ecal_eval "AB_BUILD_DIR=${BUILD_DIR}/build_arcane-benchs/${AB_BUILD_TYPE}"
  _ecal_eval "AB_INSTALL_PATH=${BUILD_DIR}/install_arcane-benchs/${AB_BUILD_TYPE}"
  _ecal_eval "AB_EXE=${AB_BUILD_DIR}/qama/src/qama"
  _ecal_eval "AB_ARC=${AB_SOURCE_DIR}/qama/data/tests/ExampleFull.arc"
  echo ""
  _ecal_eval "mkdir -p ${AB_BUILD_DIR}"
  echo ""
  _ecal_eval "cd ${AB_BUILD_DIR}"
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
    echo "  -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \\"
    echo "  -DCMAKE_C_COMPILER_LAUNCHER=ccache \\"
    echo "  -DCMAKE_C_FLAGS=-fdiagnostics-color=always \\"
    echo "  -DCMAKE_CXX_FLAGS=-fdiagnostics-color=always \\"
    echo "  -DCMAKE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \\"
    echo "  -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \\"
    echo "  -DARCCORE_BUILD_MODE=${ARCANE_TYPE_BUILD}"
    echo "chmod u+x ${ARCANE_BUILD_DIR}/bin/*"
    _pensil_end

    cmake \
      -S ${ARCANE_SOURCE_DIR} \
      -B ${ARCANE_BUILD_DIR} \
      -GNinja \
      -DCMAKE_INSTALL_PREFIX=${ARCANE_INSTALL_PATH} \
      -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
      -DCMAKE_C_COMPILER_LAUNCHER=ccache \
      -DCMAKE_C_FLAGS="-fdiagnostics-color=always" \
      -DCMAKE_CXX_FLAGS="-fdiagnostics-color=always" \
      -DCMAKE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \
      -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \
      -DARCCORE_BUILD_MODE=${ARCANE_TYPE_BUILD}
  
    chmod u+x ${ARCANE_BUILD_DIR}/bin/*
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
    echo "  -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \\"
    echo "  -DCMAKE_C_COMPILER_LAUNCHER=ccache \\"
    echo "  -DCMAKE_C_FLAGS=-fdiagnostics-color=always \\"
    echo "  -DCMAKE_CXX_FLAGS=-fdiagnostics-color=always \\"
    echo "  -DCMAKE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \\"
    echo "  -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \\"
    echo "  -DARCCORE_BUILD_MODE=${ARCANE_TYPE_BUILD} \\"
    echo "  -DARCANE_ACCELERATOR_MODE=CUDANVCC -DCMAKE_CUDA_COMPILER=nvcc"
    echo "chmod u+x ${ARCANE_BUILD_DIR}/bin/*"
    _pensil_end

    cmake \
      -S ${ARCANE_SOURCE_DIR} \
      -B ${ARCANE_BUILD_DIR} \
      -GNinja \
      -DCMAKE_INSTALL_PREFIX=${ARCANE_INSTALL_PATH} \
      -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
      -DCMAKE_C_COMPILER_LAUNCHER=ccache \
      -DCMAKE_C_FLAGS="-fdiagnostics-color=always" \
      -DCMAKE_CXX_FLAGS="-fdiagnostics-color=always" \
      -DCMAKE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \
      -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \
      -DARCCORE_BUILD_MODE=${ARCANE_TYPE_BUILD} \
      -DARCANE_ACCELERATOR_MODE=CUDANVCC -DCMAKE_CUDA_COMPILER=nvcc

    chmod u+x ${ARCANE_BUILD_DIR}/bin/*
  else
    echo "Lancer initarc avant"
    return 1
  fi
}

configarcldoc()
{
  if [[ -v ARCANE_BUILD_DIR ]]
  then
    _pensil_begin
    echo "cmake \\"
    echo "  -S ${ARCANE_SOURCE_DIR} \\"
    echo "  -B ${ARCANE_BUILD_DIR} \\"
    echo "  -GNinja \\"
    echo "  -DCMAKE_INSTALL_PREFIX=${ARCANE_INSTALL_PATH} \\"
    echo "  -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \\"
    echo "  -DCMAKE_C_COMPILER_LAUNCHER=ccache \\"
    echo "  -DCMAKE_C_FLAGS=-fdiagnostics-color=always \\"
    echo "  -DCMAKE_CXX_FLAGS=-fdiagnostics-color=always \\"
    echo "  -DCMAKE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \\"
    echo "  -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \\"
    echo "  -DARCCORE_BUILD_MODE=${ARCANE_TYPE_BUILD} \\"
    echo "  -DARCANEDOC_LEGACY_THEME=ON \\"
    echo "  -DARCANEDOC_OFFLINE=ON"

    echo "chmod u+x ${ARCANE_BUILD_DIR}/bin/*"
    _pensil_end

    cmake \
      -S ${ARCANE_SOURCE_DIR} \
      -B ${ARCANE_BUILD_DIR} \
      -GNinja \
      -DCMAKE_INSTALL_PREFIX=${ARCANE_INSTALL_PATH} \
      -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
      -DCMAKE_C_COMPILER_LAUNCHER=ccache \
      -DCMAKE_C_FLAGS="-fdiagnostics-color=always" \
      -DCMAKE_CXX_FLAGS="-fdiagnostics-color=always" \
      -DCMAKE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \
      -DARCANE_BUILD_TYPE=${ARCANE_TYPE_BUILD} \
      -DARCCORE_BUILD_MODE=${ARCANE_TYPE_BUILD} \
      -DARCANEDOC_LEGACY_THEME=ON \
      -DARCANEDOC_OFFLINE=ON
  
    chmod u+x ${ARCANE_BUILD_DIR}/bin/*
  else
    echo "Lancer initarc avant"
    return 1
  fi
}

configbenchs()
{
  if [[ -v AB_BUILD_DIR ]]
  then
    _pensil_begin
    echo "cmake \\"
    echo "  -S ${AB_SOURCE_DIR} \\"
    echo "  -B ${AB_BUILD_DIR} \\"
    echo "  -GNinja \\"
    echo "  -DCMAKE_C_FLAGS=-fdiagnostics-color=always \\"
    echo "  -DCMAKE_CXX_FLAGS=-fdiagnostics-color=always \\"
    echo "  -DCMAKE_INSTALL_PREFIX=${AB_INSTALL_PATH} \\"
    echo "  -DCMAKE_PREFIX_PATH=${ARCANE_INSTALL_PATH} \\"
    echo "  -DCMAKE_BUILD_TYPE=${AB_BUILD_TYPE}"
    _pensil_end

    cmake \
      -S ${AB_SOURCE_DIR} \
      -B ${AB_BUILD_DIR} \
      -GNinja \
      -DCMAKE_C_FLAGS="-fdiagnostics-color=always" \
      -DCMAKE_CXX_FLAGS="-fdiagnostics-color=always" \
      -DCMAKE_INSTALL_PREFIX=${AB_INSTALL_PATH} \
      -DCMAKE_PREFIX_PATH=${ARCANE_INSTALL_PATH} \
      -DCMAKE_BUILD_TYPE=${AB_BUILD_TYPE}
  else
    echo "Lancer initbenchs avant"
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
    echo "cmake --build ${ARCANE_BUILD_DIR}"
    echo "chmod u+x ${ARCANE_BUILD_DIR}/bin/*"
    echo "cmake --build ${ARCANE_BUILD_DIR} --target ${1}doc"
    _pensil_end

    chmod u+x ${ARCANE_BUILD_DIR}/bin/*
    cmake --build ${ARCANE_BUILD_DIR}
    chmod u+x ${ARCANE_BUILD_DIR}/bin/*
    cmake --build ${ARCANE_BUILD_DIR} --target ${1}doc

  else
    echo "Lancer initarc avant"
    return 1
  fi
}
