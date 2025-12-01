# ほっぽリマインダー

ほっぽリマインダーは、習い事教室の先生がレッスン時間を変更したら生徒にリマインドを自動送信するアプリです。

## 使い方
### 1.レッスンを変更したい生徒を選択します。
<img width="611" height="270" alt="image" src="https://github.com/user-attachments/assets/44fb4d39-c295-4ea8-8aee-7038402917a5" />

### 2.変更したいレッスンを選択します。
<img width="599" height="641" alt="image" src="https://github.com/user-attachments/assets/e8025194-d635-4fd7-9aec-f2d7a1a8c3b0" />

### 3.日時を変更して保存するをクリックします。
<img width="601" height="369" alt="image" src="https://github.com/user-attachments/assets/bb2ee769-04f0-43ef-a8b7-876d5677aea2" />

### 4.公式LINEから生徒にメッセージが送信されます。
3通のメッセージが以下のタイミングで送信されます。
- 変更直後
- 変更前のレッスン前日
- 変更後のレッスン前日

## 技術スタック
Ruby 3.4.7 Ruby on Rails 8.1.1
Hotwire

## 環境構築
任意のディレクトリにこのリポジトリのクローンを保存します。
```
git clone https://github.com/hirokiej/hopporeminder.git
```
リポジトリに移動します。
```
cd hopporeminder
```
セットアップを実行します。
```
bin/setup
```

### Test
```
bin/rails test:all
```
### Lint
```
bin/lint
```
