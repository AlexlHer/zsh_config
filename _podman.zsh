
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
  alias pmps='_pzc_coal "podman ps -a" ; podman ps -a'
  alias pmim='_pzc_coal "podman images" ; podman images'
  alias pmst='_pzc_coal "podman stop -t 2" ; podman stop -t 2'
  alias pmri='_pzc_coal "podman image rm" ; podman image rm'

elif [[ -x "$(command -v docker)" ]]
then
  _pzc_debug "Aliases for docker"
  alias pm='docker'
  alias podman='docker'
  alias pmps='_pzc_coal "docker ps -a" ; docker ps -a'
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
      _pzc_error "Need an image and a name as parameters."
      return 1
    fi

    local IMAGE=$1

    if [[ ! -v 2 ]]
    then
      _pzc_warning "Set default name for container."
    else
      local NAME=$2
      local OPTION_NAME="--name=$NAME"
    fi

    _pzc_info "Creating and running container..."
    CONTAINER=$(pm run \
      -v ${WORK_DIR}:/root/work:ro \
      -v ${CONTAINER_BUILD_DIR}:/root/build_install \
      -e OMPI_ALLOW_RUN_AS_ROOT=1 \
      -e OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 \
      -e USER=root \
      -w /root \
      -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
      --cap-add sys_ptrace \
      $OPTION_NAME \
      -dt $IMAGE \
    )

    export CONTAINER=$(echo $CONTAINER | tail -n 1)

    _pzc_info "Installing additionnal packages in container..."
    pm exec $CONTAINER apt-get update
    pm exec -e DEBIAN_FRONTEND=noninteractive $CONTAINER apt-get install wget curl zsh unzip git vim gdb xcb libgtk-3-common libasound2 libdbus-glib-1-2 -y

    _pzc_info "Installing OhMyPosh in container..."
    pm exec $CONTAINER curl -o /root/install.sh https://ohmyposh.dev/install.sh
    pm exec $CONTAINER chmod u+x /root/install.sh
    pm exec $CONTAINER bash -c /root/install.sh

    _pzc_info "Installing PZC in container..."
    pm exec $CONTAINER git clone https://github.com/AlexlHer/zsh_config /root/.pzc
    pm exec $CONTAINER cp /root/.pzc/home.zshrc /root/.zshrc
    pm exec $CONTAINER sed -i 's/local _PZC_AGE_AVAILABLE=1/local _PZC_AGE_AVAILABLE=0/g' /root/.zshrc

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
