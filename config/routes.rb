Rails.application.routes.draw do
  # =============== ログイン機構を使用するためのdeviseの設定
  devise_for :employees

  # =============== 各種ルーティング設定
  # ----- メイン画面
  root("main#index")
  get("main/index")

  # ----- 社員関連
  get("employee/list")

  # ----- ログイン・ログアウト
  # devise_scopeには、ログイン情報を保管しているモデルクラス名を指定すること
  devise_scope :employee do
    get("login", to: "devise/sessions#create")
    delete("logout", to: "devise/sessions#destroy")
  end
end
