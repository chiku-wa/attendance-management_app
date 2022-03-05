class EmployeesController < ApplicationController
  # [cancancan]でアクセス制御を行うための定義
  authorize_resource

  # 社員情報一覧画面に遷移するアクション
  def list
    # 以下の条件で社員情報一覧を取得
    # * ログインしているユーザは除外する
    # * N+1問題を回避するため、Viewで必要なテーブルを事前に結合しておく
    # * `kaminari`gemのページネーションを考慮する
    @employees = Employee
      .where.not(id: current_employee.id)
      .includes([:roles, :employment_status])
      .page(params[:page])
  end
end
