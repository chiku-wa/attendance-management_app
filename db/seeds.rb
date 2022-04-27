#
# db/seeds配下に存在する、環境ごとのrbを呼び出す
# 以下の公正であることが前提となる。
# db/seeds
# └common.rb      → 以下の3環境で共通して登録するデータ
# └development.rb → 開発環境用テストデータ
# └production.rb  → 本番環境用データ
# └test.rb        → テスト用データ
#

# 共通データの登録
load(Rails.root.join("db", "seeds", "common.rb"))

# 各環境ごとのテストデータ登録
load(Rails.root.join("db", "seeds", "#{Rails.env.downcase}.rb"))
