
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
  CONTAINER=$(pm run -v /home/alexandre/work:/root/work:ro -e OMPI_ALLOW_RUN_AS_ROOT=1 -e OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 -dt $IMAGE)
  export CONTAINER=$(echo $CONTAINER | tail -n 1)

  _pzc_info "Executing command 'apt-get update' in container..."
  pm exec $CONTAINER apt-get update

  _pzc_info "Executing command 'apt-get install zsh unzip exa git mold vim -y' in container..."
  pm exec $CONTAINER apt-get install zsh unzip exa git mold vim -y

  _pzc_info "Executing command 'curl -o /root/install.sh https://ohmyposh.dev/install.sh' in container..."
  pm exec $CONTAINER curl -o /root/install.sh https://ohmyposh.dev/install.sh

  _pzc_info "Executing command 'chmod u+x /root/install.sh' in container..."
  pm exec $CONTAINER chmod u+x /root/install.sh

  _pzc_info "Executing command 'bash -c /root/install.sh' in container..."
  pm exec $CONTAINER bash -c /root/install.sh

  _pzc_info "Executing command 'git clone https://github.com/AlexlHer/zsh_config /root/.pzc' in container..."
  pm exec $CONTAINER git clone https://github.com/AlexlHer/zsh_config /root/.pzc

  _pzc_info "Executing command 'cp /root/.pzc/home.zshrc /root/.zshrc' in container..."
  pm exec $CONTAINER cp /root/.pzc/home.zshrc /root/.zshrc

  _pzc_info "Copying .zhistory in container..."
  pm cp $HOME/.zhistory $CONTAINER:/root/.zhistory

  echo ""
  _pzc_info "Executing container..."
  _pzc_coal_eval "pm exec -w /root -it $CONTAINER zsh"
}
