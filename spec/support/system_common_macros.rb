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
end
