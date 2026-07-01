# 新Mac セットアップ手順書（クリーン構築・上から順に）

本リポジトリ（`mac-setup` + `kyaukyuai/dotfiles`）で新しい Mac を再現するための通し手順。
移行アシスタントは使わず、**クリーンに組み直す**前提（設定ゴミを持ち込まない）。所要 60〜90分。

---

## フェーズ0：開封・初回（GUI・人手）
1. **ハード確認** ── 傷・ドット抜け・ヒンジ・ポート・キーボードを点検
2. **セットアップアシスタント** ── 言語/地域 → Wi-Fi → Apple ID サインイン → Touch ID 登録 → 外観
   - データ移行画面は **スキップ**（このリポで再現するため）
3. **OS を最新へ** ── システム設定 → 一般 → ソフトウェアアップデート → 自動アップデート ON
4. **Apple ID / iCloud / 2要素認証** ── 2FA を必ず有効化。iCloud Drive 等の同期対象を選択
5. **AppleCare & 保証確認** ── システム設定 → 一般 → AppleCare と保証、または https://checkcoverage.apple.com/

## フェーズ1：セキュリティ（GUI・先にやる）
6. **FileVault ON** ── プライバシーとセキュリティ → FileVault。**復旧キーを安全に保管**
7. **ファイアウォール ON** ── プライバシーとセキュリティ → ファイアウォール
8. **Time Machine** ── バックアップ先（外付け/NAS）を設定

## フェーズ2：自動セットアップ（ターミナル）
9. **Command Line Tools** ── git clone に必要（未導入なら次の clone 時に自動で促される）
   ```bash
   xcode-select --install
   ```
   ※ dotfiles・mac-setup は公開リポなので clone に `gh auth login` は不要（gh CLI は後で任意に）
10. **App Store にサインイン**（`mas`/Amphetamine 用・bootstrap より前に）
11. **クローン → bootstrap**
    ```bash
    git clone https://github.com/kyaukyuai/mac-setup ~/mac-setup
    bash ~/mac-setup/bootstrap.sh        # AIネイティブ最小（既定）
    ```
    bootstrap が実行：CLT確認 → Homebrew → `brew bundle`（非公式 tap は自動 trust）→ `chezmoi init --apply kyaukyuai`（公開リポ・認証不要）→ macOS defaults
12. **ローカル設定ファイルを作成**（リポには含まれない・機密）
    - `~/.config/git/identity.local` ── 実名メール（GPG署名は鍵移行後に追記）
    - `~/.config/zsh/secrets.zsh` ── APIキー等（必要なものだけ）

## フェーズ3：手動アプリ・サインイン
13. **Aside（AIブラウザ）** ── brew 未対応 → https://aside.com/download から DMG
14. **各アプリにサインイン** ── 1Password / Claude / Codex（"Sign in with ChatGPT"）/ Slack / Orca / Zed
15. **Orca 用 CLI**（コーディング統括するなら）── `npm i -g @anthropic-ai/claude-code`、`codex` は Brewfile 済
16. **日本語入力** ── システム設定 → キーボード → 日本語IME → **「ライブ変換」ON**（標準IMEを使用）

## フェーズ4：ウィンドウ環境の起動（設定は chezmoi で復元済み）
17. **常駐サービス起動**
    ```bash
    brew services start felixkratz/formulae/borders     # JankyBorders
    brew services start felixkratz/formulae/sketchybar  # 設定は chezmoi で復元済（AeroSpace ワークスペース連携）
    ```
18. **権限付与（初回・GUI 必須）**
    - AeroSpace：アクセシビリティ
    - Karabiner-Elements：入力監視 + ドライバ承認
    - Swish / Stats / Ice / Amphetamine：起動して各権限を許可
    - スクリーン録画系を使う場合：画面収録

## フェーズ5：確認
19. `brew bundle check --file=~/mac-setup/Brewfile.ai-native`（解決済みか）
20. 新しいターミナルを開き、シェル/プロンプト（starship）・dotfiles 反映・各アプリ動作を確認

---

## 既知の人手ゲート（自動化できない）
- **公開リポ**：dotfiles・mac-setup とも public のため clone に認証不要（gh CLI は任意）
- **mas アプリ**：App Store サインイン後でないと入らない
- **各種権限**（アクセシビリティ/入力監視/画面収録）：アプリ初回に手動許可
- **secrets.zsh**：鍵はリポに含まれない（手動記入）
- **Aside / FileVault / Time Machine / AppleCare**：GUI 操作

## 日常メンテ
- 新しく入れた/消したアプリ → `brew bundle dump --describe --force --file=~/mac-setup/Brewfile.ai-native` → commit/push
- 設定を変えた → `chezmoi re-add`（or `chezmoi add <file>`）→ `chezmoi cd` で commit/push
