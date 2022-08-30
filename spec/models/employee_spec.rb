require "rails_helper"

RSpec.describe "社員モデルのテスト", type: :model do
  # ===== テストデータを登録
  # ----- 権限テーブル ※社員情報に紐付けるために、buildではなくcreateする
  let(:role_admin) { FactoryBot.create(:role_admin) }
  let(:role_manager) { FactoryBot.create(:role_manager) }
  let(:role_common) { FactoryBot.create(:role_common) }

  # ----- 社員テーブル
  let(:employee_work) { FactoryBot.build(:employee) }

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(employee_work).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- 社員コードのテスト
    it "社員コードがスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: employee_work,
        attribute: :employee_code,
      )
    end

    it "社員コードが規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: employee_work,
        attribute: :employee_code,
        valid_number_of_characters: 6,
      )
    end

    it "社員コードに重複した値が登録された場合はエラーとなること" do
      valid_unique(
        model: employee_work,
        attribute: :employee_code,
        value: "A0001",
        is_case_sensitive: false,
        other_unique_attributes: {
          email: "hoge@example.com",
        },
      )
    end

    # ---------------------
    # --- 社員名(姓)のテスト
    it "社員名(姓)がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: employee_work,
        attribute: :employee_last_name,
      )
    end

    it "社員名(姓)が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: employee_work,
        attribute: :employee_last_name,
        valid_number_of_characters: 100,
      )
    end

    # ---------------------
    # --- 社員名(名)のテスト
    it "社員名(名)がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: employee_work,
        attribute: :employee_first_name,
      )
    end

    it "社員名(名)が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: employee_work,
        attribute: :employee_first_name,
        valid_number_of_characters: 100,
      )
    end

    # ---------------------
    # --- 社員名(姓：名)のテスト
    it "社員名(姓：名)にスペースや空文字が登録された場合でも、バリデーションエラーとならず、値が自動的に設定されること" do
      valid_presence_for_before_validation(
        model: employee_work,
        attribute: :employee_full_name,
      )
    end

    it "社員名(姓：名)が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char_for_before_validation(
        model: employee_work,
        attribute: :employee_full_name,
        valid_number_of_characters: 201,
      )
    end

    # ---------------------
    # --- 社員名カナ(姓)のテスト
    it "社員名カナ(姓)がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: employee_work,
        attribute: :employee_last_name_kana,
      )
    end

    it "社員名カナ(姓)が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: employee_work,
        attribute: :employee_last_name_kana,
        valid_number_of_characters: 200,
      )
    end

    # ---------------------
    # --- 社員名カナ(名)のテスト
    it "社員名カナ(名)がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: employee_work,
        attribute: :employee_first_name_kana,
      )
    end

    it "社員名カナ(名)が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: employee_work,
        attribute: :employee_first_name_kana,
        valid_number_of_characters: 200,
      )
    end

    # ---------------------
    # --- 社員名カナ(姓・名)のテスト
    it "社員名カナ(姓：名)がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence_for_before_validation(
        model: employee_work,
        attribute: :employee_full_name_kana,
      )
    end

    it "社員名カナ(姓：名)が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char_for_before_validation(
        model: employee_work,
        attribute: :employee_full_name_kana,
        valid_number_of_characters: 401,
      )
    end

    # ---------------------
    # --- 年齢のテスト
    it "年齢がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: employee_work,
        attribute: :age,
      )
    end

    # ---------------------
    # --- 就業状況のテスト
    it "就業状況がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: employee_work,
        attribute: :employment_status,
      )
    end

    # ---------------------
    # --- メールアドレスのテスト
    it "メールアドレスがスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: employee_work,
        attribute: :email,
      )
    end

    it "メールアドレスが規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_email(
        model: employee_work,
        attribute: :email,
        valid_number_of_characters: 255,
      )
    end

    it "メールアドレスに重複した値が登録された場合はエラーとなること" do
      valid_unique(
        model: employee_work,
        attribute: :email,
        value: "hoge@example.com",
        is_case_sensitive: false,
        other_unique_attributes: {
          employee_code: "B0002",
        },
      )
    end
  end

  # NOTE:
  # deviseによってデフォルトで追加される以下のカラムはテスト対象外とする(emailのみ、
  # サイズの調整を行っているためテストを実施している)
  # * encrypted_password
  # * reset_password_token
  # * reset_password_sent_at
  # * remember_created_at

  context "has_role?メソッドのテスト" do
    it "権限が付与されていない社員の場合はfalseが返ること" do
      # 前提として社員に権限が付与されていないこと
      expect(employee_work.roles.size).to eq 0

      # 権限がない場合はfalseが返ること
      expect(employee_work.has_role?(role_admin.role_name)).to be_falsey
    end

    it "社員インスタンスがnilの場合はfalseが返ること" do
      # 権限がない場合はfalseが返ること
      employee_work = nil
      expect(employee_work.has_role?(role_admin.role_name)).to be_falsey
    end

    it "権限が付与されている社員の場合はtrueが返ること" do
      # ----- 単一の権限が付与されている場合のテスト
      employee_work.roles << role_admin

      # 権限がある場合はtrueが返ること
      expect(employee_work.has_role?(role_admin.role_name)).to be_truthy

      # 付与されていない権限の場合はfalseが返ること
      expect(employee_work.has_role?(role_manager.role_name)).to be_falsey
      expect(employee_work.has_role?(role_common.role_name)).to be_falsey

      # ----- 複数の権限が付与されている場合のテスト
      # 権限がある場合はtrueが返ること
      employee_work.roles << role_manager
      expect(employee_work.has_role?(role_manager.role_name)).to be_truthy

      employee_work.roles << role_common
      expect(employee_work.has_role?(role_common.role_name)).to be_truthy
    end
  end

  context "add_roleメソッドのテスト" do
    it "権限テーブルに存在する権限を引数に指定した場合は、権限の付与に成功し、trueが返ること" do
      # 前提として社員に権限が付与されていないこと
      expect(employee_work.roles.size).to eq 0

      # trueが返り、権限が付与されること
      expect(employee_work.add_role(role_admin.role_name)).to be_truthy
      expect(employee_work.roles.size).to eq 1
    end

    it "権限テーブルに存在【しない】権限を引数に指定した場合は、権限の付与が行われず、falseが返ること" do
      # 前提として社員に権限が付与されていないこと
      expect(employee_work.roles.size).to eq 0

      # 権限テーブルに存在しない権限を付与しようとした場合はfalseが返り、権限が付与されないこと
      expect(employee_work.add_role("not exist role name")).to be_falsey
      expect(employee_work.roles.size).to eq 0
    end
  end

  context "社員情報削除のテスト" do
    it "[ActiveRecord経由]社員情報を削除した場合、エラーとならず権限も連動して削除されること" do
      # 社員情報を登録する
      employee_work.save
      expect(Employee.find_by(id: employee_work.id)).not_to be_nil

      # 社員情報を削除してもエラーが発生せず、権限情報も連動して削除されること
      expect {
        employee_work.destroy!
      }.not_to raise_error
      expect(EmployeeRole.find_by(employee_id: employee_work.id)).to be_nil
    end
  end

  it "[DB直接]社員情報を削除した場合、エラーとならず権限も連動して削除されること" do
    # 社員情報を登録する
    employee_work.save
    expect(Employee.find_by(id: employee_work.id)).not_to be_nil

    # 社員情報を削除してもエラーが発生せず、権限情報も連動して削除されること
    expect {
      employee_work.delete
    }.not_to raise_error
    expect(EmployeeRole.find_by(employee_id: employee_work.id)).to be_nil
  end
end
