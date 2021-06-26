require "rails_helper"

RSpec.describe "部署モデルのテスト", type: :model do
  # ----- テストデータを登録
  let(:department_A) { FactoryBot.build(:department_A) }

  before do
    department_A.save
  end

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(department_A).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- 部署コードのテスト
    it "部署コードがスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: department_A,
        attribute: :department_code,
      )
    end

    it "部署コードが規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: department_A,
        attribute: :department_code,
        valid_number_of_characters: 12,
      )
    end

    # ---------------------
    # --- 設立日のテスト
    it "設立日がnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: department_A,
        attribute: :establishment_date,
      )
    end

    # ---------------------
    # --- 廃止日のテスト
    it "廃止日がnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: department_A,
        attribute: :abolished_date,
      )
    end
  end

  # ---------------------
  # --- 部署名のテスト
  it "部署名がスペース、空文字のみの場合はバリデーションエラーとなること" do
    valid_presence(
      model: department_A,
      attribute: :department_name,
    )
  end

  it "部署名が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
    valid_maximum_num_of_char(
      model: department_A,
      attribute: :department_name,
      valid_number_of_characters: 200,
    )
  end

  # ---------------------
  # --- 部署名(カナ)のテスト
  it "部署名(カナ)がスペース、空文字のみの場合はバリデーションエラーとなること" do
    valid_presence(
      model: department_A,
      attribute: :department_kana_name,
    )
  end

  it "部署名(カナ)が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
    valid_maximum_num_of_char(
      model: department_A,
      attribute: :department_kana_name,
      valid_number_of_characters: 400,
    )
  end

  context "複合ユニークのテスト" do
    it "部署コード、設立日、廃止日の組み合わせが同じレコードが複数存在する場合はバリデーションエラーとなること" do
      valid_uniques(
        model: department_A,
        attribute_and_value_hash: {
          department_code: "A01B01000000",
          establishment_date: Time.zone.local(2021, 5, 1, 0, 0, 0),
          abolished_date: Time.zone.local(2021, 5, 31, 23, 59, 59),
        },
        is_case_sensitive: false,
      )
    end
  end
end
