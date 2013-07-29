# set up fancy colored prompt
# =============================================================================
# NOTE: these colors make no sense without Solarized color scheme installed
# get it @ http://ethanschoonover.com/solarized





# color variables
# -----------------------------------------------------------------------------

fg_blue='0;34'
fg_cyan='0;36'
fg_faded='0;30'
fg_gray='1;32'
fg_green='0;32'
fg_magenta='0;35'
fg_normal='0'
fg_orange='1;31'
fg_purple='1;35'
fg_red='0;31'
fg_yellow='0;33'

bg_blue='44'
bg_cyan='46'
bg_green='42'
bg_magenta='45'
bg_offwhite='47'
bg_red='41'
bg_select='40'
bg_yellow='43'





# color utilities
# -----------------------------------------------------------------------------

color_code() {
  local fg_color=$1
  local bg_color=""
  [ -n "$2" ] && bg_color=";$2"
  echo "\033[${fg_color}${bg_color}m"
}

color_reset=$(color_code $fg_normal)

colorize() {
  local text=$1
  local color=$2
  echo $(color_code $color)$text$color_reset
}





# keep changeable info (git status, etc) up to date
# -----------------------------------------------------------------------------

GIT_BRANCH='NONE'
STATUS_COLOR=$fg_green

update_git_branch() {
  local git_head
  local git_dir=`git rev-parse --git-dir 2>/dev/null`
  if [[ -z "$git_dir" ]]; then
    GIT_BRANCH='NONE'
    return 0
  fi
  git_head=`cat $git_dir/HEAD`
  GIT_BRANCH=${git_head##*/}
}

update_status_color() {
  local git_status
  if [[ $GIT_BRANCH = 'NONE' ]]; then
    STATUS_COLOR=$fg_green
  else
    git_status=`git status --porcelain`
    if [[ -z "$git_status" ]]; then
      STATUS_COLOR=$fg_green
    else
      echo -e "$git_status" | grep -q '^ [A-Z\?]'
      if [[ "$?" = 0 ]]; then
        STATUS_COLOR=$fg_red
      else
        STATUS_COLOR=$fg_yellow
      fi
    fi
  fi
}

precmd() {
  update_git_branch
  update_status_color
}





# print everything out
# -----------------------------------------------------------------------------

prompt_char=$(colorize "%#" $fg_magenta)
working_dir=$(colorize "%~" $fg_green)

IN=$(colorize " in " $fg_gray)
ON=$(colorize " ⭠ " $fg_gray)

print_user_host() {
  local user=`whoami`
  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    echo $(colorize "$user@%m" $fg_blue)$IN
  fi
}

print_git_info() {
  if [[ $GIT_BRANCH = 'NONE' ]]; then
    return 0
  else
    echo $ON$(colorize "$GIT_BRANCH" $STATUS_COLOR)
  fi
}

PROMPT='
$(print_user_host)${working_dir}$(print_git_info)
${prompt_char} '
