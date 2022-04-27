# frozen_string_literal: true

# ----- kaminariのデフォルト設定
Kaminari.configure do |config|
  # 1ページに表示する項目数
  config.default_per_page = 30

  # config.max_per_page = nil
  # config.window = 4
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
  # config.max_pages = nil
  # config.params_on_first_page = false
end
