# iTerm2 개발용 권장 설정 묶음

이 묶음은 기존 색상과 개인 설정을 최대한 보존하면서 `Developer Recommended`라는 Dynamic Profile을 추가합니다. 앱 전체에 적용되는 종료 확인과 기록 저장 설정은 설치 전 Preferences를 백업한 뒤 별도로 적용합니다.

## 가장 안전하게 설치하기

1. iTerm2를 완전히 종료합니다.
2. macOS 기본 **Terminal** 앱을 엽니다.
3. 이 폴더로 이동해 설치 스크립트를 실행합니다.

   ```sh
   ./install.sh
   ```

4. iTerm2를 다시 열고 **Settings → Profiles**에서 `Developer Recommended`를 선택합니다.
5. 프로필 목록 아래 **Other Actions → Set as Default**를 눌러 기본 프로필로 지정합니다.
6. 새 탭을 열어 폰트, 상태바, Option 키를 확인합니다.

iTerm2 안에서 스크립트를 실행해도 Dynamic Profile은 설치됩니다. 다만 실행 중인 iTerm2가 종료 시 기존 Preferences를 다시 저장할 수 있으므로, 이 경우 앱 전체 설정은 자동으로 건너뜁니다. 새로 설치된 폰트를 확실히 인식시키려면 설치 후 iTerm2를 완전히 종료했다가 다시 여세요.

`./install.sh`는 옵션을 주지 않아도 Homebrew로 JetBrains Mono Nerd Font를 반드시 설치하거나 이미 설치된 패키지를 확인합니다.

```sh
brew install --cask font-jetbrains-mono-nerd-font
```

Homebrew가 없거나 폰트 설치가 실패하면 프로필을 복사하기 전에 설치를 중단합니다. `--install-font`는 이전 사용법과의 호환을 위해 남아 있지만 이제 기본 동작과 같습니다. 폰트가 이미 수동 설치되어 있고 Homebrew 실행만 건너뛰고 싶다면 `--skip-font-install`을 사용할 수 있으며, 이 경우에도 정확한 폰트 파일과
PostScript 이름을 확인하지 못하면 설치를 중단합니다.

Dynamic Profile만 추가하고 앱 전체 설정은 바꾸지 않으려면 다음을 사용합니다. 이 경우에도 폰트 설치와 확인은 기본적으로 수행합니다.

```sh
./install.sh --profile-only
```

## 적용되는 값

Dynamic Profile에는 다음 값이 들어 있습니다.

- Command: 로그인 셸
- 새 세션의 디렉터리: 현재 세션 디렉터리 재사용
- 새 창의 기본 크기: 200 columns × 50 rows
- Shell Integration 자동 로드: 켜기
- 폰트: JetBrains Mono Nerd Font Mono 14pt
    - iTerm2 프로필 값: `JetBrainsMonoNFM-Regular 14`
- 안티앨리어싱: 켜기
- 내장 Powerline 글리프: 켜기
- 얇은 획: 사용 안 함
- 리가처: ASCII/Non-ASCII 모두 끄기
- 커서: 세로 막대, 깜빡임 끄기
- 스크롤백: 100,000줄, 무제한 끄기
- Alternate Screen의 스크롤백 저장: 켜기
- 왼쪽 Option: `Esc+`
- 오른쪽 Option: `Normal`
- 상태바: 호스트 이름, 현재 디렉터리, Git 상태

설치 시 iTerm2가 종료되어 있으면 다음 앱 전체 설정도 적용합니다.

- 여러 세션을 닫을 때 확인: 켜기
- `⌘Q`로 종료할 때 확인: 켜기
- 모든 창을 닫아도 iTerm2 자동 종료하지 않기
- 복사/붙여넣기 및 명령 기록을 디스크에 저장하지 않기
- 상태바 위치: 아래쪽

Hotkey Window는 단축키 충돌과 화면 배치가 개인마다 달라 자동 생성하지 않습니다. 필요하면 **Settings → Keys → Hotkey → Create a Dedicated Hotkey Window**에서 직접 추가하는 편이 안전합니다.

## 상태바 항목 선택하기

