# DB情報
DBはPostgreSQLを前提としています。
以下の環境を準備してください。

## データベース名
環境ごとにデータベースを作成してください。

| 環境 | DB名 |
|---|---|
| production | kintai |
| development | kintai_development |
| test | kintai_test |

## ユーザ名、パスワード
以下の環境変数を用意してください。

| 項目名 | 環境変数名 |
|---|---|
| ユーザ名 | DATABASE_USERNAME |
| パスワード | DATABASE_PASSWORD |
