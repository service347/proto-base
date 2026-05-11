#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# new-project.sh — Layer 2 プロジェクトを新規作成する
#
# 使い方:
#   ./scripts/new-project.sh <client-slug> "<サービス名>" "<対象ユーザー>"
#
# 例:
#   ./scripts/new-project.sh tableflow "TableFlow" "飲食店のスタッフ・オーナー"
#   ./scripts/new-project.sh hr-tool "HR Manager" "人事担当者"
# ============================================================

CLIENT_SLUG="${1:-}"
SERVICE_NAME="${2:-}"
TARGET_USER="${3:-}"

if [[ -z "$CLIENT_SLUG" || -z "$SERVICE_NAME" || -z "$TARGET_USER" ]]; then
  echo "使い方: $0 <client-slug> \"<サービス名>\" \"<対象ユーザー>\""
  echo "例:     $0 tableflow \"TableFlow\" \"飲食店のスタッフ・オーナー\""
  exit 1
fi

REPO_NAME="proto-${CLIENT_SLUG}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BASE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
PROJECT_DIR="$(cd "${BASE_DIR}/.." && pwd)/${REPO_NAME}"

# --- 前提チェック ---
if ! command -v gh &>/dev/null; then
  echo "❌ gh CLI がインストールされていません。https://cli.github.com を参照してください。"
  exit 1
fi

if [[ -d "${PROJECT_DIR}" ]]; then
  echo "❌ ディレクトリがすでに存在します: ${PROJECT_DIR}"
  exit 1
fi

GH_USER=$(gh api user --jq .login)

echo "======================================"
echo "  新規プロジェクト作成"
echo "======================================"
echo "  リポジトリ名 : ${GH_USER}/${REPO_NAME}"
echo "  サービス名   : ${SERVICE_NAME}"
echo "  対象ユーザー : ${TARGET_USER}"
echo "  作成先       : ${PROJECT_DIR}"
echo "======================================"
echo ""

# --- ディレクトリ作成 ---
mkdir -p "${PROJECT_DIR}/guidelines"
mkdir -p "${PROJECT_DIR}/prototypes"

# --- ux-best-practices.md をコピー ---
cp "${BASE_DIR}/guidelines/ux-best-practices.md" "${PROJECT_DIR}/guidelines/"

# --- ubiquitous-language.md の雛形を生成 ---
cat > "${PROJECT_DIR}/guidelines/ubiquitous-language.md" << UBIQUITOUS
# ユビキタス言語 — ${SERVICE_NAME}

プロトタイプ内のラベル・テキストはすべてこの用語に従うこと。

---

## 人・役割

| 用語 | 読み | 定義 |
|------|------|------|
| **** |  |  |

---

## ステータス

