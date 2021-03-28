require "rails_helper"

RSpec.describe "社員モデルのテスト", type: :model do
  before do
    # ----- テストデータを登録
    # 就業状況(在職)
    employment_status_work = FactoryBot.build(:employment_status_work)
    employment_status_work.save

    # 社員
    @employee_work = FactoryBot.build(:employee)
    @employee_work.employment_status = employment_status_work
    @employee_work.save
  end

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(@employee_work).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- 社員コードのテスト
    it "氏名がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @employee_work,
        attribute: :employee_code,
      )
    end

    it "氏名が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: @employee_work,
        attribute: :employee_code,
        valid_number_of_characters: 6,
      )
    end

    # --- 社員名のテスト
    it "社員名がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @employee_work,
        attribute: :employee_name,
      )
    end

    it "社員名が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: @employee_work,
        attribute: :employee_name,
        valid_number_of_characters: 110,
      )
    end

    # --- 社員名(フリガナ)のテスト
    it "社員名(フリガナ)がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @employee_work,
        attribute: :employee_name_kana,
      )
    end

    it "社員名(フリガナ)が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: @employee_work,
        attribute: :employee_name_kana,
        valid_number_of_characters: 220,
      )
    end

    # --- 年齢のテスト
    it "年齢がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @employee_work,
        attribute: :age,
      )
    end

    # --- 就業状況のテスト
    it "就業状況がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @employee_work,
        attribute: :employment_status_id,
      )
    end
  end
end
