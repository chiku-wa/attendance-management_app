# 前提条件
## DB環境準備
DBはPostgreSQLを前提としています。
以下の環境を準備してください。

### データベース名
環境ごとにデータベースを作成してください。

| 環境 | DB名 |
|---|---|
| production | kintai |
| development | kintai_development |
| test | kintai_test |

### ユーザ名、パスワード
以下の環境変数を用意し、PostgreSQL上で作成したユーザ名とパスワードを設定してください。

| 項目名 | 環境変数名 |
|---|---|
| ユーザ名 | DATABASE_USERNAME |
| パスワード | DATABASE_PASSWORD |

なお、Superuserなどのロールは付与せず、純粋な`CREATE ROLE`のみでユーザを作成し、先ほど作成したデータベースの所有者としてください。

例：
```sql
CREATE ROLE FOO login password 'BAR';
ALTER DATABASE HOGE_DATABASE OWNER TO FOO;
```

### マイグレーション
PostgreSQLでデータベース、ユーザを作成できたら、以下のコマンドでマイグレーションを実行してください。

```

```

# 設計情報
DB設計書はGoogleスプレッドシート上で作成しています。詳しくは下記をご覧ください。
https://docs.google.com/spreadsheets/d/16DTE2wg3ElNfrV1qs4X9JZwdrkx3qFS1tYo4NKYuVgE/edit?usp=sharing
