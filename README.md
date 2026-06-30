# mac-setup

新しい Mac を「一発で再現できる」ようにするセットアップ。Homebrew + [chezmoi](https://chezmoi.io) ベース。

## 構成

| ファイル | 役割 |
|---|---|
| `Brewfile.ai-native` | Homebrew の formula / cask / tap / mas を宣言的に管理（AIネイティブ最小構成） |
| `macos.sh` | macOS のシステム設定（トラックパッド・Finder・Dock 等）をコード化 |
| `bootstrap.sh` | 新Mac で1コマンド：CLT → Homebrew → `brew bundle` → chezmoi → macOS defaults |
| `SETUP.md` | 開封からの**通し手順書**（GUI / 権限 / サインイン含む） |
| `.gitignore` | 機密の誤コミット防止 |

dotfiles（シェル / エディタ / `~/.config`）は別リポを chezmoi で管理 → **[kyaukyuai/dotfiles](https://github.com/kyaukyuai/dotfiles)**

## 新しい Mac での復元

```bash
gh auth login
git clone https://github.com/kyaukyuai/mac-setup ~/mac-setup
bash ~/mac-setup/bootstrap.sh
```

bootstrap が CLT → Homebrew → `brew bundle` → `chezmoi init --apply`（dotfiles 展開）→ macOS defaults まで実行する。詳しい順序（FileVault / Time Machine / 権限 / サインイン等の手作業含む）は **[SETUP.md](SETUP.md)** を参照。

## 日常の運用

```bash
# いま入っているものを Brewfile に取り込む（定期的に → commit/push）
brew bundle dump --describe --force --file=~/mac-setup/Brewfile.ai-native

# Brewfile の内容をインストール（新Mac / 差分追従）
brew bundle --file=~/mac-setup/Brewfile.ai-native

# Brewfile に無いものを検出（任意で掃除）
brew bundle cleanup --file=~/mac-setup/Brewfile.ai-native
```

## AIネイティブ構成（主なアプリ）

| アプリ | 種別 | 入手 |
|---|---|---|
| Zed | AIネイティブ コードエディタ | `cask "zed"` |
| Claude | Claude デスクトップ | `cask "claude"` |
| Codex | OpenAI コーディングエージェント(CLI) | `cask "codex"` |
| Orca | 複数エージェント並列実行 ADE | `tap "stablyai/orca"` + `cask` |
| Slack | コミュニケーション | `cask "slack"` |
| Aside | AIブラウザ | 手動DL（[aside.com](https://aside.com/download)） |
| Alfred / Amphetamine | ランチャー / スリープ防止 | `cask` / `mas` |
| AeroSpace ほか | タイリングWM・borders・sketchybar・Ice・Stats・Karabiner・Swish | `cask` / `brew` |
| 1Password(+CLI) / OrbStack / mise / rg・fd・bat・eza・fzf・jq | 認証 / 開発ランタイム / モダンCLI | `cask` / `brew` |

## 機密について

`Brewfile.ai-native` に機密は含まれない。API キー等は dotfiles 側で `~/.config/zsh/secrets.zsh`（chmod 600・git 管理外）に分離している。`.gitignore` で誤コミットも防止。

## ライセンス

MIT（`LICENSE` 参照）。
