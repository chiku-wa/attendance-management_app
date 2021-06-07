source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.6"

gem "rails", "~> 6.0.3", ">= 6.0.3.3"

# ===== 各環境で共通のgem
# Railsの基本gem
gem "puma", "~> 4.1"
gem "sass-rails", ">= 6"
gem "webpacker", "~> 4.0"
gem "turbolinks", "~> 5"
gem "jbuilder", "~> 2.7"
gem "faker", "~> 1.6", ">= 1.6.3"

# 日本人の氏名テストデータ登録用
gem "gimei", "~> 0.5.1"

# 日本語化用
gem "rails-i18n", "~> 6.0"

# テストデータなど、大量データをバルクインサートするためのgem
gem "activerecord-import", "~> 1.0", ">= 1.0.8"

# DB関連
gem "pg"

# 画面デザイン用
gem "bootstrap", "~> 4.5", ">= 4.5.2"
gem "bootsnap", ">= 1.4.2", require: false
gem "font-awesome-sass"

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
  # 統合テスト用
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
