class EmployeeController < ApplicationController
  # [cancancan]でアクセス制御を行うための定義
  authorize_resource

  # 社員情報一覧画面に遷移するアクション
  def list
    @employees = Employee.all
  end
end