상태바의 표시 여부와 구성 요소는 프로필 설정이고, 위·아래 위치는 앱 전체 설정입니다. 이 묶음은 상태바를 켜고 아래쪽에 배치하며, 시작 구성을 `Host Name`, `Current Directory`, `Git State` 순서로 제공합니다.

표시 항목은 다음 위치에서 자유롭게 바꿀 수 있습니다.

1. **Settings → Profiles → Developer Recommended → Session**
2. **Status bar enabled**가 켜져 있는지 확인
3. **Configure Status Bar** 선택
4. 위쪽 목록에서 원하는 항목을 아래 **Active Components** 영역으로 드래그
5. 제거할 항목은 선택하고 Delete/Backspace를 누르거나 Active Components 밖으로 드래그

위치를 직접 확인하거나 바꾸려면 **Settings → Appearance → General → Status Bar Location → Bottom**을 사용하세요. 이 값은 프로필별이 아니라 모든 iTerm2 창에 적용됩니다. 설치 중 iTerm2가 실행 중이면 앱 전체 설정을 건너뛰므로, 이 경우 iTerm2를 종료하고 macOS Terminal에서
`./install.sh`를 다시 실행하거나 UI에서 직접 `Bottom`을 선택해야 합니다.

기본 제공 항목과 용도는 다음과 같습니다.

| 항목                                     | 보여주는 정보                           | 추천                                                        |
|------------------------------------------|-----------------------------------------|-------------------------------------------------------------|
| Current Directory                        | 현재 작업 디렉터리                      | 항상 유용. 긴 경로가 공간을 많이 차지할 수 있음             |
| Git State                                | 브랜치, 변경 여부, 원격보다 앞섬/뒤처짐 | Git 개발 시 가장 유용                                       |
| Host Name                                | 현재 호스트 이름                        | SSH로 여러 서버를 오갈 때 유용                              |
| User Name                                | 현재 사용자 이름                        | 서로 다른 계정이나 `root` 작업을 구분할 때 유용             |
| Job Name                                 | 현재 포그라운드 명령과 상위 프로세스    | 빌드, 서버, SSH 세션 구분에 유용                            |
| Clock                                    | 날짜와 시간                             | 전체 화면 작업에는 유용하지만 macOS 메뉴 막대가 보이면 중복 |
| CPU Utilization                          | CPU 사용률 그래프                       | 장시간 빌드나 로컬 서버 관찰 시 유용                        |
| Memory Utilization                       | 메모리 사용률 그래프                    | 메모리 사용이 큰 개발 작업에 유용                           |
| Network Throughput                       | 업로드/다운로드 그래프                  | 전송 작업 관찰에는 유용하지만 세션별 트래픽은 아님          |
| Composer                                 | 명령을 편집한 뒤 셸로 전송하는 입력란   | 긴 명령을 자주 작성할 때 유용하나 공간을 많이 사용          |
| Search Tool                              | 터미널 기록 검색 입력란                 | 마우스로 검색을 자주 시작할 때 유용                         |
| Interpolated String                      | iTerm2 변수를 조합한 사용자 정의 문자열 | 원하는 값이 기본 항목에 없을 때 사용                        |
| Call Script Function                     | Python API 함수 실행 결과               | iTerm2 Python API 자동화를 사용하는 경우에만 권장           |
| Empty Space / Fixed-size Spacer / Spring | 항목 사이의 여백과 정렬                 | 정보 항목이 아니라 레이아웃 조절용                          |

개발용으로는 다음 조합부터 시작하는 것을 권장합니다.

- 로컬 개발 위주: `Current Directory + Git State + Job Name`
- SSH/서버 작업 포함: `Host Name + User Name + Current Directory + Git State + Job Name`
- 빌드와 서버 자원 확인: 위 조합에 `CPU Utilization + Memory Utilization`

`Current Directory`, `Host Name`, `User Name`, `Git State`의 정확도는 Shell Integration의 영향을 받습니다. 특히 SSH 접속 후 값이 갱신되지 않는다면 원격 셸에도 iTerm2 Shell Integration이 동작하는지 확인하세요.

