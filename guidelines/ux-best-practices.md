# UX ベストプラクティス

プロトタイプ生成時に必ず従うべきルール集。  
すべての画面に適用される。案件固有のルールは `ubiquitous-language.md` や `brand-guide.md` で上書きする。

---

## インタラクション

### 破壊的操作には必ず確認ダイアログを挟む

削除・退会・取り消し不可の操作はすべて `<dialog class="modal">` で確認ステップを設ける。

```html
<!-- 削除ボタン -->
<button class="btn btn-error btn-outline btn-sm" onclick="document.getElementById('delete-modal').showModal()">
  削除する
</button>

<!-- 確認モーダル -->
<dialog id="delete-modal" class="modal">
  <div class="modal-box">
    <h3 class="font-bold text-lg">削除の確認</h3>
    <p class="py-4">「〇〇」を削除します。この操作は取り消せません。</p>
    <div class="modal-action">
      <form method="dialog" class="flex gap-2">
        <button class="btn btn-outline">キャンセル</button>
        <button class="btn btn-error">削除する</button>
      </form>
    </div>
  </div>
  <form method="dialog" class="modal-backdrop"><button>close</button></form>
</dialog>
```

### ボタンのラベルは動詞で始める

| NG | OK |
|----|----|
| 保存 | 保存する |
| 削除 | 削除する |
| 送信 | 送信する |
| キャンセル | キャンセル（名詞で慣用的なものは例外） |

---

## フォーム

### ラベルは入力欄の上に配置する

```html
<label class="form-control w-full">
  <div class="label"><span class="label-text font-medium">氏名</span></div>
  <input type="text" class="input input-bordered w-full" />
</label>
```

横並び（ラベル左・入力欄右）は使わない。モバイルで崩れる原因になる。

### 必須項目を明示する

```html
<span class="label-text font-medium">メールアドレス <span class="text-error">*</span></span>
```

### エラーメッセージは「なぜ」「どう直すか」を書く

| NG | OK |
|----|-----|
| 入力が正しくありません | メールアドレスの形式が正しくありません（例: name@example.com） |
| 必須項目です | 氏名を入力してください |
| パスワードエラー | パスワードは8文字以上で入力してください |

```html
<label class="form-control w-full">
  <div class="label"><span class="label-text font-medium">メールアドレス</span></div>
  <input type="email" class="input input-bordered input-error w-full" />
  <div class="label">
    <span class="label-text-alt text-error">メールアドレスの形式が正しくありません（例: name@example.com）</span>
  </div>
</label>
```

### ヒントテキストは `label-text-alt` で添える

任意項目・入力形式の説明は `label-text-alt text-base-content/50` を使う。

```html
<div class="label"><span class="label-text-alt text-base-content/50">ハイフンなしで入力してください</span></div>
```

---

## タッチ・クリックターゲット

### 最小タッチターゲットは 44px × 44px

モバイル画面では操作領域を十分に確保する。DaisyUI の `btn-sm` は高さ約 32px のため、モバイル向けには `btn`（デフォルト）を使う。

テーブル内のアクションなど小さくせざるを得ない場合は `btn-ghost btn-xs` に `p-2` を加えてヒット領域を広げる。

---

## 状態の表現

すべての一覧・詳細・フォームは以下3状態を必ず表現する。

### ローディング状態

```html
<span class="loading loading-spinner loading-md"></span>
```

一覧テーブルのスケルトンには `skeleton` クラスを使う。

```html
<div class="skeleton h-4 w-full"></div>
```

### 空状態（データがない場合）

```html
<div class="flex flex-col items-center justify-center py-16 gap-3 text-base-content/40">
  <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12" fill="none" viewBox="0 0 24 24" stroke="currentColor">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
  </svg>
  <p class="text-sm">まだデータがありません</p>
  <button class="btn btn-primary btn-sm">新規作成する</button>
</div>
```

### エラー状態

```html
<div class="alert alert-error">
  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
  </svg>
  <span>データの取得に失敗しました。時間をおいて再度お試しください。</span>
</div>
```

---

## 日本語フォーマット規則

AI が生成するダミーデータに適用する。

| 種類 | フォーマット | 例 |
|------|------------|-----|
| 日付 | YYYY年M月D日 | 2026年5月11日 |
| 日時 | YYYY年M月D日 H:mm | 2026年5月11日 14:32 |
| 金額 | ¥ + カンマ区切り | ¥1,234 / ¥12,000 |
| 大きな金額 | 万単位 | ¥120万 / 1,200万円 |
| パーセント | 半角数字 + % | 85% |
| 電話番号 | ハイフンあり | 090-1234-5678 / 03-1234-5678 |
| 郵便番号 | 〒 + ハイフンあり | 〒150-0001 |

---

## ステータスバッジの色規則

DaisyUI のバッジカラーを以下の意味で統一する。

| 意味 | クラス | 表示例 |
|------|--------|--------|
| 有効 / 完了 / 成功 | `badge-success` | 有効 |
| 警告 / 保留 / 処理中 | `badge-warning` | 保留中 |
| エラー / 無効 / 拒否 | `badge-error` | 無効 |
| 情報 / 下書き | `badge-info` | 下書き |
| ニュートラル | `badge-outline` | アーカイブ |

---

## ナビゲーション・レイアウト

### Web 管理画面は `drawer lg:drawer-open` パターンを使う

`templates/web/admin-shell.html` をベースにする。独自のサイドバー実装は行わない。

### パンくずリストは `breadcrumbs` で表現する

```html
<div class="breadcrumbs text-sm">
  <ul>
    <li><a>ホーム</a></li>
    <li><a>ユーザー管理</a></li>
    <li>詳細</li>
  </ul>
</div>
```

最後の項目（現在地）はリンクにしない。

### モバイルは `btm-nav` でボトムナビゲーションを表現する

`templates/mobile/ios-frame.html` をベースにする。タブは最大5項目まで。

---

## アクセシビリティ

- 画像には必ず `alt` を付ける（装飾用は `alt=""`）
- インタラクティブ要素には `aria-label` を付ける（アイコンのみのボタン等）
- フォームの `<input>` は必ず `<label>` と紐付ける（`for` 属性 or `form-control` ラッパー）
- カラーのみでステータスを表現しない（バッジには必ずテキストラベルを添える）
