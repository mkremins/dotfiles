# per-login-shell settings
# =============================================================================

# set up PATH variable
# -----------------------------------------------------------------------------

path_components=(
  # Homebrew, etc
  /usr/local/{,s}bin
  # system
  /{,s}bin
  /usr/{,s}bin
)

path_builder=""
for path_component in ${path_components[@]}; do
  if [ -z $path_builder ]; then
    path_builder=$path_component
  else
    path_builder="$path_builder:$path_component"
  fi
done

export PATH="$path_builder"
unset path_component{,s} path_builder

# load per-shell settings
# -----------------------------------------------------------------------------

source ~/.bashrc
