class MainController < ApplicationController
  # [cancancan]アクセス制御を行うための定義
  # ※対応するモデルクラスが存在しないコントローラのため、「class: false」を指定
  authorize_resource(class: false)

  # -----------------------------------------------------
  # # 概要
  # TOP画面を表示するアクション。ログインしているユーザによってログインする画面を切り替える。
  def index
    # 権限ごとに遷移させる画面を分岐させる。複数の権限を有している場合、より権限が強い方を優先する。
    # システム管理者 > マネージャ > 一般社員
    if current_employee.has_role?(I18n.t("master_data.role.admin"))
      render("main/index_admin", formats: [:html])
    elsif current_employee.has_role?(I18n.t("master_data.role.manager"))
      render("main/index_manager", formats: [:html])
    elsif current_employee.has_role?(I18n.t("master_data.role.common"))
      render("main/index_common", formats: [:html])
    end
  end
end
