require "rails_helper"

RSpec.describe Rank, type: :model do
  before do
    # ----- テストデータを登録
    @rank_A = FactoryBot.build(:rank_A)
    @rank_A.save
  end

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(@rank_A).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- ランクコードのテスト
    it "ランクコードがスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @rank_A,
        attribute: :rank_code,
      )
    end

    it "ランクコードが規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: @rank_A,
        attribute: :rank_code,
        valid_number_of_characters: 2,
      )
    end

    it "ランクコードに重複した値が登録された場合はエラーとなること" do
      valid_unique(
        model: @rank_A,
        attribute: :rank_code,
        value: "B",
        is_case_sensitive: false,
      )
    end
  end
end
