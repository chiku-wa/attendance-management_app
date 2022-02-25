require "rails_helper"

RSpec.describe "社員情報に関連する画面のテスト", type: :system do
  before do
    # 権限を登録する.
    @role_admin = FactoryBot.create(:role_admin)
    @role_manager = FactoryBot.create(:role_manager)
    @role_common = FactoryBot.create(:role_common)

    # 社員情報を登録する
    @employee_own = FactoryBot.create(:employee)
    @employee_other_manager = FactoryBot.create(:employee_absences)
    @employee_other_common = FactoryBot.create(:employee_retirement)

    # 権限を付与
    @employee_own.roles << @role_admin
    @employee_other_manager.roles << @role_manager
    @employee_other_common.roles << @role_common
  end

  scenario "[社員情報一覧]ログインしているユーザが除外されて一覧出力されていること" do
    # ログインする
    login_macro(employee: @employee_own)

    # 社員情報一覧ページにアクセスし、想定通りに遷移すること
    visit(employees_list_path)
    expect(page).to(
      have_title("社員情報一覧")
    )

    # 登録した社員の数(ログインユーザ除く)だけ社員情報が出力されていることを確認する
    expect(page).to(
      have_xpath(
        "//html/body/div/table/tbody/tr",
        count: 2,
      )
    )
    # 登録した社員(ログインユーザ以外)が想定通り登録されていること(一意の値である社員コードをもとに期待値を確認する)
    [
      @employee_other_manager,
      @employee_other_common,
    ].each do |emp|
      expect(
        find(:xpath, "//html/body/div/table/tbody/tr[@id='#{emp.employee_code}']")
      ).to have_content(emp.employee_code)
    end
  end
end
