require "rails_helper"

RSpec.describe "社員-権限モデルのテスト", type: :model do
  # ===== テストデータを登録
  # ----- 社員
  let(:employee_work) { FactoryBot.create(:employee) }
  let(:employee_absences) { FactoryBot.create(:employee_absences) }
  # ----- 権限
  let(:role_admin) { FactoryBot.create(:role_admin) }
  let(:role_manager) { FactoryBot.create(:role_manager) }

  let(:employee_role_admin) {
    EmployeeRole.new(
      employee: employee_work,
      role: role_admin,
    )
  }

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(employee_role_admin).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- 社員のテスト
    it "社員がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: employee_role_admin,
        attribute: :employee,
      )
    end
  end

  context "複合ユニークのテスト" do
    it "社員ID、権限IDの組み合わせが同じレコードが複数存在する場合はバリデーションエラーとなること" do
      valid_uniques(
        model: employee_role_admin,
        attribute_and_value_hash: {
          employee: employee_absences,
          role: role_manager,
        },
        is_case_sensitive: false,
      )
    end
  end
end
