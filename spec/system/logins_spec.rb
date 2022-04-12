require "rails_helper"

RSpec.describe "ログイン機能に関するシステムテスト", type: :system do
  before do
    # 権限を登録する
    @role_admin = FactoryBot.create(:role_admin)
    @role_manager = FactoryBot.create(:role_manager)
    @role_common = FactoryBot.create(:role_common)

    # 社員情報を登録する
    @employee = FactoryBot.create(:employee)
  end

  scenario "必須項目が未入力、またはメールアドレスやパスワードが誤っている場合はエラーが表示されること" do
    # 権限を付与
    @employee.roles << @role_admin

    # ログインに必要な各情報に対して不正な情報を入力して期待値を確認する
    # 以下の二次元配列を用いて動的に値を入力し、
    # [
    #   [<社員モデルクラスのプロパティ1>, <値1>]
    #   [<社員モデルクラスのプロパティ2>, <値2>]
    #   ...etc
    # ]
    # ※配列で明示していないプロパティの値は、ログインに問題のない正常な値とする
    [
      ["email", nil],
      ["email", "invalid_email@example.com"],
      ["password", nil],
      ["password", "invalid_password"],
    ].each do |property, value|
      # ログインの必須項目を未入力にし、ログイン処理を実施
      @employee.send("#{property}=", value)
      login_macro(employee: @employee)

      expect(
        find(:xpath, "//p[@id='message_alert']")
      ).to have_content("メールアドレスまたはパスワードが違います。")

      # 未入力にした情報をもとに戻す
      @employee.reload
    end
  end
end
