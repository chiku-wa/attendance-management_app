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
gem "bootsnap", ">= 1.4.2", require: false

# DB関連
gem "pg"

# 画面デザイン用
gem "bootstrap-sass", "~> 3.4"

# ===== 各種環境用のgem
group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]

  # 環境変数で動的に設定値を扱うためのgem(DB接続情報等)
  gem "dotenv-rails"
end

group :test do
  # 統合テスト用
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
