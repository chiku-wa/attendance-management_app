require "rails_helper"

RSpec.describe "deviseのメール機能に関するテスト", type: :mailer do
  before do
    # ----- テストデータを登録する
    load(Rails.root.join("db", "seeds.rb"))

    # 一般社員
    @employee = Employee
      .includes(:roles)
      .find_by("#{Role.table_name}.role_name" => I18n.t("master_data.role.common"))
    @employee.password = "pw_common"
    @employee.save
  end

  scenario "パスワードリセットメールが想定通りであること" do
    # ----- メールを送信する
    @employee.send_reset_password_instructions

    # ----- 受信したメールが期待どおりであること
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
end
