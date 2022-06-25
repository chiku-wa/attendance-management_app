Rails.application.routes.draw do
  # =============== devis(ログイン機構)関連のルーティング設定
  devise_for(
    # 認証に使用するモデルクラス
    :employees,

    # deviseのデフォルトのルーティングを削除
    # ※デフォルトのままだとURLにモデル名が表示されるため、一旦ルーティングをリセットして再定義
    skip: [
      # ログイン・ログアウト機能
      :sessions,

      # パスワードリセット機能
      :passwords,

      # 新規登録、変更、削除機能
      :registrations,
    ],

    # 新規登録機能は独自クラスで定義しているため、ルーティングを変更する。
    # ※新規登録画面はシステム管理者しかアクセスできないようにするため
    :controllers => {
      :registrations => "employees/registrations",
    },
  )

  # ルーティングを再定義(`as`は`devise_scope`のalias)
  as :employee do
    # ----- ログイン・ログアウト機能
    # ログイン
    get("login", to: "devise/sessions#new", as: :new_employee_session)
    post("login", to: "devise/sessions#create", as: :employee_session)

    # ログアウト
    delete("logout", to: "devise/sessions#destroy", as: :destroy_employee_session)

    # ----- パスワードリセット機能
    # パスワードリセットのリクエスト
    get("password_reset", to: "devise/passwords#new", as: :new_employee_password)
    post("password_reset", to: "devise/passwords#create", as: :employee_password)
    # パスワード変更
    get("password_edit", to: "devise/passwords#edit", as: :edit_employee_password)
    match(
      "password_update",
      to: "devise/passwords#update",
      via: [:patch, :put],
      as: :update_employee_password,
    )

    # ----- 新規登録、変更、削除機能
    # 社員の新規登録
    get("sign_up", to: "devise/registrations#new", as: :new_employee_registration)
    post("sign_up", to: "devise/registrations#create", as: :employee_registration)
    # 社員の変更
    get("edit", to: "devise/registrations#edit", as: :edit_employee_registration)
    match(
      "update",
      to: "devise/registrations#update",
      via: [:patch, :put],
      as: :update_employee_registration,
    )
    # 社員の削除
    delete("destroy", to: "devise/registrations#destroy", as: :destroy_employee_registration)
    # キャンセル
    get("cancel", to: "devise/registrations#cancel", as: :cancel_employee_registration)
  end

  # =============== 各種ルーティング設定
  # ----- メイン画面
  root("main#index")
  get("main/index")

  # ----- 社員一覧画面
  get("employees/list")

  # ----- 404ページ(これを定義しないとapplication_controllerのrescue_fromでハンドリングできない)
  # すべてのメソッドを対象とする(via: all)。
  match("*path" => "application#render_to_404", via: :all)
end
