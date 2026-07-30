#!/bin/bash

set -euo pipefail

DOMAIN="com.googlecode.iterm2"
base_dir="${1:-$PWD/exports}"
timestamp="$(date '+%Y%m%d-%H%M%S')"
export_dir="$base_dir/iterm2-export-$timestamp-$$"
dynamic_dir="$HOME/Library/Application Support/iTerm2/DynamicProfiles"

if [ "$(uname -s)" != "Darwin" ]; then
  printf '%s\n' "이 스크립트는 macOS 전용입니다." >&2
  exit 1
fi

mkdir -p "$export_dir"

if defaults export "$DOMAIN" "$export_dir/com.googlecode.iterm2.plist" >/dev/null 2>&1; then
  plutil -lint "$export_dir/com.googlecode.iterm2.plist" >/dev/null
else
  printf '%s\n' "iTerm2 Preferences를 찾지 못했습니다." >&2
fi

if [ -d "$dynamic_dir" ]; then
  ditto "$dynamic_dir" "$export_dir/DynamicProfiles"
fi

iterm_version="확인할 수 없음"
for app_path in "/Applications/iTerm.app" "$HOME/Applications/iTerm.app"; do
  if [ -f "$app_path/Contents/Info.plist" ]; then
    iterm_version="$(plutil -extract CFBundleShortVersionString raw "$app_path/Contents/Info.plist" 2>/dev/null || printf '%s' '확인할 수 없음')"
    break
  fi
done

{
  printf 'Exported: %s\n' "$(date)"
  printf 'iTerm2 version: %s\n' "$iterm_version"
  printf '%s\n' "Contents: macOS Preferences domain + DynamicProfiles"
  printf '%s\n' "Note: this is not the same as iTerm2's “Export All Settings and Data”."
} > "$export_dir/MANIFEST.txt"

printf '내보내기 완료: %s\n' "$export_dir"
printf '%s\n' "Keychain/보안 설정/셸 통합 파일까지 포함하려면 iTerm2의 “Export All Settings and Data”를 사용하세요."
