# 前提条件
## DB環境準備
DBはPostgreSQLを前提としています。
以下の環境を準備してください。

### 環境変数
DB名、ユーザ名、パスワード、ホスト名(test環境のみ)は環境変数に定義する必要があります。下記の環境変数を定義するようにしてください。

* 本番環境(production)

| 種別       | 環境変数名        | 備考 |
| ---------- | ----------------- | ---- |
| DB名       | DATABASE_NAME     |      |
| ユーザ名   | DATABASE_USERNAME |      |
| パスワード | DATABASE_PASSWORD |      |

* 開発環境(development)

| 種別       | 環境変数名            | 備考 |
| ---------- | --------------------- | ---- |
| DB名       | DATABASE_DEV_NAME     |      |
| ユーザ名   | DATABASE_DEV_USERNAME |      |
| パスワード | DATABASE_DEV_PASSWORD |      |

* 試験環境(test)

| 種別       | 環境変数名             | 備考                                                                                           |
| ---------- | ---------------------- | ---------------------------------------------------------------------------------------------- |
| ホスト名   | DATABASE_TEST_HOST     | 開発環境PC上ではほぼ`localhost`固定、GithubActions上ではPostgreSQLのコンテナのホスト名を指定。 |
| DB名       | DATABASE_TEST_NAME     |                                                                                                |
| ユーザ名   | DATABASE_TEST_USERNAME |                                                                                                |
| パスワード | DATABASE_TEST_PASSWORD |                                                                                                |

なお、ローカルの開発環境では`dotenv`gemを用いて`.env`ファイルで管理することを推奨します。
`.env`ファイルのサンプルを以下に示します。

<プロジェクトのルートディレクトリ>/`.env`
```bash
# 本番用
DATABASE_NAME = kintai
DATABASE_USERNAME = kintai_user
DATABASE_PASSWORD = hoge

# 開発用
DATABASE_DEV_NAME = kintai_development
DATABASE_DEV_USERNAME = kintai_development_user
DATABASE_DEV_PASSWORD = hoge_dev

# テスト用
DATABASE_TEST_HOST = localhost
DATABASE_TEST_NAME = kintai_test
DATABASE_TEST_USERNAME = kintai_test_user
DATABASE_TEST_PASSWORD = hoge_test
```

### PostgreSQL環境の構築
前述の`環境変数`で定義した構成でPostgreSQL上にDB、ユーザを定義してください。

なお、ユーザにはSuperuserロールは付与せず、純粋な`CREATE ROLE`ロールのみを付与してユーザを作成してください。

例：
```sql
CREATE ROLE FOO login password 'BAR';
ALTER DATABASE HOGE_DATABASE OWNER TO FOO;
```

### 開発環境、テスト環境のマイグレーション
PostgreSQLでデータベース、ユーザを作成できたら、`bundle exec rails db:reset`でマイグレーション、及びデータ登録を実行してください。
これにより、開発とRSpecテストに必要なデータが自動的に登録されます。

なお、テストデータ登録で使用する`seeds.rb`に関しては、`RAILS_ENV`に応じて登録するテストデータを切り替えられるようにしています。

db/seeds.rb
```ruby
load(Rails.root.join("db", "seeds", "#{Rails.env.downcase}.rb"))
```

対応するテストデータ登録プログラムは以下の構成で配置してください。
```
db/seeds
└development.rb
└production.rb
└test.rb
```

## CI情報
GithubActionsを使ってCIを設定しています。CIの方針は以下の通りとしています。
* PostgreSQLを使用(バージョンは、`development`環境と同様のものを使用)
* `master`,`development`ブランチへのPushをトリガーとして起動
* 使用するRubyのバージョンは、開発環境の`.ruby-version`と同じものを使用
* `bundler`,`yarn`についてはキャッシュを使用し、CIを高速化する

# 設計について
## 設計書
DB設計書はGoogleスプレッドシート上で作成しています。詳しくは下記をご覧ください。
https://docs.google.com/spreadsheets/d/16DTE2wg3ElNfrV1qs4X9JZwdrkx3qFS1tYo4NKYuVgE/edit?usp=sharing

## DB設計の方針
階層構造は`閉包テーブルモデル`を使用しています。実装が複雑なため、必要に応じて以下の参考資料を御覧ください。
https://docs.google.com/spreadsheets/d/1CBhZUgEMrRyd-Trv4FnO5cIrsOcu-ithNDEERFCkMUg/edit?usp=sharing

なお、本アプリでは`閉包テーブルモデル`の実装にあたり`closure_tree`gemは使用していません。