이 Dynamic Profile은 `Rewritable`이므로 지원하는 iTerm2 버전에서는 UI에서 바꾼 상태바 구성이 설치된 다음 파일에 반영됩니다.

```text
~/Library/Application Support/iTerm2/DynamicProfiles/codex-developer-recommended.json
```

선택한 구성을 이 Git 저장소의 기준 프로필에도 저장하려면 iTerm2를 정상 종료한 뒤 다음처럼 복사하고 변경 내용을 검토해 커밋하세요.

```sh
cp "$HOME/Library/Application Support/iTerm2/DynamicProfiles/codex-developer-recommended.json" \
  profiles/developer-recommended.json
plutil -convert xml1 -o /dev/null profiles/developer-recommended.json
git diff -- profiles/developer-recommended.json
```

설치 스크립트를 다시 실행하면 저장소의 기준 프로필이 설치 위치에 다시 복사됩니다. 따라서 UI에서 고른 구성을 계속 유지하려면 위와 같이 저장소로 되가져온 뒤 재설치하세요.

## 기본 프로필 지정 상태까지 저장하기

**Other Actions → Set as Default**로 지정한 결과는 Dynamic Profile JSON 안에 저장되는 값이 아닙니다. 기본 프로필의 `Guid`가 iTerm2 앱 전체 Preferences의 `Default Bookmark Guid`에 저장됩니다. 따라서 `developer-recommended.json`만 다른 Mac으로
복사하면 프로필은 나타나지만 기본 프로필 지정 상태는 함께 이동하지 않습니다.

가장 확실한 저장 방법은 다음과 같습니다.

1. **Settings → Profiles**에서 `Developer Recommended`를 선택합니다.
2. **Other Actions → Set as Default**를 누릅니다.
3. 새 창을 열어 `Developer Recommended`가 선택되는지 확인합니다.
4. **Settings → General → Settings → Export All Settings and Data**를 실행합니다.

복원할 때는 같은 화면의 **Import All Settings and Data**를 사용합니다. 전체 export에는 Dynamic Profiles와 기본 프로필 선택을 포함한 Settings가 함께 들어가므로 새 Mac으로 옮길 때 가장 안전합니다.

커스텀 설정 폴더를 사용한다면 **Load settings from a custom folder or URL**과 **Save changes to folder when iTerm2 quits**를 켠 뒤 iTerm2를 정상 종료하세요. 기본 프로필의 `Guid`도 해당 폴더의 `com.googlecode.iterm2.plist`에 저장됩니다.

이 묶음의 명령줄 내보내기를 사용할 수도 있습니다. 기본 프로필로 지정한 뒤 iTerm2를 완전히 종료하고 실행하세요.

```sh
./export-preferences.sh
```

결과 폴더의 `com.googlecode.iterm2.plist`에는 기본 프로필 선택이 들어 있고, `DynamicProfiles` 폴더에는 실제 프로필 정의가 들어 있습니다. 두 항목을 함께 보관해야 합니다. 현재 저장된 기본 프로필의 `Guid`는 다음 명령으로 확인할 수 있습니다.

```sh
defaults read com.googlecode.iterm2 "Default Bookmark Guid"
```

정상적으로 지정됐다면 이 묶음의 프로필 `Guid`인 다음 값이 출력됩니다.

```text
E573C449-47C4-4039-B718-340AA7181093
```

Dynamic Profile JSON에 `"Default Bookmark": "Yes"`를 직접 추가하는 방식은 사용하지 마세요. Dynamic Profile 파일이 앱의 기본 프로필을 강제로 바꾸지 않도록 iTerm2가 이 속성을 별도로 처리하므로, UI에서 지정한 뒤 앱 전체 Preferences를 함께 저장해야 합니다.

200×50은 새 창을 만들 때 사용하는 프로필의 기본 크기입니다. macOS/iTerm2의 창 복원 기능으로 기존 창을 되살리는 경우에는 마지막 창 크기가 우선할 수 있습니다.

## iTerm2가 파일을 로드하는 위치

Dynamic Profile의 공식 로드 위치는 다음과 같습니다.

