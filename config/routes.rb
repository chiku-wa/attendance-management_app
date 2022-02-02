Rails.application.routes.draw do
  # =============== devis(ログイン機構)関連のルーティング設定
  # ----- ログイン・ログアウト関連(デフォルトのURLではモデル構造が丸見えなのでルーティングをカスタマイズ)
  # まずはdeviseが内包するsessions(ログイン・ログアウト関連)のルーティングを解除
  devise_for(:employees, skip: [:sessions])

  # ルーティングを再定義
  as :employee do
    get("login", to: "devise/sessions#new", as: :new_employee_session)
    post("login", to: "devise/sessions#create", as: :employee_session)
    delete("logout", to: "devise/sessions#destroy", as: :destroy_employee_session)
  end

  # =============== 各種ルーティング設定
  # ----- メイン画面
  root("main#work_input")
  get("main/work_input")

  # ----- 社員関連
  get("employee/list")

  # ----- 404ページ(これを定義しないとapplication_controllerのrescue_fromでハンドリングできない)
  # すべてのメソッドを対象とする(via: all)。
  match("*path" => "application#render_to_404", via: :all)
end
