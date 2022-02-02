class MainController < ApplicationController
  # [cancancan]アクセス制御を行うための定義
  # ※対応するモデルクラスが存在しないコントローラのため、「class: false」を指定
  authorize_resource(class: false)

  # TOP画面
  def index
    # システム管理者なら社員情報一覧画面に遷移し、マネージャ・一般社員なら勤怠登録画面に遷移する
    # 複数の権限を有している場合、より権限が強い方を優先する
    # ※システム管理者 > マネージャ > 一般社員
    # if current_employee.has_role?(I18n.t("master_data.role.admin"))
    # elsif current_employee.has_role?(I18n.t("master_data.role.admin"))
    # end
  end
end
