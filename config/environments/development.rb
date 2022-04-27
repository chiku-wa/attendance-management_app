Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp", "caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}",
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # ========== メール設定
  # ----- deviseが送信するメールの本文内のURLのFQDN名
  config.action_mailer.default_url_options = {
    host: ENV["ACTION_MAILER_DEV_URL"],
    port: 3000,
  }

  # ----- SMTP設定
  # メール送信時にエラーが発生した場合は例外を発生させる
  config.action_mailer.raise_delivery_errors = true

  # SMTPサーバの接続設定
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    # TLS認証を使用するか
    enable_starttls_auto: true,

    # SMTPサーバのアドレス
    address: ENV["SMTP_ADDRESS"],

    # SMTPサーバのポート番号
    port: ENV["SMTP_PORT"],

    # SMTPサーバのドメイン
    # ※SMTPと通信を開始する際に使用するHELOドメイン、メールの中継ログ情報としてメールのヘッダに追加され
    domain: ENV["SMTP_DOMAIN"],

    # SMTPサーバのユーザ名
    user_name: ENV["SMTP_USER_NAME"],

    # SMTPサーバのパスワード
    password: ENV["SMTP_PASSWORD"],

    # SMTPサーバの認証方法
    authentication: "plain",
  }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
