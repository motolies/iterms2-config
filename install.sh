#!/bin/bash

set -euo pipefail

DOMAIN="com.googlecode.iterm2"
PROFILE_GUID="E573C449-47C4-4039-B718-340AA7181093"
PROFILE_FILENAME="codex-developer-recommended.json"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SOURCE_PROFILE="$SCRIPT_DIR/profiles/developer-recommended.json"
DYNAMIC_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
TARGET_PROFILE="$DYNAMIC_DIR/$PROFILE_FILENAME"
BACKUP_ROOT="$HOME/Library/Application Support/iTerm2/RecommendedSettingsBackups"
FONT_CASK="font-jetbrains-mono-nerd-font"
FONT_FILE="$HOME/Library/Fonts/JetBrainsMonoNerdFontMono-Regular.ttf"
FONT_POSTSCRIPT_NAME="JetBrainsMonoNFM-Regular"
FONT_SIZE="14"

apply_globals=1
install_font=1

usage() {
  printf '%s\n' \
    "사용법: ./install.sh [옵션]" \
    "" \
    "옵션:" \
    "  --profile-only  Dynamic Profile만 설치하고 앱 전체 설정은 변경하지 않음" \
    "  --install-font  JetBrains Mono Nerd Font 설치(기본 동작, 호환용 옵션)" \
    "  --skip-font-install  Homebrew 설치는 건너뛰되 설치된 폰트는 반드시 확인" \
    "  --help          이 도움말 표시" \
    "" \
    "옵션을 주지 않아도 Homebrew로 JetBrains Mono Nerd Font를 설치합니다."
}

validate_json_plist() {
  plutil -convert xml1 -o /dev/null "$1"
}

for argument in "$@"; do
  case "$argument" in
    --profile-only)
      apply_globals=0
      ;;
    --install-font)
      install_font=1
      ;;
    --skip-font-install)
      install_font=0
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

if [ ! -f "$SOURCE_PROFILE" ]; then
  printf '프로필 파일을 찾을 수 없습니다: %s\n' "$SOURCE_PROFILE" >&2
  exit 1
fi

validate_json_plist "$SOURCE_PROFILE"

if [ "$install_font" -eq 1 ]; then
  if ! command -v brew >/dev/null 2>&1; then
    printf '%s\n' \
      "Homebrew를 찾을 수 없어 필수 폰트를 설치하지 못했습니다." \
      "Homebrew를 설치한 뒤 이 스크립트를 다시 실행해 주세요." >&2
    exit 1
  fi
  printf '%s\n' "JetBrains Mono Nerd Font를 설치하거나 최신 상태인지 확인합니다."
  brew install --cask "$FONT_CASK"
fi

if [ ! -f "$FONT_FILE" ]; then
  printf '%s\n' \
    "필수 폰트 파일을 찾을 수 없습니다:" \
    "  $FONT_FILE" \
    "" \
    "다음 명령으로 설치한 뒤 다시 실행해 주세요:" \
    "  brew install --cask $FONT_CASK" >&2
  exit 1
fi

if ! grep -aFq "$FONT_POSTSCRIPT_NAME" "$FONT_FILE"; then
  printf '%s\n' \
    "폰트 파일은 있지만 예상한 PostScript 이름을 확인하지 못했습니다:" \
    "  파일: $FONT_FILE" \
    "  예상 이름: $FONT_POSTSCRIPT_NAME" \
    "Homebrew 폰트 패키지를 다시 설치한 뒤 재시도해 주세요." >&2
  exit 1
fi

timestamp="$(date '+%Y%m%d-%H%M%S')"
backup_dir="$BACKUP_ROOT/$timestamp-$$"
mkdir -p "$backup_dir" "$DYNAMIC_DIR"

if defaults export "$DOMAIN" "$backup_dir/preferences.plist" >/dev/null 2>&1; then
  printf '%s\n' "1" > "$backup_dir/preferences-existed"
else
  printf '%s\n' "0" > "$backup_dir/preferences-existed"
fi

if [ -f "$TARGET_PROFILE" ]; then
  cp -p "$TARGET_PROFILE" "$backup_dir/previous-dynamic-profile.json"
  printf '%s\n' "1" > "$backup_dir/profile-existed"
else
  printf '%s\n' "0" > "$backup_dir/profile-existed"
fi

printf '%s\n' "$PROFILE_GUID" > "$backup_dir/profile-guid"
printf '%s\n' "$TARGET_PROFILE" > "$backup_dir/profile-target"

cp "$SOURCE_PROFILE" "$TARGET_PROFILE"
chmod 0644 "$TARGET_PROFILE"

plutil -replace 'Profiles.0.Normal Font' \
  -string "$FONT_POSTSCRIPT_NAME $FONT_SIZE" \
  "$TARGET_PROFILE"

installed_profile_font="$(plutil -extract 'Profiles.0.Normal Font' raw "$TARGET_PROFILE")"
if [ "$installed_profile_font" != "$FONT_POSTSCRIPT_NAME $FONT_SIZE" ]; then
  printf '프로필 폰트 적용 확인에 실패했습니다: %s\n' "$installed_profile_font" >&2
  exit 1
fi

validate_json_plist "$TARGET_PROFILE"

iterm_running=0
if pgrep -x iTerm2 >/dev/null 2>&1 || pgrep -x iTerm >/dev/null 2>&1; then
  iterm_running=1
fi

globals_applied=0
if [ "$apply_globals" -eq 1 ]; then
  if [ "$iterm_running" -eq 1 ]; then
    printf '%s\n' \
      "iTerm2가 실행 중이므로 앱 전체 설정은 변경하지 않았습니다." \
      "완전 적용하려면 iTerm2를 종료한 뒤 macOS Terminal에서 이 스크립트를 다시 실행하세요." >&2
  else
    defaults write "$DOMAIN" OnlyWhenMoreTabs -bool true
    defaults write "$DOMAIN" PromptOnQuit -bool true
    defaults write "$DOMAIN" QuitWhenAllWindowsClosed -bool false
    defaults write "$DOMAIN" SavePasteHistory -bool false
    globals_applied=1
  fi
fi
printf '%s\n' "$globals_applied" > "$backup_dir/globals-applied"

latest_link="$BACKUP_ROOT/latest"
if [ -L "$latest_link" ]; then
  unlink "$latest_link"
fi
if [ ! -e "$latest_link" ]; then
  ln -s "$backup_dir" "$latest_link"
else
  printf '주의: %s가 심볼릭 링크가 아니어서 latest 링크를 갱신하지 않았습니다.\n' "$latest_link" >&2
fi

printf '\n%s\n' "설치 완료"
printf '  Dynamic Profile: %s\n' "$TARGET_PROFILE"
printf '  폰트: %s %spt\n' "$FONT_POSTSCRIPT_NAME" "$FONT_SIZE"
printf '  백업: %s\n' "$backup_dir"
if [ "$globals_applied" -eq 1 ]; then
  printf '%s\n' "  앱 전체 설정: 종료 확인/창 종료 동작/기록 저장 설정 적용됨"
else
  printf '%s\n' "  앱 전체 설정: 변경하지 않음"
fi
printf '\n%s\n' \
  "iTerm2 → Settings → Profiles에서 “Developer Recommended”를 선택한 뒤," \
  "Other Actions → Set as Default를 눌러 기본 프로필로 지정하세요."
