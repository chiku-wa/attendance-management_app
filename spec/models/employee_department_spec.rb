require "rails_helper"

RSpec.describe "社員-部署のテスト", type: :model do
  before do
    # ----- テストデータを登録
    @employee_department_regular = FactoryBot.build(:employee_department_regular)
    @employee_department_regular.save
  end

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(@employee_department_regular).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- 社員のテスト
    it "社員がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @employee_department_regular,
        attribute: :employee_id,
      )
    end

    # ---------------------
    # --- 部署のテスト
    it "部署がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @employee_department_regular,
        attribute: :department_id,
      )
    end

    # ---------------------
    # --- 所属種別のテスト
    it "所属種別がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @employee_department_regular,
        attribute: :affilitation_type_id,
      )
    end

    # ---------------------
    # --- 着任日のテスト
    it "着任日がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @employee_department_regular,
        attribute: :start_date,
      )
    end

    # ---------------------
    # --- 離任日のテスト
    it "離任日がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @employee_department_regular,
        attribute: :end_date,
      )
    end
  end
end
