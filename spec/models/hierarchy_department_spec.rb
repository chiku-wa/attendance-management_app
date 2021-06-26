require "rails_helper"

RSpec.describe "部署階層モデルのテスト", type: :model do
  # ===== テストデータを登録
  # ※FactoryBotのassociationで登録しようとすると、親テーブルである部署データを重複して
  # 生成してしまう性質上、同名の部署データを2件以上登録できず、NotNull制約に違反してしまう。
  # よってRSpec内でテストデータを生成する。

  # --- 部署
  # A事業部
  let(:department_A) { FactoryBot.build(:department_A) }

  # 営業部
  let(:department_A_sales) { FactoryBot.build(:department_A_sales) }

  # 第一営業部
  let(:department_A_sales_department) { FactoryBot.build(:department_A_sales_department) }

  # 営業一課
  let(:department_A_sales_department_division) { FactoryBot.build(:department_A_sales_department_division) }

  # [部署階層]
  #  以下の階層を作成する
  # A事業部　A01000000000
  # ┣営業部　A01B01000000
  # ┃┗第一営業部　A01B01C01000
  # 　┗営業一課　　A01B01C01001

  # [1〜2階層目]
  # A事業部　A01000000000
  # ┣営業部　A01B01000000
  # ...
  let(:hierarchy_department_level1and2) {
    HierarchyDepartment.new(
      parent_department: department_A,
      child_department: department_A_sales,
    )
  }

  # [2〜3階層目]
  # ...
  # ┣営業部　A01B01000000
  # ┃┗第一営業部　A01B01C01000
  # ...
  let(:hierarchy_department_level2and3) {
    HierarchyDepartment.new(
      parent_department: department_A_sales,
      child_department: department_A_sales_department,
    )
  }

  # [3〜4階層目]
  # ...
  # ┃┗第一営業部　A01B01C01000
  #  　┗営業一課　　A01B01C01001
  let(:hierarchy_department_level3and4) {
    HierarchyDepartment.new(
      parent_department: department_A_sales_department,
      child_department: department_A_sales_department_division,
    )
  }

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーシandを通過すること" do
      expect(hierarchy_department_level1and2).to be_valid
      expect(hierarchy_department_level2and3).to be_valid
      expect(hierarchy_department_level3and4).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- 親部署のテスト
    it "親部署がnilの場合はバリデーションエラーとなること" do
      hierarchy_department_level1and2.save
      valid_presence(
        model: hierarchy_department_level1and2,
        attribute: :parent_department,
      )
    end

    # ---------------------
    # --- 子部署のテスト
    it "子部署がnilの場合はバリデーションエラーとなること" do
      hierarchy_department_level1and2.save
      valid_presence(
        model: hierarchy_department_level1and2,
        attribute: :child_department,
      )
    end

    # TODO:部署階層の一覧を出力するメソッドを実装したらテストを追記すること
  end
end
