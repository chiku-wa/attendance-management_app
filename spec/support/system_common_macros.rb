# ========================
# システムテストで使用する汎用メソッドをまとめたモジュール
module SystemCommonMacros

  # ----------------------------------------------------
  # # 概要
  # 引数として渡した社員インスタンスをもとにログイン処理を行う
  #
  # # 引数
  # * emoloyee
  # ログインしたい社員モデルクラスのインスタンス
  #
  def login_macro(employee:)
    visit(root_path)

    fill_in(:employee_email, with: employee.email)
    fill_in(:employee_password, with: employee.password)

    click_button("Log in")
  end

  # ----------------------------------------------------
  # # 概要
  # 引数として渡した社員インスタンスをもとにログイン処理を行い、社員情報一覧画面に遷移することの確認を行う。
  #
  # # 引数
  # * emoloyee
  # ログインしたい社員モデルクラスのインスタンス
  #
  def login_macro_with_emplpoyee_list(employee:)
    # ログインを行う
    login_macro(employee: employee)

    # 社員情報一覧に遷移し、遷移していることを確認
    visit(employees_list_path)
    expect(page).to(
      have_title("社員情報一覧")
    )
  end
end
