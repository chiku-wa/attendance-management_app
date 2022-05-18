RSpec.configure do |config|
  # ===== 通常のドライバ設定
  config.before(:each, type: :system) do
    driven_by(:selenium_chrome_headless)
  end

  # ===== JavaScriptを用いたテストで使用するドライバ設定
  config.before(:each, type: :system, js: true) do
    # ブラウザをヘッドレスモード(CLI)で実行する
    driven_by(:selenium_chrome_headless)
  end
end
