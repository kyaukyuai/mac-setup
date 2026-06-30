#!/usr/bin/env bash
# 新しい Mac を一発でセットアップする bootstrap
# 使い方:
#   git clone https://github.com/kyaukyuai/mac-setup ~/mac-setup
#   bash ~/mac-setup/bootstrap.sh                 # AIネイティブ最小構成（既定）
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="${1:-Brewfile.ai-native}"

echo "▶ 1/5 Xcode Command Line Tools"
xcode-select -p >/dev/null 2>&1 || { xcode-select --install; echo "  → インストール完了後に再実行してください"; exit 0; }

echo "▶ 2/5 Homebrew"
command -v brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "▶ 3/5 Brewfile: ${BREWFILE} (formula / cask / tap / mas)"
echo "  ※ mas アプリは事前に App Store サインインが必要"
brew bundle --file="$HERE/$BREWFILE"

echo "▶ 4/5 dotfiles（chezmoi）"
command -v chezmoi >/dev/null 2>&1 || brew install chezmoi
if [ -d "$HOME/.local/share/chezmoi/.git" ]; then
  chezmoi apply
else
  echo "  private な dotfiles を取得します（先に 'gh auth login' で GitHub 認証が必要）"
  read -r -p "  chezmoi init --apply kyaukyuai を実行しますか？ [y/N] " a
  [[ "${a:-N}" =~ ^[Yy]$ ]] && chezmoi init --apply kyaukyuai || echo "  → 後で 'chezmoi init --apply kyaukyuai' を実行してください"
fi

echo "▶ 5/5 macOS defaults（任意）"
read -r -p "  macOS defaults を適用しますか？ [y/N] " ans
[[ "${ans:-N}" =~ ^[Yy]$ ]] && bash "$HERE/macos.sh"

cat <<'EOF'

✅ bootstrap 完了。残りの手動タスク（GUI / 人手 / 機密）:
  - ~/.config/zsh/secrets.zsh に APIキー等を記入（dotfiles リポには含まれない）
  - FileVault・ファイアウォール・Touch ID を有効化（システム設定）
  - Time Machine バックアップ先を設定
  - Apple ID / iCloud / 2要素認証、各アプリへサインイン
  - Aside（AIブラウザ）を手動DL: https://aside.com/download
  - AppleCare & 保証を確認: https://checkcoverage.apple.com/
  - 日本語入力: システム設定で「ライブ変換」をON
EOF
