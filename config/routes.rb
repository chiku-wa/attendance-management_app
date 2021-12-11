Rails.application.routes.draw do
  # =============== ログイン機構を使用するためのdeviseの設定
  devise_for :employees

  # =============== 各種ルーティング設定
  root "main#index"

  get "main/index"
end
