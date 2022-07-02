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
  end

  scenario "システム管理者でログインしている場合は、社員の新規登録画面が表示されること" do
    login_macro(employee: @employee_admin)
    visit(new_employee_registration_path)

    expect(page).to(
      have_title("社員登録")
    )
  end

  scenario "マネージャ、一般社員でログインしている場合は、社員の新規登録画面が表示されないこと" do
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

  scenario "ログインしていない場合は新規登録画面が表示されず、ログイン画面が表示されること" do
    visit(new_employee_registration_path)

    expect(page).to(
      have_title("お探しのページは見つかりませんでした。")
    )
  end
end
