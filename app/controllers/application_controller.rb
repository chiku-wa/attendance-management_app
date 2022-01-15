class ApplicationController < ActionController::Base
  # [devise]各Controllerでログイン中の社員情報を取得するための定義
  before_action :authenticate_employee!

  # =========== devise関連のアクション
  # ログイン後のアクション
  def after_sign_in_path_for(resource)
    # TOPに遷移する
    root_url
  end

  # ログアウト後のアクション
  def after_sign_out_path_for(resource)
    # ログイン画面に遷移する
    login_url
  end
end
