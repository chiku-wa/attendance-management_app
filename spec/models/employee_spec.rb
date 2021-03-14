require "rails_helper"

RSpec.describe "社員モデルのテスト", type: :model do
  before do
    # ----- テストデータを登録
    # 就業状況
    employee_duty = EmploymentStatus.new(
      status_name: "本務",
    )
    employee_duty.save

    # 社員(本務)
    @employee_duty = Employee.new(
      employee_code: "Tom",
      employee_name: "山田　太郎",
      employee_name_kana: "ヤマダ　タロウ",
      age: 30,
      employment_status: employee_duty,
    )
    @employee_duty.save
  end

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(@employee_duty).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- 氏名のテスト
    it "氏名がスペース、空文字のみの場合はバリデーションエラーとなること" do
      # 半角スペース
      valid_presence(
        model: @employee_duty,
        attribute: :employee_name,
      )
    end

    it "氏名が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: @employee_duty,
        attribute: :employee_name,
        valid_number_of_characters: 110,
      )
    end
  end
end
