TOOL_DIR=${TOOL_DIR-${0:A:h}}
HISTORY_ALL_FILE="$HOME/.zsh/history_all.txt"

function fzf-history-widget() {
  local history_dir_file result
  history_dir_file="${HOME}/.zsh/histories$(builtin pwd)/history"
  result=$(fzfyml4 run ${TOOL_DIR}/main/history.yml "${history_dir_file}" "${HISTORY_ALL_FILE}" "${BUFFER}")
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

function preexec() {
  local history_dir_file
  history_dir_file="${HOME}/.zsh/histories$(builtin pwd)/history"
  mkdir -p $(dirname ${history_dir_file})
  echo "$1" >> ${history_dir_file}
  echo "$1$(builtin pwd)" >> ${HISTORY_ALL_FILE}
}
