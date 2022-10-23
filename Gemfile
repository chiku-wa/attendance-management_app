source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.6"

gem "rails", "~> 6.1"

# =============== 各環境で共通のgem
# --- Railsの基本gem
gem "puma", "~> 4.1"
gem "sass-rails", ">= 6"
gem "webpacker", "~> 5.4", ">= 5.4.3"
gem "turbolinks", "~> 5"
gem "jbuilder", "~> 2.7"

# --- DB関連
# PostgreSQL
gem "pg"

# --- 画面デザイン用
gem "bootsnap", ">= 1.4.2", require: false
gem "font-awesome-sass", "5.13" # アイコン(アイコンと対応するHTMLタグは「https://fontawesome.com/icons?d=gallery」より検索できる)
gem "kaminari", "~> 1.1" # ページネーション用

# ----- メールデザイン用
# カスタムCSSをメール本文に適用するためのgem
gem "premailer-rails", "~> 1.10"

# --- JavaScript
# RailsでReactを使用する場合に必要なgem
gem "react-rails", "~> 2.6", ">= 2.6.1"

# --- ログイン機能用
gem "bcrypt", "~> 3.1", ">= 3.1.16"
gem "devise", "~> 4.8"
gem "cancancan", "~> 3.3"

# --- その他
# テストデータなど、大量データをバルクインサートするためのgem
gem "activerecord-import", "~> 1.0", ">= 1.0.8"

# 日本人の氏名テストデータ登録用
gem "gimei", "~> 0.5.1"

# テストデータ登録用(英語のみ)
gem "faker", "~> 1.6", ">= 1.6.3"

# 日本語化用
gem "rails-i18n", "~> 6.0"

# =============== 各種環境用のgem
# ----- 開発環境
group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.2"
  gem "spring"
  gem "spring-watcher-listen"

  # RSpecのテスト実行時間を早くするためのgem
  gem "spring-commands-rspec"
end

# ----- 開発・テスト環境
group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]

  # Rails Consoleなどで、オブジェクトをリッチに出力するためのgem
  gem "awesome_print", "~> 1.8"

  # RSPecテスト用
  gem "rspec-rails", "~> 4.0"

  # 環境変数で動的に設定値を扱うためのgem(DB接続情報等)
  gem "dotenv-rails"

  # テストデータ作成用
  gem "factory_bot_rails", "~> 6.1"
end

# ----- テスト環境
group :test do
  # テストファイル保存時に自動的にRSpecテストを実行するためのgem
  # ※テスト結果をMacの通知に表示するためのgemも導入する
  gem "guard", "~> 2.17"
  gem "guard-rspec"
  gem "terminal-notifier-guard", "~> 1.7"

  # システムテスト用
  gem "capybara", "~> 3.36"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
