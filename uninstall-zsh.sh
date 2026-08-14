#!/bin/bash

set -euo pipefail

ZSHRC="$HOME/.zshrc"
BACKUP_DIR="$HOME/.zshrc.backups"
MARKER_BEGIN="# >>> iterms2-config zsh additions >>>"
MARKER_END="# <<< iterms2-config zsh additions <<<"
PACKAGES=(zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)
FZF_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/fzf-init.zsh"

purge=0
restore_latest=0

usage() {
  printf '%s\n' \
    "사용법: ./uninstall-zsh.sh [옵션]" \
    "" \
    "~/.zshrc에서 히스토리 자동완성 설정 블록을 제거합니다." \
    "" \
    "옵션:" \
    "  --purge           Homebrew 패키지(${PACKAGES[*]})도 함께 제거" \
    "  --restore-latest  블록 제거 대신 최신 백업으로 ~/.zshrc 전체를 복구" \
    "  --help            이 도움말 표시" \
    "" \
    "fzf는 다른 용도로도 쓰이므로 --purge에서도 제거하지 않습니다."
}

for argument in "$@"; do
  case "$argument" in
    --purge)
      purge=1
      ;;
    --restore-latest)
      restore_latest=1
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

if [ "$restore_latest" -eq 1 ] && [ "$purge" -eq 1 ]; then
  printf '%s\n' "--restore-latest와 --purge는 함께 사용할 수 없습니다." >&2
  exit 2
fi

if [ ! -f "$ZSHRC" ]; then
  printf '~/.zshrc가 없습니다: %s\n' "$ZSHRC" >&2
  exit 1
fi

mkdir -p "$BACKUP_DIR"
timestamp="$(date '+%Y%m%d-%H%M%S')"

# 최신 백업으로 통째 복구한다. 되돌리기 전 현재 상태도 따로 남긴다.
# 대상은 설치 직전 백업(zshrc.install-*)으로 한정한다. uninstall/restore 백업은
# 설정 블록이 들어 있는 상태일 수 있어 복구 대상으로 적절하지 않다.
if [ "$restore_latest" -eq 1 ]; then
  latest_backup="$(find "$BACKUP_DIR" -maxdepth 1 -name 'zshrc.install-*' -type f 2>/dev/null | sort | tail -n 1)"
  if [ -z "$latest_backup" ]; then
    printf '%s\n' \
      "복구할 설치 전 백업이 없습니다: $BACKUP_DIR/zshrc.install-*" \
      "설정 블록만 제거하려면 옵션 없이 실행하세요: ./uninstall-zsh.sh" >&2
    exit 1
  fi

  if ! zsh -n "$latest_backup" 2>/dev/null; then
    printf '백업 파일의 문법 검증에 실패해 복구를 중단했습니다: %s\n' "$latest_backup" >&2
    exit 1
  fi

  cp -p "$ZSHRC" "$BACKUP_DIR/zshrc.restore-$timestamp-$$"
  cat "$latest_backup" > "$ZSHRC"
  printf '%s\n' "복구 완료"
  printf '  복구에 사용한 백업: %s\n' "$latest_backup"
  printf '  복구 직전 상태 보관: %s\n' "$BACKUP_DIR/zshrc.restore-$timestamp-$$"
  printf '\n%s\n' "새 셸에 반영하려면: exec zsh"
  exit 0

fi

if ! grep -Fqx "$MARKER_BEGIN" "$ZSHRC"; then
  printf '%s\n' "~/.zshrc에 설치된 설정 블록이 없습니다. 변경하지 않았습니다."
else
  backup_file="$BACKUP_DIR/zshrc.uninstall-$timestamp-$$"
  cp -p "$ZSHRC" "$backup_file"

  work_file="$(mktemp)"
  trap 'rm -f "$work_file"' EXIT

  awk -v begin="$MARKER_BEGIN" -v end="$MARKER_END" '
    $0 == begin { inside = 1; next }
    $0 == end   { inside = 0; next }
    !inside     { print }
  ' "$ZSHRC" > "$work_file"

  # install-zsh.sh가 블록 앞뒤에 빈 줄을 넣지 않으므로, 마커 사이만 걷어내면
  # 설치 전 파일과 바이트 단위로 같아진다. 별도 정리가 필요 없다.
  if ! zsh -n "$work_file" 2>/dev/null; then
    printf '%s\n' \
      "생성된 ~/.zshrc의 문법 검증에 실패해 제거를 중단했습니다." \
      "원본은 그대로 유지됩니다: $ZSHRC" >&2
    exit 1
  fi

  cat "$work_file" > "$ZSHRC"
  printf '%s\n' "설정 블록을 제거했습니다."
  printf '  백업: %s\n' "$backup_file"
fi

# fzf 셸 통합 캐시는 설정 파일이 만든 부산물이므로 함께 지운다.
if [ -f "$FZF_CACHE" ]; then
  rm -f "$FZF_CACHE"
  printf '  fzf 캐시 삭제: %s\n' "$FZF_CACHE"
fi

if [ "$purge" -eq 1 ]; then
  if ! command -v brew >/dev/null 2>&1; then
    printf '%s\n' "Homebrew를 찾을 수 없어 패키지는 제거하지 못했습니다." >&2
  else
    for package in "${PACKAGES[@]}"; do
      if brew list --formula "$package" >/dev/null 2>&1; then
        printf '  제거 중: %s\n' "$package"
        brew uninstall "$package"
      fi
    done
  fi
fi

printf '\n'
printf '%s\n' \
  "새 셸에 반영하려면: exec zsh" \
  "↑ 키는 oh-my-zsh 기본 동작(접두어 검색)으로 돌아갑니다."
