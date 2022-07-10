require "rails_helper"

RSpec.describe "メイン画面のシステムテスト", type: :system do
  before do
    # 権限を登録する
    @role_admin = FactoryBot.create(:role_admin)
    @role_manager = FactoryBot.create(:role_manager)
    @role_common = FactoryBot.create(:role_common)

    # 社員情報を登録する
    @employee = FactoryBot.create(:employee)
  end

  scenario "システム管理者の画面に遷移すること" do
    # 権限を付与
    @employee.roles << @role_admin

    # ログインする
    login_macro(employee: @employee)

    expect(page).to(
      have_title("メインメニュー")
    )

    # その権限でしか利用できない機能のリンクが表示されていること
    expect(page).to(
      have_link("社員一覧", href: employees_list_path)
    )
  end

  scenario "マネージャーの画面に遷移すること" do
     # 権限を付与
     @employee.roles << @role_manager

     # ログインする
     login_macro(employee: @employee)

    expect(page).to(
      have_title("メインメニュー")
    )

    # TODO:マネージャの画面を実装したらテストを追記

  end

  scenario "社員の画面に遷移すること" do
    # ========== 社員
    # ----- テストを実施
    # 権限を付与
    @employee.roles << @role_common

    # ログインする
    login_macro_with_common(employee: @employee)

    # ----- テスト後の後処理
    # ログアウト
    visit(destroy_employee_session_path)
  end
end
