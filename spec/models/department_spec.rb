require "rails_helper"

RSpec.describe "部署モデルのテスト", type: :model do
  before do
    # ----- テストデータを登録
    @department = FactoryBot.build(:department_level1)
    @department.save

    @department = FactoryBot.build(:department_level2_1)
    @department.save

    @department = FactoryBot.build(:department_level3_1)
    @department.save

    @department = FactoryBot.build(:department_level4_1)
    @department.save
  end

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(@department).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- 部署コードのテスト
    it "部署コードがスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @department,
        attribute: :department_code,
      )
    end
  end
end
