#!/bin/bash

set -euo pipefail

PROFILE_FILENAME="codex-developer-recommended.json"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
TARGET_PROFILE="$HOME/Library/Application Support/iTerm2/DynamicProfiles/$PROFILE_FILENAME"
REMOVED_ROOT="$HOME/Library/Application Support/iTerm2/RecommendedSettingsRemoved"

restore_latest=0
purge=0

usage() {
  printf '%s\n' \
    "사용법: ./uninstall.sh [옵션]" \
    "" \
    "옵션:" \
    "  --restore-latest  최신 설치 전 백업으로 Dynamic Profile과 Preferences 모두 복구" \
    "  --purge           Dynamic Profile 파일을 보관하지 않고 영구 삭제" \
    "  --help            이 도움말 표시"
}

for argument in "$@"; do
  case "$argument" in
    --restore-latest)
      restore_latest=1
      ;;
    --purge)
      purge=1
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

if [ "$restore_latest" -eq 1 ]; then
  exec "$SCRIPT_DIR/restore.sh"
fi

if [ ! -f "$TARGET_PROFILE" ]; then
  printf '설치된 Dynamic Profile이 없습니다: %s\n' "$TARGET_PROFILE"
  exit 0
fi

if [ "$purge" -eq 1 ]; then
  unlink "$TARGET_PROFILE"
  printf 'Dynamic Profile을 영구 삭제했습니다: %s\n' "$TARGET_PROFILE"
else
  mkdir -p "$REMOVED_ROOT"
  removed_file="$REMOVED_ROOT/$PROFILE_FILENAME.$(date '+%Y%m%d-%H%M%S')-$$"
  mv "$TARGET_PROFILE" "$removed_file"
  printf 'Dynamic Profile을 제거하고 복구 가능하게 보관했습니다: %s\n' "$removed_file"
fi

printf '%s\n' \
  "앱 전체 종료/기록 설정은 그대로 유지됩니다." \
  "설치 전 상태까지 되돌리려면 iTerm2를 종료한 뒤 ./restore.sh 를 실행하세요."
