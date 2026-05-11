# proto-base

AI駆動プロトタイピングのベース層リポジトリ。

## 構成

```
proto-base/
├── templates/
│   ├── web/        ← Web 管理画面テンプレート
│   └── mobile/     ← モバイルフレームテンプレート
├── prototypes/     ← 生成されたプロトタイプ
├── guidelines/     ← UX ベストプラクティス集
└── CLAUDE.md       ← AI 指示書テンプレート
```

## スタック

- HTML
- [Tailwind CSS](https://tailwindcss.com/) (CDN)
- [Basecoat](https://basecoat.beek.io/) (CDN) — shadcn UI の HTML 版

## 使い方

Claude Code で指示するだけでプロトタイプが生成されます。

```
〇〇画面のプロトタイプを作って
```
