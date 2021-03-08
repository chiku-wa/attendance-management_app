require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AttendanceManagementApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # 「rails generate」コマンド実行時に自動的にRSPecテストファイルが生成されるようにする
    config.generators do |g|
      g.test_framework(
        :rspec,

        # テストデータ登録用のフィクスチャファイルの自動生成するか否か：fixture以外の仕組みでテストデータを作成するため自動生成はしない
        fixtures: false,

        # View生成時にRSPecテストを自動生成するか否か：画面周りはfeatureテスト(Capyara等)で試験するため、自動生成はしない
        view_specs: false,

        # ヘルパーメソッド作成時にテストを自動生成するか否か：
        helper_specs: true,

        # routing.rbのテストを自動生成するか否か：spec/requests配下のテストメソッドでテストするため自動生成しない
        routing_specs: false,
      )
    end
  end
end
