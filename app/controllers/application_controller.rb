class ApplicationController < ActionController::Base
  # [devise]すべてのコントローラのアクセスには、deviseによる認証を必要とする
  before_action(:authenticate_employee!)

  # [devise]メールアドレス、パスワード以外のフォームによるパラメータ受信を許可する
  # ※devise関連のController処理でのみコールバック関数を実行する
  before_action(:configure_permitted_parameters, if: :devise_controller?)

  # ========== エラーページのハンドリング処理
  # 【注意】rescue_fromは**後に記述したものから処理**されるため、500のハンドリング処理は先頭に記述すること
  #       ※そうしなければ、ページが存在しない場合も権限エラーの場合も常に500エラーでハンドリングされてしまう。
  # ----- 500エラー
  rescue_from(Exception, with: :render_to_500)
  # ----- 404:アクセスしようとしたページが存在しない
  rescue_from(ActiveRecord::RecordNotFound, ActionController::RoutingError, with: :render_to_404)
  # ----- 403:ページにアクセス権限が存在しない(ページの存在を気づかせないようにするため、404に遷移させる)
  rescue_from(CanCan::AccessDenied, with: :render_to_404)

  # ========== 各種汎用アクションメソッド
  # ----- 500ページ
  def render_to_500(e = nil)
    logger.error([e, *e.backtrace].join("\n")) if e
    render("errors/500", status: 500, formats: [:html])
  end

  # ----- 404ページ
  def render_to_404(e = nil)
    logger.error([e, *e.backtrace].join("\n")) if e
    render("errors/404", status: 404, formats: [:html])
  end

  # ----- 403ページ
  def render_to_403(e = nil)
    logger.error([e, *e.backtrace].join("\n")) if e
    render("errors/403", status: 403, formats: [:html])
  end

  # ========== devise関連のアクション
  # ----- メールアドレス、パスワード以外のフォームによるパラメータ受信を許可する
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      # 社員登録画面の処理で許可する
      :sign_up,

      # 許可するパラメータを指定
      # ※メールアドレス、パスワードはdeviseでデフォルトで許可されているため指定不要
      keys: [
        # 社員コード
        :employee_code,

        # 社員名(姓)
        :employee_last_name,

        # 社員名(名)
        :employee_first_name,

        # 社員名カナ(姓)
        :employee_last_name_kana,

        # 社員名カナ(名)
        :employee_first_name_kana,

        # 年齢
        :age,

        # 就業状況
        :employment_status,
      ],
    )
  end

  # ========== cancancan関連のアクション
  # ----- 認証に使用するモデルクラス名がデフォルト(User)ではないため、ここで明示
  # https://github.com/ryanb/cancan/wiki/changing-defaults
  def current_ability
    # current_user→current_employeeに変更
    @current_ability ||= Ability.new(current_employee)
  end
end
