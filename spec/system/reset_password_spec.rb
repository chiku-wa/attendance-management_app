require "rails_helper"

RSpec.describe "パスワードリセット機能に関するシステムテスト", type: :system do
  before do
    # ----- テストデータを登録する
    # 社員データ作成
    @role_common = FactoryBot.create(:role_common)
    @employee = FactoryBot.create(:employee)
    @employee.roles << @role_common

    # パスワードを明示的に設定(リセット前後のログイン確認に使用するため)
    @employee.password = "before_password"
    @employee.save
  end

  scenario "パスワードリセットメールが送信され、パスワードリセット作業が実施できること" do
    # ----- 前提として、今のアカウントで正常にログインできること
    login_macro_with_common(employee: @employee)

    # パスワードリセット機能を使用するためにログアウトする
    click_button("ログアウト")

    # ----- パスワードリセットをリクエスト
    reset_password_macro(employee: @employee)

    # ----- メールが受信できていることを確認する
    expect(ActionMailer::Base.deliveries.count).to eq(1)

    # ----- メール本文内にパスワードリセット用URLが存在すること
    # メール本文のリンクから、パスワードリセットURLを抜き出してページにアクセスする
    mail = ActionMailer::Base.deliveries.last
    url = mail.html_part.body.to_s[/class=\"btn-password-reset\" href="(?<url>.+?)"/, :url]
    visit(url)

    # パスワード再設定画面が表示されること
    expect(page).to(
      have_title("パスワードを変更")
    )

    # パスワードを設定する
    new_password = "after_password"
    fill_in("employee_password", with: new_password)
    fill_in("employee_password_confirmation", with: new_password)
    click_button("パスワードを変更")

    # パスワードが変更が成功すること
    expect(
      find(:xpath, "//p[@id='message_notice']")
    ).to have_content("パスワードが正しく変更されました。")

    # ----- 想定通りのパスワードでログインできること
    # 変更前パスワード：ログイン不可　であること
    visit(root_path)
    fill_in(:employee_email, with: @employee.email)
    fill_in(:employee_password, with: @employee.password)
    click_button("ログイン")

    expect(page).to(
      have_content("メールアドレスまたはパスワードが違います。")
    )

    # 変更後パスワード：ログイン可　であること
    @employee.password = new_password
    login_macro_with_common(employee: @employee)
  end

  scenario "存在しないメールアドレスの場合はエラーが表示されること" do
    # TOP画面(=ログイン画面)に遷移する
    visit(root_path)

    # パスワードリセット画面に遷移する
    click_link("パスワードをお忘れの方はこちらをクリック")

    # 何も入力せずにパスワードをリセットを実施
    fill_in("employee_email", with: "invalid_address@example.com")
    click_button("パスワードをリセットする")

    expect(
      find(:xpath, "//div[@id='error_explanation']")
    ).to have_content("・メールアドレスは見つかりませんでした。")
  end

  scenario "メールアドレスが未入力の場合はエラーが表示されること" do
    # TOP画面(=ログイン画面)に遷移する
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
