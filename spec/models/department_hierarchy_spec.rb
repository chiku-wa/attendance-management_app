require "rails_helper"

RSpec.describe "部署階層モデルのテスト", type: :model do
  # ----- テストデータを登録
  # 部署データの登録
  let(:department_A) { FactoryBot.build(:department_A) }
  let(:department_A_sales) { FactoryBot.build(:department_A_sales) }
  let(:department_A_sales_department) { FactoryBot.build(:department_A_sales_department) }
  let(:department_A_sales_department_division) { FactoryBot.build(:department_A_sales_department_division) }

  before do
    @department_hierarcy = DepartmentHierarchy.new(
      parent_department: department_A,
      child_department: department_A_sales,
    )
  end

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(@department_hierarcy).to be_valid
    end
  end

  context "複合ユニークのテスト" do
    it "親部署ID、子部署IDの組み合わせが同じレコードが複数存在する場合はバリデーションエラーとなること" do
      @department_hierarcy.save
      valid_uniques(
        model: @department_hierarcy,
        attribute_and_value_hash: {
          parent_department: department_A_sales_department,
          child_department: department_A_sales_department_division,
        },
        is_case_sensitive: false,
      )
    end
  end
end
