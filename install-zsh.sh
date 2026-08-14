#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ADDITIONS_FILE="$SCRIPT_DIR/zsh/zshrc-additions.zsh"
ZSHRC="$HOME/.zshrc"
BACKUP_DIR="$HOME/.zshrc.backups"
MARKER_BEGIN="# >>> iterms2-config zsh additions >>>"
MARKER_END="# <<< iterms2-config zsh additions <<<"
PACKAGES=(zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search fzf)

skip_brew=0

usage() {
  printf '%s\n' \
    "사용법: ./install-zsh.sh [옵션]" \
    "" \
    "히스토리 자동완성(인라인 제안·부분 문자열 검색·퍼지 목록)을 설치합니다." \
    "" \
    "옵션:" \
    "  --skip-brew  Homebrew 패키지 설치를 건너뛰고 ~/.zshrc 설정만 적용" \
    "  --help       이 도움말 표시" \
    "" \
    "설치되는 패키지: ${PACKAGES[*]}"
}

for argument in "$@"; do
  case "$argument" in
    --skip-brew)
      skip_brew=1
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      printf '알 수 없는 옵션: %s\n\n' "$argument" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [ "$(uname -s)" != "Darwin" ]; then
  printf '%s\n' "이 스크립트는 macOS 전용입니다." >&2
  exit 1
fi

if [ ! -f "$ADDITIONS_FILE" ]; then
  printf '설정 파일을 찾을 수 없습니다: %s\n' "$ADDITIONS_FILE" >&2
  exit 1
fi

# Homebrew 패키지를 설치한다. 이미 설치돼 있으면 건너뛴다.
if [ "$skip_brew" -eq 1 ]; then
  printf '%s\n' "Homebrew 패키지 설치를 건너뜁니다."
else
  if ! command -v brew >/dev/null 2>&1; then
    printf '%s\n' \
      "Homebrew를 찾을 수 없어 필수 패키지를 설치하지 못했습니다." \
      "Homebrew를 설치한 뒤 이 스크립트를 다시 실행해 주세요." >&2
    exit 1
  fi

  for package in "${PACKAGES[@]}"; do
    if brew list --formula "$package" >/dev/null 2>&1; then
      printf '  이미 설치됨: %s\n' "$package"
    else
      printf '  설치 중: %s\n' "$package"
      brew install "$package"
    fi
  done
fi

# ~/.zshrc가 없으면 빈 파일로 만들어 이후 처리를 단순화한다.
if [ ! -f "$ZSHRC" ]; then
  printf '%s\n' "~/.zshrc가 없어 새로 만듭니다."
  : > "$ZSHRC"
fi

# 백업 이름은 목적별 접두어로 구분한다. 이름 순 정렬이 곧 시간 순 정렬이 되도록
# 접두어를 통일해야 --restore-latest가 올바른 파일을 고른다.
mkdir -p "$BACKUP_DIR"
timestamp="$(date '+%Y%m%d-%H%M%S')"
# PID를 붙여 같은 초에 두 번 실행해도 앞선 백업을 덮어쓰지 않게 한다.
backup_file="$BACKUP_DIR/zshrc.install-$timestamp-$$"
cp -p "$ZSHRC" "$backup_file"

# 기존 블록을 제거한 뒤 다시 넣는다. 여러 번 실행해도 블록은 하나만 남는다.
work_file="$(mktemp)"
trap 'rm -f "$work_file"' EXIT

awk -v begin="$MARKER_BEGIN" -v end="$MARKER_END" '
  $0 == begin { inside = 1; next }
  $0 == end   { inside = 0; next }
  !inside     { print }
' "$ZSHRC" > "$work_file"

# 블록 앞뒤로 빈 줄을 덧붙이지 않는다. 그래야 재설치를 반복해도 빈 줄이 쌓이지 않고,
# 제거할 때 마커 사이만 걷어내면 원본과 바이트 단위로 같아진다.
{
  printf '%s\n' "$MARKER_BEGIN"
  printf '%s\n' "[ -f \"$ADDITIONS_FILE\" ] && source \"$ADDITIONS_FILE\""
  printf '%s\n' "$MARKER_END"
} >> "$work_file"

# 문법이 깨진 파일을 홈에 남기지 않도록, 옮기기 전에 검증한다.
if ! zsh -n "$work_file" 2>/dev/null; then
  printf '%s\n' \
    "생성된 ~/.zshrc의 문법 검증에 실패해 적용을 중단했습니다." \
    "원본은 그대로 유지됩니다: $ZSHRC" >&2
  exit 1
fi

cat "$work_file" > "$ZSHRC"

printf '\n%s\n' "설치 완료"
printf '  설정 파일: %s\n' "$ADDITIONS_FILE"
printf '  백업: %s\n' "$backup_file"
# printf의 형식 문자열은 인자 개수만큼 반복 적용되므로, 줄 간격을 일정하게
# 유지하려면 앞머리 개행을 형식에 넣지 않고 따로 출력한다.
printf '\n'
printf '%s\n' \
  "새 셸에서 바로 쓰려면: exec zsh" \
  "" \
  "단축키" \
  "  →          회색으로 표시된 제안을 전체 수락" \
  "  ⌥→         제안을 한 단어만 수락" \
  "  ↑ ↓        입력한 문자열이 포함된 이전 명령 순회" \
  "  Ctrl-R     퍼지 검색 목록에서 고르기" \
  "  Ctrl-T     파일 경로 퍼지 검색" \
  "" \
  "되돌리려면: ./uninstall-zsh.sh"
