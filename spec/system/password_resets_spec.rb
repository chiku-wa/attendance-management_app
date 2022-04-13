require "rails_helper"

RSpec.describe "パスワードリセット機能に関するシステムテスト", type: :system do
  scenario "メールアドレスが未入力の場合はエラーが表示されること" do
    visit(root_path)

    # パスワードリセット画面に遷移する
    click_link("パスワードをお忘れの方はこちらをクリック")

    # 何も入力せずにパスワードをリセットを実施
    click_button("パスワードをリセットする")

    expect(
      find(:xpath, "//div[@id='error_explanation']")
    ).to have_content("・メールアドレスを入力してください")
  end
end
