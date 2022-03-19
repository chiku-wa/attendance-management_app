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

  # ----------------------------------------------------
  # # 概要
  # 社員情報一覧において、画面上に表示された社員情報一覧と、引数として渡された社員情報インスタンス
  # の配列の並びが一致していることを確認する。
  # 並び順の一致確認は以下を基準とする。
  # * 画面上に標示された社員情報一覧 → trタグのid要素に埋め込まれた社員コード
  # * 引数として渡された社員情報インスタンスの配列 → employee_code要素
  #
  # # 引数
  # * emoloyees
  # 期待値を確認したい社員情報インスタンスの配列
  #
  def expect_same_order_of_employee_list(employees)
    # 画面に標示されている社員一覧を取得する
    employees_for_per_page = all(:xpath, "//html/body/div/table/tbody/tr")

    # 画面上に一度表示される件数と、引数の社員数が一致すること
    expect(employees.size).to eq employees_for_per_page.size

    # 画面上の社員コードと、引数の社員情報インスタンスの配列の並びが一致すること
    employees_for_per_page.each_with_index do |efpp, idx|
      # 画面上のtrタグのid要素に社員コードが埋め込まれているため、それを期待値の確認として利用する
      expect(
        employees[idx][:employee_code]
      ).to eq efpp["id"]
    end
  end
end
