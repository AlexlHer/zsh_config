command_not_found_handler() {
  local pkgs cmd="$1"
  printf 'zsh: command not found: %s\n' "$cmd"
  return 127
}