| 用語 | 定義 | バッジ色 |
|------|------|--------|
| **** |  | \`badge-success\` |
| **** |  | \`badge-warning\` |
| **** |  | \`badge-error\` |

---

## 主要エンティティ

| 用語 | 読み | 定義 |
|------|------|------|
| **** |  |  |

---

## ビジネスルール

- （例: 申請は承認者が確認するまで「保留中」ステータスのままになる）
UBIQUITOUS

# --- CLAUDE.md を生成 ---
cat > "${PROJECT_DIR}/CLAUDE.md" << CLAUDEMD
# プロトタイプ生成ガイド

## 案件情報

サービス名: ${SERVICE_NAME}
対象ユーザー: ${TARGET_USER}
主な画面: [記入]

## スタック

- HTML + Tailwind CSS (Play CDN) + DaisyUI v4 (CDN)、\`data-theme="corporate"\` 固定
- ビルド不要。単一 \`.html\` ファイル完結。Tailwind / DaisyUI 以外のライブラリは追加しない
- CDN はこの順番・このバージョンを変えない:

\`\`\`html
<link href="https://cdn.jsdelivr.net/npm/daisyui@4/dist/full.min.css" rel="stylesheet" type="text/css" />
<script src="https://cdn.tailwindcss.com"></script>
\`\`\`

## コンテキスト

プロトタイプ生成前に以下を読む:

@guidelines/ux-best-practices.md
@guidelines/ubiquitous-language.md

## テンプレート

新規ファイルは作らずテンプレートをコピーして編集する:

| 画面 | テンプレート |
|------|------------|
| Web 管理画面ベース | \`../proto-base/templates/web/admin-shell.html\` |
| Web 一覧 | \`../proto-base/templates/web/list-page.html\` |
| Web 詳細 | \`../proto-base/templates/web/detail-page.html\` |
| Web フォーム | \`../proto-base/templates/web/form-page.html\` |
| Web ログイン | \`../proto-base/templates/web/login-page.html\` |
| モバイル | \`../proto-base/templates/mobile/ios-frame.html\` |

## 生成ルール

- ダミーデータは \`ubiquitous-language.md\` の用語・固有名詞を使う（汎用ダミーは使わない）
- モーダルは \`<dialog class="modal">\` + \`showModal()\` のみ使う（カスタム実装禁止）
- タブは \`role="tab"\` + \`type="radio"\` の DaisyUI radio 方式のみ使う
- サイドバーは \`drawer lg:drawer-open\` パターンのみ使う
- 出力先: \`prototypes/YYYY-MM-DD-[画面名].html\`

## 品質チェック（保存前に全確認）

- [ ] \`<html data-theme="corporate">\` が付いている
- [ ] CDN 順: DaisyUI CSS → Tailwind JS
- [ ] DaisyUI / Tailwind 以外のライブラリを使っていない
- [ ] ラベル・テキストが \`ubiquitous-language.md\` の用語と完全に一致している
- [ ] ボタンのラベルが動詞で始まる（「保存する」「削除する」）
- [ ] 日付: 「YYYY年M月D日」、金額: 「¥1,234」形式
- [ ] ローディング・空状態・エラー状態のいずれかを含む
- [ ] 破壊的操作に \`<dialog class="modal">\` の確認ステップがある
CLAUDEMD

# --- git 初期化 & initial commit ---
cd "${PROJECT_DIR}"
git init
git add .
git commit -m "feat: ${SERVICE_NAME} プロジェクト初期セットアップ

- CLAUDE.md: AI 指示書（スタック・生成ルール・品質チェック）
- guidelines/ux-best-practices.md: 共通 UX ルール（proto-base より）
- guidelines/ubiquitous-language.md: 用語集雛形（要記入）

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"

echo "✅ ローカル初期化完了"

# --- GitHub リポジトリ作成 & push ---
gh repo create "${GH_USER}/${REPO_NAME}" \
  --public \
  --description "${SERVICE_NAME} プロトタイプリポジトリ"

git remote add origin "https://github.com/${GH_USER}/${REPO_NAME}.git"
git push -u origin main

echo "✅ GitHub push 完了"

# --- GitHub Pages 有効化 ---
if gh api "repos/${GH_USER}/${REPO_NAME}/pages" \
     --method POST \
     --field 'source[branch]=main' \
     --field 'source[path]=/' \
     &>/dev/null; then
  echo "✅ GitHub Pages 有効化完了"
else
  echo "⚠️  GitHub Pages の自動有効化に失敗しました。"
  echo "   https://github.com/${GH_USER}/${REPO_NAME}/settings/pages から手動で設定してください。"
fi

# --- 完了メッセージ ---
echo ""
echo "======================================"
echo "  🎉 セットアップ完了！"
echo "======================================"
echo ""
echo "  📁 ローカル   : ${PROJECT_DIR}"
echo "  🐙 GitHub     : https://github.com/${GH_USER}/${REPO_NAME}"
echo "  🌐 Pages      : https://${GH_USER}.github.io/${REPO_NAME}/ (数分後に反映)"
echo ""
echo "  次のステップ:"
echo "  1. ubiquitous-language.md に用語・ビジネスルールを記入する"
echo "  2. CLAUDE.md の「主な画面」を埋める"
echo "  3. cd ${PROJECT_DIR} して Claude Code を起動する"
echo ""
