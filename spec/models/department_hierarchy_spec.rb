require "rails_helper"

RSpec.describe "部署階層モデルのテスト", type: :model do
  # ----- テストデータを登録
  # 部署テーブル
  [
    :department_A,
    :department_A_sales,
    :department_A_sales_department1,
    :department_A_sales_department1_division1,
    :department_A_sales_department1_division2,
  ].each do |fb|
    # バリデーションテストを正確にテストするために、親テーブルである部署情報を登録する
    # ※presenceのRSpecテスト実行時、部署テーブルのレコードを保存しないまま部署階層テーブル
    #  をテストしようとすると、すべての属性がnilになり、正常にテストできないため
    let(fb) { FactoryBot.create(fb) }
  end

  before do
    # --- テストデータを登録
    # 部署階層テーブル
    @department_hierarcy = DepartmentHierarchy.new(
      parent_department: department_A,
      child_department: department_A_sales,
      generations: 0,
    )
  end

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(@department_hierarcy).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- 世代のテスト
    it "世代がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @department_hierarcy,
        attribute: :generations,
      )
    end
  end

  context "複合ユニークのテスト" do
    it "親部署ID、子部署IDの組み合わせが同じレコードが複数存在する場合はバリデーションエラーとなること" do
      @department_hierarcy.save
      valid_uniques(
        model: @department_hierarcy,
        attribute_and_value_hash: {
          parent_department: department_A_sales_department1,
          child_department: department_A_sales_department1_division1,
        },
        is_case_sensitive: false,
      )
    end
  end
end
