class MainController < ApplicationController
  # TOP画面
  def index
    # [devise]ログイン中社員を取得する
    @employee = current_employee
  end
end
