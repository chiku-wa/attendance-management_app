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

    click_button("ログイン")
  end

  # ----------------------------------------------------
  # # 概要
  # 引数として渡したシステム管理者の社員インスタンスをもとにログイン処理を行い、
  # システム管理者しか閲覧できない画面が正常に表示されることを確認する。
  #
  # # 引数
  # * emoloyee
  # ログインしたいシステム管理者の社員モデルクラスのインスタンス
  #
  def login_macro_with_admin(employee:)
    # ログインを行う
    login_macro(employee: employee)

    # 社員情報一覧に遷移していることを確認
    visit(employees_list_path)
    expect(page).to(
      have_title("社員情報一覧")
    )
  end

  # ----------------------------------------------------
  # # 概要
  # 引数として渡した一般社員の社員インスタンスをもとにログイン処理を行い、
  # 一般社員しか閲覧できない画面が正常に表示されることを確認する。
  #
  # # 引数
  # * emoloyee
  # ログインしたい一般社員の社員モデルクラスのインスタンス
  #
  def login_macro_with_common(employee:)
    # ログインを行う
    login_macro(employee: employee)

    # 勤怠登録画面に遷移していることを確認
    expect(page).to(
      have_link("出勤")
    )
    expect(page).to(
      have_link("退社")
    )
    expect(page).to(
      have_link("休憩")
    )
  end

  # ----------------------------------------------------
  # # 概要
  # パスワードリセット画面に遷移し、メールアドレスを入力して想定通りの画面が表示されることを確認する。
  #
  # # 引数
  # * emoloyee
  # パスワードリセットしたい社員モデルクラスのインスタンス
  #
  def reset_password_macro(employee:)
    # ----- パスワードリセット操作を実施
    # TOP画面(=ログイン画面)に遷移する
    visit(root_path)

    # パスワードリセット画面に遷移する
    click_link("パスワードをお忘れの方はこちらをクリック")

    # メールアドレスを入力してパスワードをリセットを実施
    fill_in("employee_email", with: employee.email)
    click_button("パスワードを変更する")

    # ----- 画面上に想定通りのメッセージが表示されること
    # ログイン画面に遷移し、メッセージが表示されること
    expect(page).to(
      have_title("ログイン")
    )

    expect(
      find(:xpath, "//p[@id='message_notice']")
    ).to have_content("パスワードの再設定を受け付けました。メールボックスをご確認ください。")

    # ----- 発行されたトークンをインスタンスに読み込ませるためにreloadする
    @employee.reload
  end

  # ----------------------------------------------------
  # # 概要
  # 社員情報一覧において、画面上に表示された社員情報一覧と、引数として渡された社員情報インスタンス
  # の配列の並びが一致していることを確認する。
  # 並び順の一致確認は以下を基準とする。
  # * 画面上に表示された社員情報一覧 → trタグのid要素に埋め込まれた社員コード
  # * 引数として渡された社員情報インスタンスの配列 → employee_code要素
  #
  # # 引数
  # * emoloyees
  # 期待値を確認したい社員情報インスタンスの配列
  #
  def expect_same_order_of_employee_list(employees)
    # 画面に表示されている社員一覧を取得する
    employees_for_per_page = all(:xpath, "//table[@name='employees']/tbody/tr")

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
