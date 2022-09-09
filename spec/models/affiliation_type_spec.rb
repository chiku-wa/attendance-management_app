require "rails_helper"

RSpec.describe "所属種別のテスト", type: :model do
  # ===== テストデータを登録
  # 所属種別(本務)
  let(:affiliation_type_regular) { FactoryBot.build(:affiliation_type_regular) }

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(affiliation_type_regular).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- 所属種別名のテスト
    it "所属種別名がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: affiliation_type_regular,
        attribute: :affiliation_type_name,
      )
    end

    it "所属種別名が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: affiliation_type_regular,
        attribute: :affiliation_type_name,
        valid_number_of_characters: 10,
      )
    end

    it "所属種別名に重複した値が登録された場合はエラーとなること" do
      valid_unique(
        model: affiliation_type_regular,
        attribute: :affiliation_type_name,
        value: "ABC123",
        is_case_sensitive: false,
      )
    end
  end
end
