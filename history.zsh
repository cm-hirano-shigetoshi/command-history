TOOL_DIR="/Users/hirano.shigetoshi/.zplugin/plugins/cm-hirano-shigetoshi---command-history"
HISTORY_ALL_FILE="$HOME/.zsh/history_all.txt"

function fzf-history-widget() {
  local history_dir_file result
  history_dir_file="${HOME}/.zsh/histories$(builtin pwd)/history"
  result=$(fzfyml run ${TOOL_DIR}/main/history.yml "${history_dir_file}" "${HISTORY_ALL_FILE}")
  if [[ -n "${result}" ]]; then
    local type
    type=$(head -1 <<< ${result})
    result=$(sed '1d' <<< ${result})
    if [[ "${type}" = "execute" ]]; then
      BUFFER="${result}"
      CURSOR="$#BUFFER"
      zle accept-line
    elif [[ "${type}" = "start" ]]; then
      BUFFER="${result}"
      CURSOR="0"
      zle redisplay
    elif [[ "${type}" = "end" ]]; then
      BUFFER="${result}"
      CURSOR="$#BUFFER"
      zle redisplay
    fi
  fi
}
zle -N fzf-history-widget
bindkey "^r" fzf-history-widget