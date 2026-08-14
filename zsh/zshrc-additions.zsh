#!/usr/bin/env zsh
#
# iterms2-config — zsh 히스토리 자동완성 설정
#
# 이 파일은 ~/.zshrc 맨 끝에서 source 되며, oh-my-zsh 로드가 끝난 뒤에 실행된다.
# omz 가 lib/history.zsh 와 lib/key-bindings.zsh 에서 설정한 값을 덮어써야 하므로
# 로드 시점이 omz 뒤라는 점이 중요하다.
#
# 로드 순서 규칙(위에서 아래로 반드시 지킬 것):
#   1) 히스토리 옵션
#   2) zsh-autosuggestions
#   3) fzf                        — 자체 위젯을 정의하므로 하이라이터보다 앞
#   4) zsh-syntax-highlighting    — 커스텀 위젯 정의가 모두 끝난 뒤
#   5) zsh-history-substring-search — 하이라이터보다 반드시 뒤(공식 요구사항)
#   6) 키 바인딩

# 같은 셸에서 중복 로드되는 것을 막는다.
if [[ -n ${_ITERMS2_CONFIG_ZSH_LOADED:-} ]]; then
  return 0
fi
typeset -g _ITERMS2_CONFIG_ZSH_LOADED=1

# ---------------------------------------------------------------------------
# 1) 히스토리 옵션
# ---------------------------------------------------------------------------
# omz 의 lib/history.zsh 는 hist_ignore_dups(연속된 중복만 제거)까지만 켠다.
# 같은 명령을 며칠에 걸쳐 반복하면 개별 항목으로 계속 쌓여 ↑ 순회가 지저분해지므로
# 히스토리 전체에서 중복을 제거하도록 확장한다.
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_all_dups   # 히스토리 전체에서 중복 제거
setopt hist_save_no_dups      # 파일 저장 시 중복 제외
setopt hist_find_no_dups      # 검색 중 같은 항목을 다시 보여주지 않음
setopt hist_reduce_blanks     # 명령 안의 여분 공백 정리

# ---------------------------------------------------------------------------
# Homebrew 접두 경로 결정
# ---------------------------------------------------------------------------
# `brew --prefix` 는 실행할 때마다 하위 프로세스를 띄워 셸 시작을 느리게 만든다.
# 알려진 경로를 먼저 확인하고, 그래도 못 찾을 때만 brew 를 호출한다.
() {
  local prefix
  if [[ -n ${HOMEBREW_PREFIX:-} ]]; then
    prefix=$HOMEBREW_PREFIX
  elif [[ -d /opt/homebrew/share ]]; then
    prefix=/opt/homebrew          # Apple Silicon
  elif [[ -d /usr/local/Homebrew ]]; then
    prefix=/usr/local             # Intel
  elif (( $+commands[brew] )); then
    prefix=$(brew --prefix)
  else
    return 0
  fi
  typeset -g _ITERMS2_BREW_PREFIX=$prefix
}

# 플러그인 파일이 있을 때만 source 한다. 패키지를 지운 뒤에도 셸이 정상 기동한다.
_iterms2_source_plugin() {
  local path=${_ITERMS2_BREW_PREFIX:-}/share/$1/$1.zsh
  [[ -r $path ]] && source $path
}

# ---------------------------------------------------------------------------
# 2) zsh-autosuggestions — 히스토리 기반 회색 인라인 제안
# ---------------------------------------------------------------------------
# history 전략이 먼저, 히스토리에 없으면 completion 으로 넘어간다.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# 버퍼가 지나치게 길면 제안을 만들지 않는다(JWT 가 박힌 1500자짜리 curl 대비).
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=200
_iterms2_source_plugin zsh-autosuggestions

# ---------------------------------------------------------------------------
# 3) fzf — Ctrl-R 퍼지 목록, Ctrl-T 파일 찾기
# ---------------------------------------------------------------------------
# `fzf --zsh` 출력도 매번 하위 프로세스를 띄우므로 캐시해 두고,
# fzf 바이너리가 갱신됐을 때만 다시 만든다.
if (( $+commands[fzf] )); then
  () {
    local cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}
    local cache=$cache_dir/fzf-init.zsh
    if [[ ! -s $cache || $commands[fzf] -nt $cache ]]; then
      [[ -d $cache_dir ]] || mkdir -p $cache_dir
      fzf --zsh >| $cache
    fi
    source $cache
  }

  # 히스토리 검색 결과를 세로 목록으로 크게 띄우고, 긴 명령은 Ctrl-/ 로 줄바꿈해 본다.
  export FZF_CTRL_R_OPTS="--height=60% --layout=reverse --border
    --preview 'echo {}' --preview-window=down:4:wrap:hidden
    --bind 'ctrl-/:toggle-preview'"
fi

# ---------------------------------------------------------------------------
# 4) zsh-syntax-highlighting — 명령어 유효성 색상 표시
# ---------------------------------------------------------------------------
# Homebrew 패키지가 caveats 에서 안내하는 값. 하이라이터 모듈 위치를 명시한다.
if [[ -d ${_ITERMS2_BREW_PREFIX:-}/share/zsh-syntax-highlighting/highlighters ]]; then
  export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$_ITERMS2_BREW_PREFIX/share/zsh-syntax-highlighting/highlighters
fi
_iterms2_source_plugin zsh-syntax-highlighting

# ---------------------------------------------------------------------------
# 5) zsh-history-substring-search — ↑↓ 부분 문자열 히스토리 검색
# ---------------------------------------------------------------------------
# 기본 강조색(bg=magenta)은 지나치게 튀어서 눈에 부담이 크므로 낮춘다.
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=cyan,fg=black'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white'
# 같은 결과가 연달아 나오지 않게 한다.
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
_iterms2_source_plugin zsh-history-substring-search

# ---------------------------------------------------------------------------
# 6) 키 바인딩
# ---------------------------------------------------------------------------
# omz 의 lib/key-bindings.zsh 는 ↑↓ 를 up/down-line-or-beginning-search(접두어 검색)에
# 걸어 둔다. 이를 부분 문자열 검색으로 교체하면 "100" 처럼 명령 중간의 조각만으로도
# 이전 명령을 찾을 수 있다.
if (( $+widgets[history-substring-search-up] )); then
  # 일반 커서 키 시퀀스와 애플리케이션 모드 시퀀스를 모두 처리한다.
  local -a _up_keys _down_keys
  _up_keys=('^[[A' '^[OA')
  _down_keys=('^[[B' '^[OB')
  [[ -n ${terminfo[kcuu1]:-} ]] && _up_keys+=("${terminfo[kcuu1]}")
  [[ -n ${terminfo[kcud1]:-} ]] && _down_keys+=("${terminfo[kcud1]}")

  # omz 가 emacs/viins/vicmd 세 키맵에 바인딩하므로 같은 범위를 덮어쓴다.
  local _keymap _key
  for _keymap in emacs viins vicmd; do
    for _key in $_up_keys;   do bindkey -M $_keymap $_key history-substring-search-up;   done
    for _key in $_down_keys; do bindkey -M $_keymap $_key history-substring-search-down; done
  done
  unset _keymap _key _up_keys _down_keys
fi

unfunction _iterms2_source_plugin
