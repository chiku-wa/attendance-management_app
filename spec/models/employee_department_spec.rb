require "rails_helper"

RSpec.describe "社員-部署のテスト", type: :model do
  # ===== テストデータを登録
  let(:employee_department_regular) { FactoryBot.build(:employee_department_regular) }

  before do
    # 外部キーのデータをsaveする(子テーブルのテストが正常に実行できないため)
    employee_department_regular.save
  end

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(employee_department_regular).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- 社員のテスト
    it "社員がnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: employee_department_regular,
        attribute: :employee,
      )
    end

    # ---------------------
    # --- 部署のテスト
    it "部署がnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: employee_department_regular,
        attribute: :department,
      )
    end

    # ---------------------
    # --- 所属種別のテスト
    it "所属種別がnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: employee_department_regular,
        attribute: :affiliation_type,
      )
    end

    # ---------------------
    # --- 着任日のテスト
    it "着任日がnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: employee_department_regular,
        attribute: :start_date,
      )
    end

    # ---------------------
    # --- 離任日のテスト
    it "離任日がnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: employee_department_regular,
        attribute: :end_date,
      )
    end
  end

  context "カスタムバリデーションのテスト" do
    it "着任日>離任日の場合はバリデーションエラーとなり、想定通りのエラーメッセージが設定されること" do
      twz = Time.zone.parse("2022-09-13 00:00:00")

      # ----- バリデーションエラーになるパターンのテスト
      [
        # 部署の着任日 = 離任日 ※同日(日付をまたがない)の場合
        0,

        # 部署の着任日 > 離任日 ※同日(日付をまたがない)の場合
        -1.second,

        # 部署の着任日 > 離任日 ※同日(日付をまたぐ)の場合
        -1.day,
      ].each do |diff|
        employee_department_regular.start_date = twz
        employee_department_regular.end_date = employee_department_regular.start_date + diff
        expect(employee_department_regular).not_to be_valid
        expect(employee_department_regular.errors.messages[:start_date]).to eq(
          ["離任日が着任日より未来日(着任日 < 離任日)となるようにしてください。"]
        )
      end

      # ----- バリデーションエラーにならないパターンのテスト
      # 部署の着任日 < 離任日 ※同日(日付をまたぐ)の場合はバリデーションエラーにならないこと
      employee_department_regular.start_date = twz
      employee_department_regular.end_date = employee_department_regular.start_date + 1.day
      expect(employee_department_regular).to be_valid
    end
  end
end