```text
~/Library/Application Support/iTerm2/DynamicProfiles/
```

설치 스크립트는 이 묶음의 `profiles/developer-recommended.json`을 아래 이름으로 복사합니다.

```text
~/Library/Application Support/iTerm2/DynamicProfiles/codex-developer-recommended.json
```

iTerm2는 실행 중에도 이 폴더를 감시하므로 정상적인 파일은 자동으로 다시 읽습니다. **Import JSON Profiles** 버튼을 누를 필요가 없습니다. 이 버튼은 일반 프로필로 복사해 가져오는 기능이고, Dynamic Profile 자동 로드와는 다른 방식입니다.

Dynamic Profile 폴더 안에 잘못된 plist/JSON 파일이 하나라도 있으면 변경 사항이 로드되지 않을 수 있습니다. 문제가 생기면 JSON을 다음처럼 확인하고, macOS **Console** 앱에서 iTerm2 오류를 확인하세요.

```sh
plutil -convert xml1 -o /dev/null profiles/developer-recommended.json
```

`plutil -lint`는 일부 최신 macOS에서도 JSON plist를 직접 검사하지 못하므로 위처럼 변환 검사를 사용합니다.

## 다시 export하는 방법

### 이 프로필 하나만 JSON으로 저장

1. **Settings → Profiles**
2. `Developer Recommended` 선택
3. 프로필 목록 아래 **Other Actions**
4. **Save Profile as JSON**

저장된 파일은 일반적으로 프로필 하나의 JSON 객체입니다. 다시 Dynamic Profile로 배포하려면 이 묶음처럼 최상위에 `{"Profiles": [...]}` 구조가 필요하고, 다른 일반 프로필과 겹치지 않는 `Guid`를 사용해야 합니다.

이 Dynamic Profile은 `Rewritable`로 설정되어 있어, 지원하는 iTerm2 버전에서는 Settings UI에서 바꾼 값이 설치된 Dynamic Profile 파일에 반영될 수 있습니다. 중요한 변경 전에는 아래 전체 내보내기나 설치 스크립트의 백업을 남겨 두세요.

### 모든 Settings와 데이터를 내보내기 — 권장

최신 iTerm2에서는 다음 위치를 사용합니다.

1. **Settings → General → Settings**
2. **Export All Settings and Data**

이 방식은 Settings 창의 값뿐 아니라 Dynamic Profiles, Shell Integration 관련 파일, Python API 스크립트와 런타임, 보안 사용자 기본값 등도 함께 보관하는 공식 이동/복구 방식입니다. 가져올 때는 같은 화면의 **Import All Settings and Data**를 사용합니다.

버전에 따라 탭 이름이 **Preferences**로 보이거나 버튼 위치가 조금 다를 수 있습니다. 이 경우 **General** 안에서 `Export/Import All Settings and Data` 또는 `Load preferences/settings from a custom folder`를 찾으세요.

### 설정 폴더를 지정해 계속 동기화

**Settings → General → Settings**에서 다음 두 항목을 사용할 수 있습니다.

- **Load settings from a custom folder or URL**
- **Save changes to folder when iTerm2 quits**

첫 항목으로 로드할 폴더를 지정하고, 두 번째 항목을 켜면 종료 시 변경 사항을 그 폴더에 씁니다. 여러 Mac이 같은 동기화 폴더에 동시에 쓰면 마지막 종료 앱의 설정이 이길 수 있으므로 한 번에 한 기기에서 편집하는 것이 안전합니다.

### 명령줄에서 간단히 내보내기

다음 스크립트는 macOS Preferences 도메인과 DynamicProfiles 폴더를 현재 폴더 아래 `exports`에 복사합니다.

```sh
./export-preferences.sh
```

다른 상위 폴더를 지정할 수도 있습니다.

```sh
./export-preferences.sh "$HOME/Desktop"
```

이 스크립트의 결과는 iTerm2 UI의 **Export All Settings and Data**보다 범위가 좁습니다. Keychain/보안 설정, `~/.iterm2`, 기타 Application Support 데이터까지 옮기려면 UI의 공식 전체 내보내기를 사용하세요. 내보낸 Preferences에는 호스트 이름이나 개인 경로 같은 정보가 들어 있을
수 있으므로 공개 저장소에 올리기 전에 확인하세요.

