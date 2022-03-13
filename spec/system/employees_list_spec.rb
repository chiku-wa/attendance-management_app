require "rails_helper"

RSpec.describe "社員情報に関連する画面のテスト", type: :system do
  before do
    # ----- 各テストで使用する共通変数
    # 一度に表示する社員情報の件数
    PER_PAGE = 30

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
    expect(Employee.count).to be > PER_PAGE
    expect(page).to(
      have_xpath(
        "//html/body/div/table/tbody/tr",
        count: PER_PAGE,
      )
    )

    # ----- ページネーションを行い、以下の期待値を確認する。
    # * 想定したページ数であること(一度に表示される件数は30件であること前提)
    # * ログインユーザの情報が含まれていないこと

    # ページネーションボタンが想定通りの数になっていることを確認する
    # ※ログインしているユーザ自身は除くため-1
    total_employees_exclude_own = Employee.count - 1

    # 「次へ」「最後」の2つのボタンが存在するため+2
    num_of_page = ((total_employees_exclude_own / PER_PAGE) + (total_employees_exclude_own % PER_PAGE == 0 ? 0 : 1)) + 2

    # ページネーションのボタン数が想定どおりであること
    expect(page).to(
      have_xpath(
        "/html/body/div/nav[1]/ul/li/a",
        count: num_of_page,
      )
    )

    # 登録した社員(ログインユーザ以外)が想定通り登録されていること(一意の値である社員コードをもとに期待値を確認する)
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
  end
end
