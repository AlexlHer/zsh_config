
## ----- Podman/Docker functions section -----



# ---------------------------------------------------------------
# ------------------- Podman/Docker aliases ---------------------
# ---------------------------------------------------------------

local _PZC_PODMAN_AVAILABLE=1

if [[ -x "$(command -v podman)" ]]
then
  _pzc_debug "Aliases for podman"
  alias pm='podman'
  alias docker='podman'
  alias pmps='_pzc_coal "podman ps -a --external" ; podman ps -a --external'
  alias pmim='_pzc_coal "podman images" ; podman images'
  alias pmst='_pzc_coal "podman stop -t 2" ; podman stop -t 2'
  alias pmri='_pzc_coal "podman image rm" ; podman image rm'

elif [[ -x "$(command -v docker)" ]]
then
  _pzc_debug "Aliases for docker"
  alias pm='docker'
  alias podman='docker'
  alias pmps='_pzc_coal "docker ps -a --external" ; docker ps -a --external'
  alias pmim='_pzc_coal "docker images" ; docker images'
  alias pmst='_pzc_coal "docker stop -t 2" ; docker stop -t 2'
  alias pmri='_pzc_coal "docker image rm" ; docker image rm'
  
else
  _pzc_debug "Podman and docker not found"
  _PZC_PODMAN_AVAILABLE=0
fi



# ---------------------------------------------------------------
# ------------------ Podman/Docker functions --------------------
# ---------------------------------------------------------------

if [[ ${_PZC_PODMAN_AVAILABLE} = 1 ]]
then
  pmin()
  {
    if [[ ! -v 1 ]]
    then
      pm images
      _pzc_error "pmin image_id [container_name (random name if not set)] [storage_dir_name (default dir if not set)]"
      _pzc_error "example : pmim ce8f79aecc43 u24"
      _pzc_error "example : pmim ce8f79aecc43 u24_test test"
      return 1
    fi

    local IMAGE=$1

    _pzc_info "Creating and running container..."

    if [[ ! -v 2 ]]
    then
      _pzc_warning "Set default name for container."
    else
      local NAME=$2
      local OPTION_NAME="--name=$NAME"
    fi

    if [[ ! -v 3 ]]
    then
      _pzc_info "Set default large dir for container : ${CONTAINER_LARGE_DIR}/default"
      local _SET_LARGE_DIR="${CONTAINER_LARGE_DIR}/default"
    else
      local _SET_LARGE_DIR="${CONTAINER_LARGE_DIR}/$3"
    fi

    mkdir -p "${_SET_LARGE_DIR}"

    CONTAINER=$(pm run \
      -v ${WORK_DIR}:/root/work:z,ro \
      -v ${_SET_LARGE_DIR}:/root/pzc_dirs:z \
      -e OMPI_ALLOW_RUN_AS_ROOT=1 \
      -e OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 \
      -e USER=root \
      -w /root \
      -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
      --cap-add sys_ptrace \
      --gpus all \
      $OPTION_NAME \
      -dt $IMAGE \
    )

    export CONTAINER=$(echo $CONTAINER | tail -n 1)

    _pzc_info "Installing additionnal packages in container..."
    pm exec $CONTAINER apt-get update

    for i in wget curl zsh unzip git vim gdb xcb libgtk-3-common libasound2 libasound2t64 libdbus-glib-1-2 mold eza;
    do 
      _pzc_info "Installing $i..."
      pm exec -e DEBIAN_FRONTEND=noninteractive $CONTAINER apt-get install -y $i;
    done

    _pzc_info "Installing OhMyPosh in container..."
    pm exec $CONTAINER curl -o /root/install.sh https://ohmyposh.dev/install.sh
    pm exec $CONTAINER chmod u+x /root/install.sh
    pm exec $CONTAINER mkdir -p /root/.local/bin
    pm exec $CONTAINER bash -c /root/install.sh

    _pzc_info "Installing PZC in container..."
    pm exec $CONTAINER git clone https://github.com/AlexlHer/zsh_config /root/.pzc

    pm exec $CONTAINER cp /root/.pzc/template.zshrc /root/.zshrc
    pm exec $CONTAINER cp /root/.pzc/template.pzcrc /root/.pzcrc

    pm exec $CONTAINER sed -i 's:.*export WORK_DIR=.*:export WORK_DIR="/root/work":' /root/.pzcrc
    pm exec $CONTAINER sed -i 's:.*local _PZC_LARGE_DIR=.*:local _PZC_LARGE_DIR="/root/pzc_dirs":' /root/.pzcrc

    pm exec $CONTAINER sed -i 's/local _PZC_AGE_AVAILABLE=1/local _PZC_AGE_AVAILABLE=0/g' /root/.pzcrc
    pm exec $CONTAINER sed -i 's/local _PZC_TASK_AVAILABLE=1/local _PZC_TASK_AVAILABLE=0/g' /root/.pzcrc
    pm exec $CONTAINER sed -i 's/local _PZC_ATUIN_AVAILABLE=1/local _PZC_ATUIN_AVAILABLE=0/g' /root/.pzcrc
    pm exec $CONTAINER sed -i 's/PZC_CHMOD_COMPILING=0/PZC_CHMOD_COMPILING=1/g' /root/.pzcrc
    pm exec $CONTAINER sed -i 's:#local _PZC_OMP_BIN=:local _PZC_OMP_BIN=/root/.local/bin/oh-my-posh:g' /root/.pzcrc

    _pzc_info "Copying .zhistory in container..."
    pm cp $HOME/.zhistory $CONTAINER:/root/.zhistory

    echo ""
    _pzc_info "Executing container..."

    if [[ ! -v 2 ]]
    then
      _pzc_coal_eval "pm exec -it $CONTAINER zsh"
    else
      _pzc_coal_eval "pm exec -it $NAME zsh"
    fi
  }

  pmex()
  {
    if [[ ! -v 1 ]]
    then
      _pzc_error "Need a container name as parameter."
      return 1
    fi

    pm start ${1}
    pm exec -it ${1} zsh
  }

  pmrm()
  {
    if [[ ! -v 1 ]]
    then
      _pzc_error "Need a container name as parameter."
      return 1
    fi

    pm stop -t 0 ${1}
    pm rm ${1}
  }
fi