## 복구와 삭제

설치할 때마다 다음 위치에 설치 직전 Preferences와 기존 동일 이름 Dynamic Profile을 백업합니다.

```text
~/Library/Application Support/iTerm2/RecommendedSettingsBackups/
```

가장 최근 백업으로 완전히 복구하려면 iTerm2를 종료하고 macOS Terminal에서 실행합니다.

```sh
./restore.sh
```

특정 백업을 고르려면 다음처럼 지정합니다.

```sh
./restore.sh --backup "/전체/경로/RecommendedSettingsBackups/날짜-번호"
```

`restore.sh`는 전체 Preferences 스냅샷을 되돌리므로, 설치 이후 iTerm2에서 바꾼 다른 설정도 함께 되돌아갑니다. 현재 Dynamic Profile은 바로 삭제하지 않고 `RecommendedSettingsRemoved` 폴더에 보관합니다.

Dynamic Profile만 제거하고 종료 확인 등의 앱 전체 설정은 유지하려면 다음을 실행합니다.

```sh
./uninstall.sh
```

파일을 보관하지 않고 Dynamic Profile만 영구 삭제하려면 명시적으로 다음을 사용합니다.

```sh
./uninstall.sh --purge
```

Dynamic Profile과 앱 전체 설정을 최신 설치 전 상태로 함께 되돌리려면 iTerm2를 종료한 뒤 실행합니다.

```sh
./uninstall.sh --restore-latest
```

설치 스크립트가 설치한 폰트는 다른 앱이나 프로필에서도 사용할 수 있으므로 복구/삭제 스크립트가 제거하지 않습니다.

## 버전별 차이와 확인 사항

- Dynamic Profiles는 iTerm2 2.9 계열 이후에서 사용할 수 있습니다.
- **Load shell integration automatically**는 iTerm2 3.5 이상에서 지원됩니다. 더 오래된 버전에서는 **iTerm2 → Install Shell Integration**을 사용하거나 현재 버전의 Profiles → General 안내를 따르세요.
- 상태바의 JSON 내부 구조는 공개 UI 이름보다 버전 영향을 더 받을 수 있습니다. 구성 요소가 보이지 않으면 **Settings → Profiles → Session → Configure Status Bar**에서 Current Directory, Git State, Host Name, Job Name을 직접 다시 추가하세요.
- 설치 스크립트는 Homebrew의 `font-jetbrains-mono-nerd-font` 패키지에 포함된 `JetBrainsMonoNerdFontMono-Regular.ttf`를 확인하고, iTerm2 프로필에 정확한 PostScript 이름인 `JetBrainsMonoNFM-Regular 14`를 강제로 기록합니다. 폰트가 보이지 않으면
  iTerm2를 완전히 종료했다가 다시 실행하고 **Settings → Profiles → Text**에서 값이 `JetBrainsMono Nerd Font Mono Regular 14`로 표시되는지 확인하세요.
- 한글 모양이 마음에 들지 않으면 **Settings → Profiles → Text**에서 Non-ASCII용 별도 폰트를 켜고 D2Coding 14pt를 지정하세요. D2Coding 설치 여부와 내부 폰트 이름이 배포판마다 달라 자동 적용하지 않았습니다.
- Git/원격 호스트/디렉터리 상태 표시가 비어 있으면 새 세션에서 Shell Integration이 동작하는지 먼저 확인하세요. 일반적인 로컬 로그인 셸에서는 이 프로필이 자동 로드를 요청합니다.

## 공식 문서

- Dynamic Profiles: <https://iterm2.com/documentation-dynamic-profiles.html>
- General Settings 및 전체 export/import: <https://iterm2.com/documentation-preferences-general.html>
- Shell Integration: <https://iterm2.com/documentation-shell-integration.html>
- Text/Font 설정: <https://iterm2.com/documentation-preferences-profiles-text.html>
- Terminal/Scrollback 설정: <https://iterm2.com/documentation-preferences-profiles-terminal.html>
