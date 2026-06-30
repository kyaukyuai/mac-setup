#!/usr/bin/env bash
# macOS defaults — 新Macの初期設定をコード化（適用前に必ず中身を確認）
# 使い方: bash macos.sh   （個別に試したい行はコメントアウトで調整）
set -euo pipefail

echo "▶ macOS defaults を適用します（要ログアウト/再起動の項目あり）"

# --- トラックパッド -------------------------------------------------
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true                    # タップでクリック
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true     # 3本指ドラッグ
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# --- キーボード（キーリピート高速化） -------------------------------
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false                      # 長押しでリピート（アクセント不要派）

# --- Finder ---------------------------------------------------------
defaults write NSGlobalDomain AppleShowAllExtensions -bool true                         # 拡張子を常に表示
defaults write com.apple.finder AppleShowAllFiles -bool true                            # 隠しファイル表示
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"                     # デフォルトをリスト表示

# --- Dock -----------------------------------------------------------
defaults write com.apple.dock minimize-to-application -bool true                        # アプリアイコンにしまう
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false

# --- スクリーンショット ---------------------------------------------
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"

# --- セキュリティ（スクリーンセーバ解除でパスワード要求） -----------
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# --- 再起動なしで反映 -----------------------------------------------
killall Dock Finder SystemUIServer 2>/dev/null || true
echo "✅ 完了。FileVault / ファイアウォール / Touch ID / Lockdown は GUI（システム設定）で設定してください。"
