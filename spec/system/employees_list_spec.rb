require "rails_helper"

RSpec.describe "社員情報に関連する画面のテスト", type: :system do
  before do
    # ----- 各テストで使用する共通変数
    # 一度に表示する社員情報の件数
    @PER_PAGE = 30

    # ----- テストデータを登録する
    load(Rails.root.join("db", "seeds.rb"))

    # ----- テストで使用する社員情報を取得(テスト内でログインできるようにするため、パスワードの再設定を行う)
    # システム管理者
    @employee_admin = Employee
      .includes(:roles)
      .find_by("#{Role.table_name}.role_name" => I18n.t("master_data.role.admin"))
    @employee_admin.password = "pw_admin"
    @employee_admin.save

    # マネージャ
    @employee_manager = Employee
      .includes(:roles)
      .find_by("#{Role.table_name}.role_name" => I18n.t("master_data.role.manager"))
    @employee_manager.password = "pw_manager"
    @employee_manager.save

    # 一般社員
    @employee_common = Employee
      .includes(:roles)
      .find_by("#{Role.table_name}.role_name" => I18n.t("master_data.role.common"))
    @employee_common.password = "pw_common"
    @employee_common.save
  end

  scenario "ログインしているユーザ以外が一覧出力されること" do
    # ----- ログインし、社員情報一覧に遷移する
    login_macro_with_emplpoyee_list(employee: @employee_admin)

    # ----- 登録されている社員数が30件を超えている場合は、一度に表示される社員数は30件であること
    expect(Employee.count).to be > @PER_PAGE
    expect(page).to(
      have_xpath(
        "//html/body/div/table/tbody/tr",
        count: @PER_PAGE,
      )
    )

    # ----- ページネーションを行い、以下の期待値を確認する。
    # * 想定したページ数であること(一度に表示される件数は30件であること前提)
    # * ログインユーザの情報が含まれていないこと

    # [想定したページ数であること]
    # 社員数の合計を割り出す(ログインしているユーザ自身は除くため-1)
    total_employees_exclude_own = Employee.count - 1

    # 「次へ」「最後」の2つのボタンが存在するため+2
    num_of_page = ((total_employees_exclude_own / @PER_PAGE) + (total_employees_exclude_own % @PER_PAGE == 0 ? 0 : 1)) + 2

    expect(page).to(
      have_xpath(
        "/html/body/div/nav[1]/ul/li/a",
        count: num_of_page,
      )
    )

    # [ログインユーザの情報が含まれていないこと]
    # 一意の値である社員コードをもとに期待値を確認する
    [
      @employee_manager,
      @employee_common,
    ].each do |emp|
      expect(
        find(:xpath, "//html/body/div/table/tbody/tr[@id='#{emp.employee_code}']")
      ).to have_content(emp.employee_code)
    end
  end

  scenario "ヘッダをクリックすると、昇順・降順にソートされること" do
    # ログインし、社員情報一覧に遷移する
    login_macro_with_emplpoyee_list(employee: @employee_admin)

    # ========== 前提の確認：30件表示されており、かつ初期表示時は社員コードの昇順になっていること
    # 画面に表示されるであろう状態と同じソート条件で社員を取得する
    employees_order_by_employee_code = Employee
      .where.not(id: @employee_admin.id) # ログインしているユーザを除外する
      .order(:employee_code) # 社員コードの昇順
      .limit(@PER_PAGE) # 一度に表示される社員数

    expect_same_order_of_employee_list(employees_order_by_employee_code)

    # ========== ソートボタン押下時の確認
    # 各項目でソートして想定通りの挙動になることを確認する
    # ソートキーが外部テーブルに存在する場合、テーブル結合が必要となるため、以下の二次元配列を定義する
    # [<includesメソッドで指定するプロパティ名>, <カラム名>]
    [
      ["roles", "role_name"], #権限
      ["employees", "employee_name_kana"], # 氏名 ※画面上では氏名(漢字)だが、内部的にはカナでソートしているため、期待値の確認はカナを基準とする
      ["employees", "email"], #メールアドレス
      ["employment_status", "status_code"], #就業状況 ※画面上では就業状況(名称)だが、内部的にはコードでソートしているため、期待値の確認はコードを基準とする
    ].each do |table_name, sort_column|
      # 画面に表示されるであろう状態と同じソート条件で社員を取得する
      # ソートキーが外部テーブル(社員情報テーブルではない)の場合、includesの引数として設定する
      include_table = table_name == "employees" ? [] : [table_name]

      # ----- 昇順のテスト
      # 1回目のソートボタン押下(昇順)
      click_link("sort_#{sort_column}")

      # 期待値確認用に、社員情報一覧の出力条件と同じ条件で社員情報を抽出
      employees = Employee
        .where.not(id: @employee_admin.id) # ログインしているユーザを除外する
        .includes(include_table)
        .order("#{table_name.pluralize}.#{sort_column}")
        .order("employee_code asc")
        .limit(@PER_PAGE)

      expect_same_order_of_employee_list(employees)

      # ----- 降順のテスト
      # 2回目のソートボタン押下(降順)
      click_link("sort_#{sort_column}")

      employees = Employee
        .where.not(id: @employee_admin.id) # ログインしているユーザを除外する
        .includes(include_table)
        .order("#{table_name.pluralize}.#{sort_column} desc")
        .order("employee_code asc")
        .limit(@PER_PAGE)

      expect_same_order_of_employee_list(employees)
    end
  end
end
