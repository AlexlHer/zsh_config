
## ----- Podman/Docker functions section -----



# ---------------------------------------------------------------
# ----------------------- Init functions ------------------------
# ---------------------------------------------------------------

initpm()
{
  if [[ ! -v 1 ]]; then
    pm images
    _pzc_error "Need image as parameter."
    return 1
  fi

  IMAGE=$1

  _pzc_info "Creating and running container..."
  CONTAINER=$(pm run \
    -v ${WORK_DIR}:/root/work:ro \
    -v ${CONTAINER_BUILD_DIR}:/root/build_install \
    -e OMPI_ALLOW_RUN_AS_ROOT=1 \
    -e OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 \
    -e USER=root \
    -w /root \
    -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
    -dt $IMAGE \
  )
  export CONTAINER=$(echo $CONTAINER | tail -n 1)

  _pzc_info "Installing additionnal packages in container..."
  pm exec $CONTAINER apt-get update
  pm exec $CONTAINER apt-get install zsh unzip exa git mold vim gdb xcb libgtk-3-common libasound2 libdbus-glib-1-2 -y

  _pzc_info "Installing OhMyPosh in container..."
  pm exec $CONTAINER curl -o /root/install.sh https://ohmyposh.dev/install.sh
  pm exec $CONTAINER chmod u+x /root/install.sh
  pm exec $CONTAINER bash -c /root/install.sh

  _pzc_info "Installing PZC in container..."
  pm exec $CONTAINER git clone https://github.com/AlexlHer/zsh_config /root/.pzc
  pm exec $CONTAINER cp /root/.pzc/home.zshrc /root/.zshrc

  _pzc_info "Copying .zhistory in container..."
  pm cp $HOME/.zhistory $CONTAINER:/root/.zhistory

  echo ""
  _pzc_info "Executing container..."
  _pzc_coal_eval "pm exec -it $CONTAINER zsh"
}
