require "rails_helper"

RSpec.describe Role, type: :model do
  # ===== テストデータを登録
  let(:role_admin) { FactoryBot.build(:role_admin) }

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(role_admin).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- 権限名のテスト
    it "権限名がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: role_admin,
        attribute: :role_name,
      )
    end

    it "権限名が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: role_admin,
        attribute: :role_name,
        valid_number_of_characters: 20,
      )
    end

    it "権限名に重複した値が登録された場合はエラーとなること" do
      valid_unique(
        model: role_admin,
        attribute: :role_name,
        value: "システム管理者",
        is_case_sensitive: false,
      )
    end
  end
end
