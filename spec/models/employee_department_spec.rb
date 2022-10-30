require "rails_helper"

RSpec.describe "社員-部署のテスト", type: :model do
  # ===== テストデータを登録
  # ----- 所属種別テーブル
  [
    :affiliation_type_regular,
    :affiliation_type_additional,
  ].each do |fb|
    let(fb) { FactoryBot.create(fb) }
  end

  # ----- 社員テーブル
  let(:employee_work) { FactoryBot.build(:employee) }

  # ----- 部署テーブル
  let(:department_A) { FactoryBot.create(:department_A) }

  before do
    # テストに使用するデータを登録
    @employee_department_regular = EmployeeDepartment.new(
      employee: employee_work,
      department: department_A,
      affiliation_type: affiliation_type_regular,
      start_date: Time.zone.local(2021, 4, 1, 0, 0, 0),
      end_date: Time.zone.local(9999, 12, 31, 23, 59, 59),
    )
  end

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(@employee_department_regular).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- 社員のテスト
    it "社員がnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @employee_department_regular,
        attribute: :employee,
      )
    end

    # ---------------------
    # --- 部署のテスト
    it "部署がnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @employee_department_regular,
        attribute: :department,
      )
    end

    # ---------------------
    # --- 所属種別のテスト
    it "所属種別がnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @employee_department_regular,
        attribute: :affiliation_type,
      )
    end

    # ---------------------
    # --- 着任日のテスト
    it "着任日がnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @employee_department_regular,
        attribute: :start_date,
      )
    end

    # ---------------------
    # --- 離任日のテスト
    it "離任日がnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @employee_department_regular,
        attribute: :end_date,
      )
    end
  end

  context "カスタムバリデーションのテスト" do
    it "着任日>離任日の場合はバリデーションエラーとなり、想定通りのエラーメッセージが設定されること" do
      twz = Time.zone.parse("2022-09-13 23:00:00")

      # ----- バリデーションエラーになるパターンのテスト
      [
        # 部署の着任日 = 離任日 ※同日(日付をまたがない)の場合
        0,

        # 部署の着任日 > 離任日 ※同日(日付をまたがない)の場合
        -1.second,

        # 部署の着任日 > 離任日 ※同日(日付をまたぐ)の場合
        -1.day,
      ].each do |diff|
        @employee_department_regular.start_date = twz
        @employee_department_regular.end_date = @employee_department_regular.start_date + diff
        expect(@employee_department_regular).not_to be_valid
        expect(@employee_department_regular.errors.messages[:start_date]).to eq(
          ["離任日が着任日より未来日(着任日 < 離任日)となるようにしてください。"]
        )
      end

      # ----- バリデーションエラーにならないパターンのテスト
      # 部署の着任日 < 離任日 ※同日(日付をまたぐ)の場合はバリデーションエラーにならないこと
      @employee_department_regular.start_date = twz
      @employee_department_regular.end_date = @employee_department_regular.start_date + 1.day
      expect(@employee_department_regular).to be_valid
    end

    it "有効な本務が複数登録されようとした場合はバリデーションエラーとなり、想定通りのエラーメッセージが表示されること" do
      # 本務を登録する
      @employee_department_regular.save
      expect(
        EmployeeDepartment.where(
          employee_id: @employee_department_regular.employee.id,
          affiliation_type_id: affiliation_type_regular.id,
        ).size
      ).to eq 1

      # 無効な本務(離任日≠9999/12/31 23:59:58)であれば、複数登録しようとしてもバリデーションエラーとならないこと
      @employee_department_regular.end_date = Time.zone.parse("9999-12-31 23:59:58")
      expect(@employee_department_regular).to be_valid

      # 有効な本務(離任日=999/12/31)であれば、複数登録時にバリデーションエラーとなること
      @employee_department_regular.end_date = Time.zone.parse("9999-12-31 23:59:59")
      expect(@employee_department_regular).not_to be_valid
      expect(@employee_department_regular.errors.messages[:affiliation_type]).to eq(
        ["1人の社員には設定できる本務数は1個までです。"]
      )

      # TODO:
      # DBの制約違反が発生すること
      # expect {
      #   model.save(validate: false)
      # }.to raise_error(ActiveRecord::NotNullViolation)
    end
  end
end
