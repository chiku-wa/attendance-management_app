require "rails_helper"

RSpec.describe "パスワードリセット機能に関するシステムテスト", type: :system do
  scenario "想定通りの件名、本文のパスワードリセットメールが送信されること" do
    # ----- 事前準備
    # ログインする社員情報を登録する
    @role_common = FactoryBot.create(:role_common)
    @employee = FactoryBot.create(:employee)
    @employee.roles << @role_common

    # ----- パスワードリセット操作を実施
    # TOP画面(=ログイン画面)に遷移する
    visit(root_path)

    # パスワードリセット画面に遷移する
    click_link("パスワードをお忘れの方はこちらをクリック")

    # メールアドレスを入力してパスワードをリセットを実施
    fill_in("employee_email", with: @employee.email)
    click_button("パスワードをリセットする")

    sleep 1
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts page.body
    # ----- 画面上に想定通りのメッセージが表示されること
    # ログイン画面に遷移し、メッセージが表示されること
    expect(page).to(
      have_title("ログイン")
    )

    expect(
      find(:xpath, "//p[@id='message_notice']")
    ).to have_content("パスワードの再設定を受け付けました。メールボックスをご確認ください。")

    # ----- 受信したメールが期待どおりであることを確認する
    mail = ActionMailer::Base.deliveries.last
    # 差出人はSMTPユーザと同一であること
    expect(mail.from).to eq(["noreply.attendance.mng@gmail.com"])
    # 宛先は社員のメールアドレスであること
    expect(mail.to).to eq([@employee.email])
    # 件名が期待どおりであること
    expect(mail.subject).to eq("【#{I18n.t("app_name")}】パスワードの再設定をお願い致します")
    # Ccは存在しないこと
    expect(mail.cc).to be_nil
    # HTML、プレーンテキストのメール本文にパスワードリセット用のURLが含まれていること
    [
      mail.html_part.body.to_s,
      mail.text_part.body.to_s,
    ].each do |body|
      expect(body).to match(/.+#{edit_employee_password_path}.+/)
    end
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
