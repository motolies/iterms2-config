# iTerm2 개발용 권장 설정 묶음

이 묶음은 기존 색상과 개인 설정을 최대한 보존하면서 `Developer Recommended`라는 Dynamic Profile을 추가합니다. 앱 전체에 적용되는 종료 확인과 기록 저장 설정은 설치 전 Preferences를 백업한 뒤 별도로 적용합니다.

터미널 설정은 `./install.sh`, 셸 쪽 히스토리 자동완성은 `./install-zsh.sh`로 나뉘어 있습니다. 두 스크립트는 서로 독립적이라 필요한 쪽만 설치해도 됩니다. 자세한 내용은 [히스토리 자동완성](#히스토리-자동완성)을 보세요.

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
- 폰트: JetBrains Mono Nerd Font Mono 13pt
    - iTerm2 프로필 값: `JetBrainsMonoNFM-Regular 13`
- 안티앨리어싱: 켜기
- 내장 Powerline 글리프: 켜기
- 얇은 획: 사용 안 함
- 리가처: ASCII/Non-ASCII 모두 끄기
- 커서: 세로 막대, 깜빡임 끄기
- 스크롤백: 100,000줄, 무제한 끄기
- Alternate Screen의 스크롤백 저장: 켜기
- 왼쪽 Option: `Esc+`
- 오른쪽 Option: `Normal`
- 단어 단위 이동·줄 편집 키 매핑: `⌥←`/`⌥→`, `⌥⌫`, `⌘←`/`⌘→`, `⌘⌫` (아래 표 참고)
- 상태바: 호스트 이름, 현재 디렉터리, Git 상태

설치 시 iTerm2가 종료되어 있으면 다음 앱 전체 설정도 적용합니다.

- 여러 세션을 닫을 때 확인: 켜기
- `⌘Q`로 종료할 때 확인: 켜기
- 모든 창을 닫아도 iTerm2 자동 종료하지 않기
- 복사/붙여넣기 및 명령 기록을 디스크에 저장하지 않기
- 상태바 위치: 아래쪽

Hotkey Window는 단축키 충돌과 화면 배치가 개인마다 달라 자동 생성하지 않습니다. 필요하면 **Settings → Keys → Hotkey → Create a Dedicated Hotkey Window**에서 직접 추가하는 편이 안전합니다.

## 단어 단위 이동과 줄 편집 단축키

macOS의 다른 텍스트 입력란처럼 `⌥←`/`⌥→`로 단어를 건너뛰고, `⌘←`/`⌘→`로 줄 처음과 끝으로 이동하는 매핑이 프로필에 들어 있습니다.

| 키                | 동작                    | iTerm2가 보내는 값 | 셸 동작(zsh/bash 공통) |
|-------------------|-------------------------|--------------------|------------------------|
| `⌥←`              | 한 단어 왼쪽으로 이동   | `ESC b`            | `backward-word`        |
| `⌥→`              | 한 단어 오른쪽으로 이동 | `ESC f`            | `forward-word`         |
| `⌥⌫`              | 커서 앞 단어 삭제       | `ESC DEL`          | `backward-kill-word`   |
| `⌥`+`fn`+`Delete` | 커서 뒤 단어 삭제       | `ESC d`            | `kill-word`            |
| `⌘←`              | 줄 처음으로 이동        | `0x01` (`^A`)      | `beginning-of-line`    |
| `⌘→`              | 줄 끝으로 이동          | `0x05` (`^E`)      | `end-of-line`          |
| `⌘⌫`              | 줄 전체 삭제            | `0x15` (`^U`)      | `kill-whole-line`      |

### 왜 셸 설정이 아니라 iTerm2 키 매핑인가

왼쪽 Option이 `Esc+`이므로 `⌥b`/`⌥f`는 원래부터 단어 이동이 됩니다. 하지만 `⌥←`는 `^[^[[D`라는 시퀀스를 보내는데, zsh (zle)와 bash (readline) 어느 쪽에도 이 시퀀스의 기본 바인딩이 없어 아무 일도 일어나지 않습니다.

```bash
zsh -i -c 'bindkey "\eb"; bindkey "\e\e[D"'
# "^[b"    backward-word   ← ⌥b 는 동작
# "^[^[[D" undefined-key   ← ⌥← 는 정의 없음
```

그래서 `~/.zshrc`에 `bindkey`를 추가하는 대신, iTerm2 단계에서 `⌥←`를 아예 `ESC b`로 바꿔 보냅니다. `ESC b`/`ESC f`는 zle와 readline 양쪽의 표준 바인딩이라, **SSH로 접속한 원격 서버나 Docker 컨테이너에서도 그대로 동작합니다.** 셸 설정 파일을 고치는 방식은 그 파일이 있는 로컬 셸에만
적용됩니다.

이 매핑은 iTerm2가 앱 번들에 담아 배포하는 **Natural Text Editing** 프리셋 (`/Applications/iTerm.app/Contents/Resources/PresetKeyMappings.plist`)과 동일한 값이며, 프로필 키 매핑은 `Option Key Sends` 설정보다 우선 적용되므로 기존 `Esc+` 설정과 충돌하지
않습니다. 좌우 어느 Option 키를 눌러도 동작하므로, 오른쪽 Option의 악센트 문자 입력 (`Normal`)도 그대로 유지됩니다.

### 공식 프리셋과 다른 점 한 가지

Natural Text Editing 프리셋에는 수식키 없는 `fn`+`Delete`를 `0x04`(`^D`)로 보내는 항목이 하나 더 있는데, **이 묶음에서는 일부러 제외했습니다.** `^D`는 셸 밖에서 EOF 신호라 `cat`, Python REPL, `docker run -it` 같은 상황에서 프로그램이 종료됩니다. 제외하면 iTerm2 기본값
`^[[3~`가 유지되고 zsh에서 `delete-char`로 정상 동작하므로 더 안전하고 정확합니다.

### GUI에서 확인하고 바꾸기

1. **Settings → Profiles → Developer Recommended → Keys → Key Mappings**에서 위 7개 항목을 확인할 수 있습니다.
2. **Presets...** 버튼 → **Natural Text Editing**을 누르면 iTerm2 원본 프리셋 (`fn`+`Delete` 포함 8개)으로 덮어씁니다.
3. 이 프로필은 `Rewritable`이 켜져 있어 GUI에서 바꾼 내용이 Dynamic Profile 파일에 다시 기록됩니다. 저장소에 반영하려면 `./export-preferences.sh`로 내보낸 뒤 `profiles/developer-recommended.json`의 `Keyboard Map`에 옮기세요.

## 히스토리 자동완성

이전에 실행한 명령을 다시 쓸 때 전체를 다시 타이핑하지 않도록, zsh 쪽에 세 가지 보조 수단을 얹습니다. 앞 절의 키 매핑이 iTerm2가 보내는 **바이트**를 다루는 것과 달리, 이 절은 zsh가 그 입력을 **어떻게 해석하는지**를 다루므로 셸 설정 파일에 들어갑니다.

### 설치

```sh
./install-zsh.sh
```

Homebrew로 다음 패키지를 설치하고, `~/.zshrc` 맨 끝에 이 저장소의 `zsh/zshrc-additions.zsh`를 불러오는 세 줄짜리 블록을 추가합니다.

| 패키지                         | 역할                                                      |
|--------------------------------|-----------------------------------------------------------|
| `zsh-autosuggestions`          | 입력 중인 명령 뒤에 이전 실행 기록을 회색으로 미리 보여줌 |
| `zsh-history-substring-search` | `↑` `↓`로 **부분 문자열** 히스토리 검색                   |
| `zsh-syntax-highlighting`      | 존재하지 않는 명령을 입력 단계에서 빨간색으로 구분        |
| `fzf`                          | `Ctrl-R` 퍼지 검색 목록, `Ctrl-T` 파일 경로 검색          |

`~/.zshrc`는 수정 전에 `~/.zshrc.backups/zshrc.install-날짜-번호`로 백업합니다. 여러 번 실행해도 블록은 하나만 유지되며, 새로 만든 파일이 `zsh -n` 문법 검사를 통과하지 못하면 원본을 그대로 두고 중단합니다.

Homebrew 설치를 건너뛰고 `~/.zshrc` 설정만 적용하려면 다음을 사용합니다.

```sh
./install-zsh.sh --skip-brew
```

### 단축키

| 키             | 동작                                           | 담당                         |
|----------------|------------------------------------------------|------------------------------|
| `→` 또는 `End` | 회색으로 표시된 제안을 전체 수락               | zsh-autosuggestions          |
| `⌥→`           | 제안을 한 단어만 수락                          | zsh-autosuggestions          |
| `↑` `↓`        | 입력한 문자열이 **포함된** 이전 명령 순회      | zsh-history-substring-search |
| `Ctrl-R`       | 목록에서 퍼지 검색으로 선택                    | fzf                          |
| `Ctrl-T`       | 파일 경로를 퍼지 검색해 현재 줄에 삽입         | fzf                          |
| `Ctrl-/`       | `Ctrl-R` 목록에서 긴 명령의 전체 내용 미리보기 | fzf                          |

`ssh`까지만 입력하면 가장 최근에 접속한 서버 명령이 회색으로 따라붙고, `→` 한 번으로 완성됩니다. 서버가 여러 대라면 `↑` `↓`로 넘기며 고릅니다.

### oh-my-zsh 기본 동작과 달라지는 점

oh-my-zsh는 `lib/key-bindings.zsh`에서 `↑`를 `up-line-or-beginning-search`에 연결해 두는데, 이것도 히스토리 검색이긴 하지만 **입력한 내용으로 시작하는** 명령만 찾습니다. 이 묶음은 같은 키를 `history-substring-search-up`으로 바꿔 **중간에 포함된** 경우까지 찾도록 합니다.

```text
설정 전:  100 + ↑  →  아무것도 찾지 못함 ("100"으로 시작하는 명령이 없으므로)
설정 후:  100 + ↑  →  ssh -p 22339 knw1234@192.168.0.100
```

IP 뒷자리, 프로젝트 폴더 이름, 옵션 값처럼 명령 중간에 있는 조각만 기억날 때 유용합니다. 대신 `ssh`를 입력하면 `ssh-add`처럼 그 문자열을 포함하기만 한 명령도 함께 걸립니다.

히스토리 중복 처리도 함께 조정합니다. oh-my-zsh 기본값인 `hist_ignore_dups`는 **연속으로** 같은 명령을 실행한 경우에만 중복을 제거하므로, 같은 명령을 며칠에 걸쳐 반복하면 개별 항목으로 계속 쌓여 `↑` 순회가 지저분해집니다. `hist_ignore_all_dups`로 확장해 히스토리 전체에서 중복을 남기지 않습니다. 이 설정은
**새로 추가되는 항목부터** 적용되며 이미 쌓인 기록을 소급해 정리하지는 않습니다.

### 왜 plugins 배열이 아니라 별도 파일인가

oh-my-zsh는 `~/.zshrc`의 `plugins=(...)` 배열에 이름을 넣는 방식을 안내하지만, 이 묶음은 `zsh/zshrc-additions.zsh`에서 직접 순서를 지정해 불러옵니다.

세 플러그인은 로드 순서에 제약이 있습니다. `zsh-syntax-highlighting`은 그 시점에 정의된 위젯을 감싸는 방식이라 다른 위젯이 모두 정의된 뒤에 와야 하고, `zsh-history-substring-search`는 자체 강조 기능 때문에 그보다 **더 뒤**에 와야 합니다. 배열에 이름만 나열하면 나중에 플러그인을 추가할 때 이 순서가
조용히 깨질 수 있습니다.

별도 파일로 두면 `~/.zshrc`에 남는 흔적이 마커 주석이 붙은 블록 하나뿐이라, 제거할 때 그 블록만 걷어내면 설치 전 파일과 완전히 같아집니다.

### 확인하기

새 탭을 열고 다음을 실행해 키가 실제로 교체됐는지 봅니다.

```sh
bindkey '^[[A'   # history-substring-search-up 이어야 합니다
bindkey '^R'     # fzf-history-widget 이어야 합니다
```

셸 시작이 느려졌는지 확인하려면 다음을 비교합니다.

```sh
for i in 1 2 3; do /usr/bin/time zsh -i -c exit; done
```

`brew --prefix`와 `fzf --zsh`는 실행할 때마다 하위 프로세스를 띄우므로, 설정 파일은 Homebrew 경로를 미리 판별하고 fzf 초기화 결과를 `~/.cache/fzf-init.zsh`에 캐시합니다. 캐시는 fzf 바이너리가 갱신되면 자동으로 다시 만듭니다.

### 되돌리기

`~/.zshrc`에서 설정 블록만 제거합니다. Homebrew 패키지는 남습니다.

```sh
./uninstall-zsh.sh
```

설치 직전 백업으로 `~/.zshrc` 전체를 되돌리려면 다음을 사용합니다. 설치 이후 `~/.zshrc`에 직접 추가한 다른 내용도 함께 사라집니다.

```sh
./uninstall-zsh.sh --restore-latest
```

Homebrew 패키지까지 제거하려면 다음을 사용합니다. `fzf`는 다른 용도로도 쓰이므로 제거 대상에서 빼 두었습니다.

```sh
./uninstall-zsh.sh --purge
```

어느 경우든 `↑` 키는 oh-my-zsh 기본 동작인 접두어 검색으로 돌아갑니다.

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
- 설치 스크립트는 Homebrew의 `font-jetbrains-mono-nerd-font` 패키지에 포함된 `JetBrainsMonoNerdFontMono-Regular.ttf`를 확인하고, iTerm2 프로필에 정확한 PostScript 이름인 `JetBrainsMonoNFM-Regular 13`를 강제로 기록합니다. 폰트가 보이지 않으면
  iTerm2를 완전히 종료했다가 다시 실행하고 **Settings → Profiles → Text**에서 값이 `JetBrainsMono Nerd Font Mono Regular 13`으로 표시되는지 확인하세요.
- 한글 모양이 마음에 들지 않으면 **Settings → Profiles → Text**에서 Non-ASCII용 별도 폰트를 켜고 D2Coding 13pt를 지정하세요. D2Coding 설치 여부와 내부 폰트 이름이 배포판마다 달라 자동 적용하지 않았습니다.
- 키 매핑은 iTerm2가 `PresetKeyMappings.plist`로 배포하는 Natural Text Editing 프리셋과 동일한 형식 (프로필의 `Keyboard Map`)을 사용하며, iTerm2 3.6.11에서 확인했습니다. 단축키가 동작하지 않으면 **Settings → Profiles → Keys → Key Mappings** 목록에 7개
  항목이 보이는지 먼저 확인하세요.
- Git/원격 호스트/디렉터리 상태 표시가 비어 있으면 새 세션에서 Shell Integration이 동작하는지 먼저 확인하세요. 일반적인 로컬 로그인 셸에서는 이 프로필이 자동 로드를 요청합니다.

## 공식 문서

- Dynamic Profiles: <https://iterm2.com/documentation-dynamic-profiles.html>
- General Settings 및 전체 export/import: <https://iterm2.com/documentation-preferences-general.html>
- Shell Integration: <https://iterm2.com/documentation-shell-integration.html>
- Text/Font 설정: <https://iterm2.com/documentation-preferences-profiles-text.html>
- Terminal/Scrollback 설정: <https://iterm2.com/documentation-preferences-profiles-terminal.html>
- Keys/키 매핑 설정: <https://iterm2.com/documentation-preferences-profiles-keys.html>
