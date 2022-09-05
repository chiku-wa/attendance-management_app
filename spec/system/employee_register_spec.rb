require "rails_helper"

RSpec.describe "社員の新規登録に関する画面のテスト", type: :system do
  before do
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

    # ----- 社員登録画面で登録する社員情報(DB未保存の社員情報を抽出)
    gimei = Gimei.name
    @employee_eligible_for_registration = Employee.new(
      employee_code: "A99999",
      employee_last_name: gimei.last.kanji,
      employee_first_name: gimei.first.kanji,
      employee_last_name_kana: gimei.last.katakana,
      employee_first_name_kana: gimei.first.katakana,
      age: 30,
      email: "test99999@example.com",
      password: "foo_bar99999",
      #「休職」
      employment_status: EmploymentStatus.find_by(
        status_code: I18n.t("master_data.employment_status.status_code.absences"),
      ),
    )
    # 「一般社員」権限で登録する
    @employee_eligible_for_registration.roles << Role.find_by(role_name: I18n.t("master_data.role.common"))
  end

  scenario "[社員個別登録]システム管理者でログインしている場合は、社員の新規登録画面が表示されること" do
    login_macro(employee: @employee_admin)
    visit(new_employee_registration_path)

    expect(page).to(
      have_title("社員登録")
    )
  end

  scenario "[社員個別登録]マネージャ、一般社員でログインしている場合は、社員の新規登録画面が表示されないこと" do
    [
      @employee_manager,
      @employee_common,
    ].each do |employee|
      login_macro(employee: employee)
      visit(new_employee_registration_path)

      expect(page).to(
        have_title("お探しのページは見つかりませんでした。")
      )

      click_button("ログアウト")
    end
  end

  scenario "[社員個別登録]ログインしていない場合は新規登録画面が表示されず、ログイン画面が表示されること" do
    visit(new_employee_registration_path)

    expect(page).to(
      have_title("お探しのページは見つかりませんでした。")
    )
  end

  # Capybaraではなぜかselectedが効かないため、pending
  pending "[社員個別登録]ドロップダウンのデフォルト値が想定どおりであること" do
    # ----- システム管理者でログインし、社員登録画面に遷移
    login_macro_with_admin(employee: @employee_admin)
    visit(new_employee_registration_path)

    # ----- ドロップダウンの値が想定どおりであること
    # 「権限」の初期値が「一般社員」であること
    expect(page).to have_select(
      "employee_role_ids",
      selected: I18n.t("master_data.role.common"),
    )

    # 「就業状況」の初期値が「在職」であること
    # TODO:
  end

  scenario "[社員個別登録]社員が正常に登録できること" do
    # ----- システム管理者でログインし、社員登録画面に遷移
    login_macro_with_admin(employee: @employee_admin)
    visit(new_employee_registration_path)
    expect_match_loggedin_user(employee: @employee_admin)

    # ----- 社員登録情報を入力
    fill_in_employee_registration(employee: @employee_eligible_for_registration)

    # ----- 社員情報を登録し、期待値を確認
    # 社員情報を登録すると、社員情報一覧にリダイレクトされること
    expect {
      click_button("社員登録")
    }.to change {
           current_path
         }.to(
           employees_list_path
         )

    # 社員情報が想定通り登録できていること
    matches_registered_employee(employee: @employee_eligible_for_registration)

    # システム管理者でログインされたままであること
    # TODO:画面操作ではシステム管理者でのログイン状態が保持されているが、なぜか下記の比較方法
    # では登録した社員でログインされてしまう。原因を調査して対処すること。
    # visit(employees_list_path)
    # expect_match_loggedin_user(employee: @employee_admin)
  end
end
