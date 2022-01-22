class MainController < ApplicationController
  # [cancancan]アクセス制御を行うための定義
  # ※対応するモデルクラスが存在しないコントローラのため、「class: false」を指定
  authorize_resource(class: false)

  # TOP画面
  def index
  end
end
