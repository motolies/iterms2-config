#!/bin/bash

set -euo pipefail

DOMAIN="com.googlecode.iterm2"
PROFILE_FILENAME="codex-developer-recommended.json"
DYNAMIC_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
TARGET_PROFILE="$DYNAMIC_DIR/$PROFILE_FILENAME"
BACKUP_ROOT="$HOME/Library/Application Support/iTerm2/RecommendedSettingsBackups"
REMOVED_ROOT="$HOME/Library/Application Support/iTerm2/RecommendedSettingsRemoved"

usage() {
  printf '%s\n' \
    "사용법: ./restore.sh [--backup 백업폴더]" \
    "" \
    "옵션이 없으면 RecommendedSettingsBackups/latest를 복구합니다." \
    "복구 전에 iTerm2를 완전히 종료하고 macOS Terminal에서 실행하세요."
}

validate_json_plist() {
  plutil -convert xml1 -o /dev/null "$1"
}

backup_dir=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --backup)
      if [ "$#" -lt 2 ]; then
        printf '%s\n' "--backup 뒤에 백업 폴더가 필요합니다." >&2
        exit 2
      fi
      backup_dir="$2"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      printf '알 수 없는 옵션: %s\n\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [ "$(uname -s)" != "Darwin" ]; then
  printf '%s\n' "이 스크립트는 macOS 전용입니다." >&2
  exit 1
fi

if pgrep -x iTerm2 >/dev/null 2>&1 || pgrep -x iTerm >/dev/null 2>&1; then
  printf '%s\n' \
    "iTerm2가 실행 중이어서 복구를 중단했습니다." \
    "iTerm2를 완전히 종료한 뒤 macOS Terminal에서 다시 실행하세요." >&2
  exit 1
fi

if [ -z "$backup_dir" ]; then
  backup_dir="$BACKUP_ROOT/latest"
fi

if [ ! -d "$backup_dir" ]; then
  printf '백업 폴더를 찾을 수 없습니다: %s\n' "$backup_dir" >&2
  exit 1
fi
backup_dir="$(cd "$backup_dir" && pwd -P)"

for metadata_file in preferences-existed profile-existed; do
  if [ ! -f "$backup_dir/$metadata_file" ]; then
    printf '올바른 백업이 아닙니다. 누락된 파일: %s\n' "$metadata_file" >&2
    exit 1
  fi
done

profile_existed="$(tr -d '[:space:]' < "$backup_dir/profile-existed")"
preferences_existed="$(tr -d '[:space:]' < "$backup_dir/preferences-existed")"

if [ "$profile_existed" = "1" ]; then
  previous_profile="$backup_dir/previous-dynamic-profile.json"
  if [ ! -f "$previous_profile" ]; then
    printf '기존 프로필 백업을 찾을 수 없습니다: %s\n' "$previous_profile" >&2
    exit 1
  fi
  validate_json_plist "$previous_profile"
fi

if [ "$preferences_existed" = "1" ]; then
  preferences_backup="$backup_dir/preferences.plist"
  if [ ! -f "$preferences_backup" ]; then
    printf 'Preferences 백업을 찾을 수 없습니다: %s\n' "$preferences_backup" >&2
    exit 1
  fi
  plutil -lint "$preferences_backup" >/dev/null
fi

mkdir -p "$DYNAMIC_DIR" "$REMOVED_ROOT"

if [ -f "$TARGET_PROFILE" ]; then
  recovery_file="$REMOVED_ROOT/$PROFILE_FILENAME.before-restore.$(date '+%Y%m%d-%H%M%S')-$$"
  mv "$TARGET_PROFILE" "$recovery_file"
  printf '현재 Dynamic Profile을 보관했습니다: %s\n' "$recovery_file"
fi

if [ "$profile_existed" = "1" ]; then
  cp -p "$previous_profile" "$TARGET_PROFILE"
  validate_json_plist "$TARGET_PROFILE"
fi

if [ "$preferences_existed" = "1" ]; then
  defaults import "$DOMAIN" "$preferences_backup"
else
  defaults delete "$DOMAIN" >/dev/null 2>&1 || true
fi

printf '\n%s\n' "복구 완료"
printf '  사용한 백업: %s\n' "$backup_dir"
printf '%s\n' "iTerm2를 다시 실행해 결과를 확인하세요."
