source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.1"

gem "rails", "~> 6.1"

# ===== 各環境で共通のgem
# --- Railsの基本gem
gem "puma", "~> 4.1"
gem "sass-rails", ">= 6"
gem "webpacker", "~> 4.0"
gem "turbolinks", "~> 5"
gem "jbuilder", "~> 2.7"
gem "faker", "~> 1.6", ">= 1.6.3"

# --- DB関連
# PostgreSQL
gem "pg"

# --- 画面デザイン用
gem "bootstrap", "~> 4.5", ">= 4.5.2"
gem "bootsnap", ">= 1.4.2", require: false
gem "font-awesome-sass"

# --- ログイン機能用
gem "bcrypt", "~> 3.1", ">= 3.1.16"
gem "devise", "~> 4.8"
gem "cancancan", "~> 3.3"

# --- その他
# テストデータなど、大量データをバルクインサートするためのgem
gem "activerecord-import", "~> 1.0", ">= 1.0.8"

# 日本人の氏名テストデータ登録用
gem "gimei", "~> 0.5.1"

# 日本語化用
gem "rails-i18n", "~> 6.0"

# ===== 各種環境用のgem
group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"

  # RSpecのテスト実行時間を早くするためのgem
  gem "spring-commands-rspec", "~> 1.0"
end

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

group :test do
  # テストファイル保存時に自動的にRSpecテストを実行するためのgem
  # ※テスト結果をMacの通知に表示するためのgemも導入する
  gem "guard", "~> 2.17"
  gem "guard-rspec"
  gem "terminal-notifier-guard", "~> 1.7"

  # 統合テスト用
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
