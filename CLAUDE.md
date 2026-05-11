# proto-base 管理ガイド

## このリポジトリの役割

Layer 1 の共有ベース層。すべてのクライアントプロジェクト（Layer 2）が参照する。
クライアント固有のプロトタイプはここに作らず、`scripts/new-project.sh` で Layer 2 リポジトリを作成して行う。

## 構成

- `templates/web/` — Web 画面テンプレート 5種
- `templates/mobile/` — モバイル画面テンプレート 1種
- `guidelines/ux-best-practices.md` — 全案件共通 UX ルール
- `CLAUDE.md.template` — Layer 2 用 CLAUDE.md の雛形
- `scripts/new-project.sh` — Layer 2 リポジトリ新規作成スクリプト

## テンプレート更新ルール

- HTML + Tailwind CSS (Play CDN) + DaisyUI v4 (CDN) のみ使用。他のライブラリを追加しない
- `data-theme="corporate"` 固定。CDN 読み込み順: Google Fonts → DaisyUI CSS → Tailwind JS → tailwind.config script
- 単一 `.html` ファイル完結（外部 JS・CSS ファイル不可）
- ダミーデータは日本語（山田 太郎、yamada@example.com 等）
- モーダルは `<dialog class="modal">` + `showModal()` のみ
- タブは `role="tab"` + `type="radio"` の DaisyUI radio 方式のみ
- サイドバーは `drawer lg:drawer-open` パターンのみ

## ux-best-practices.md 更新時の注意

`guidelines/ux-best-practices.md` を変更したら、既存の Layer 2 リポジトリには自動反映されない。
必要に応じて各 Layer 2 の `guidelines/ux-best-practices.md` を手動でコピーする。

## 新規 Layer 2 作成

```bash
./scripts/new-project.sh <client-slug> "<サービス名>" "<対象ユーザー>"
```
