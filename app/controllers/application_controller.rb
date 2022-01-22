class ApplicationController < ActionController::Base
  # [devise]すべてのコントローラのアクセスには、deviseによる認証を必要とする
  before_action :authenticate_employee!

  # ========== cancancan関連のアクション
  # ----- 認証に使用するモデルクラス名がデフォルト(User)ではないため、ここで明示
  # https://github.com/ryanb/cancan/wiki/changing-defaults
  def current_ability
    # current_user→current_employeeに変更
    @current_ability ||= Ability.new(current_employee)
  end
end
