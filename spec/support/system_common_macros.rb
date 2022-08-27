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

    # 社員情報一覧のリンクが存在していることを確認
    expect(page).to(
      have_link(href: employees_list_path)
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

    # 勤怠登録の各種リンクが存在していることを確認
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
  # 引数として渡した一般社員の社員インスタンスをもとに社員新規登録画面(個別)にアクセスし、
  # 必要な情報を入力する。
  #
  # # 引数
  # * emoloyee
  # 新規登録(個別)したい一般社員の社員モデルクラスのインスタンス
  #
  def fill_in_employee_registration(employee:)
    # ----- 前提として、社員の新規登録画面であることを確認する
    expect(page).to(
      have_title("社員登録")
    )

    # ----- 社員情報を入力
    # テキストエリア入力
    [
      # メールアドレス
      [:employee_email, employee.email],

      # 社員コード
      [:employee_employee_code, employee.employee_code],

      # 社員名(姓
      [:employee_employee_last_name, employee.employee_last_name],

      # 社員名(名
      [:employee_employee_first_name, employee.employee_first_name],

      # 社員名カナ(姓
      [:employee_employee_last_name_kana, employee.employee_last_name_kana],

      # 社員名カナ(名
      [:employee_employee_first_name_kana, employee.employee_first_name_kana],

      # 年齢
      [:employee_age, employee.age],

      # パスワード
      [:employee_password, employee.password],

      # 確認用パスワード
      [:employee_password_confirmation, employee.password],
    ].each do |attribute_name, value|
      fill_in(
        attribute_name,
        with: value,
      )
    end

    # ドロップダウン入力
    [
      # 権限
      # ※複数の権限が付与されている場合、最初の1件目を設定する
      [employee.roles.first.role_name, "employee[role_ids]"],

      # 就業状況
      [employee.employment_status.status_name, "employee[employment_status_id]"],
    ].each do |value, attribute_name|
      # 就業状況
      select(
        value,
        from: attribute_name,
      )
    end
  end

  # ----------------------------------------------------
  # # 概要
  # 社員情報登録画面で登録した情報が想定通りDBに登録されていることを確認する。
  # 引数として渡した一般社員の社員インスタンスと、そのインスタンスと同じ社員コードを持つDBの
  # 社員情報の情報が一致することを確認する。
  #
  # パスワードだけは、DBに格納された時点で暗号化されるため、実際にログインして確認する。
  #
  # # 引数
  # * emoloyee
  # 確認したい一般社員の社員モデルクラスのインスタンス
  #
  def matches_registered_employee(employee:)
    # ----- 登録された社員情報を抽出
    registred_employee = Employee.find_by(employee_code: employee.employee_code)

    # ----- 引数の社員情報インスタンスと、登録されている社員情報が一致すること
    [
      # メールアドレス
      :email,

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
    ].each do |attribute_name|
      expect(employee.send(attribute_name)).to eq registred_employee.send(attribute_name)
    end

    # ----- パスワードの確認のためにログインし直す
    click_button("ログアウト")
    login_macro(employee: employee)
    expect(page).to(
      have_title("メインメニュー")
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
