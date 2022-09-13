require "rails_helper"

RSpec.describe "社員モデルのテスト", type: :model do
  # ===== テストデータを登録
  # ----- 権限テーブル ※社員情報に紐付けるために、buildではなくcreateする
  let(:role_admin) { FactoryBot.create(:role_admin) }
  let(:role_manager) { FactoryBot.create(:role_manager) }
  let(:role_common) { FactoryBot.create(:role_common) }

  # ----- 部署テーブル
  let(:department_A) { FactoryBot.create(:department_A) }
  let(:department_A_sales) { FactoryBot.create(:department_A_sales) }

  # ----- 所属種別テーブル
  let(:affiliation_type_regular) { FactoryBot.create(:affiliation_type_regular) }
  let(:affiliation_type_additional) { FactoryBot.create(:affiliation_type_additional) }

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
    it "権限が付与されている社員の場合はtrueが返ること" do
      # ----- 単一の権限が付与されている場合のテスト
      employee_work.roles << role_admin

      # 権限がある場合はtrueが返ること
      expect(employee_work.has_role?(role_admin.role_name)).to be_truthy

      # 付与されていない権限の場合はfalseが返ること
      expect(employee_work.has_role?(role_manager.role_name)).to be_falsey
      expect(employee_work.has_role?(role_common.role_name)).to be_falsey

      # ----- 複数の権限が付与されている場合のテスト
      # 一致する権限が1つでもある場合はtrueが返ること
      employee_work.roles << role_manager
      expect(employee_work.has_role?(role_manager.role_name)).to be_truthy

      employee_work.roles << role_common
      expect(employee_work.has_role?(role_common.role_name)).to be_truthy
    end

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

    it "想定と異なる権限が付与されている場合はfalseが返ること" do
      # システム管理者権限を付与
      employee_work.roles << role_admin

      # システム管理者【以外】を期待値とした場合、falseとなること
      expect(employee_work.has_role?(role_common.role_name)).to be_falsey
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

  context "has_department?のテスト" do
    it "部署が付与されている社員の場合はtrueが返ること" do
      employee_work.save

      # 対象社員に部署情報を付与する
      EmployeeDepartment.create(
        department: department_A,
        employee: employee_work,
        affiliation_type: affiliation_type_regular,
        start_date: Time.zone.now,
        end_date: Time.zone.now + 1.day,
      )

      # trueが返ること
      expect(employee_work.has_department?(department_A)).to be_truthy
    end

    it "部署が付与されていない社員の場合はfalseが返ること" do
      employee_work.save

      # 前提として、部署が付与されていないこと
      expect(EmployeeDepartment.find_by(employee: employee_work)).to be_nil

      # falseが返ること
      expect(employee_work.has_department?(department_A)).to be_falsey
    end

    it "社員インスタンスがnilの場合はfalseが返ること" do
      employee_work = nil
      expect(employee_work.has_department?(department_A)).to be_falsey
    end

    it "想定と異なる部署が付与されている場合はfalseが返ること" do
      # A事業部を付与
      EmployeeDepartment.create(
        department: department_A,
        employee: employee_work,
        affiliation_type: affiliation_type_regular,
        start_date: Time.zone.now,
        end_date: Time.zone.now + 1.day,
      )

      # A事業部【以外】を期待値とした場合、falseとなること
      expect(employee_work.has_department?(department_A_sales)).to be_falsey
    end
  end

  context "add_departmentのテスト" do
    it "部署テーブルに存在する部署を引数に指定した場合は、部署の付与に成功し、社員-部署インスタンスが返ること" do
      employee_work.save

      # ----- 前提として社員に部署が付与されていないこと
      expect(EmployeeDepartment.where(employee: employee_work).size).to eq 0

      # ----- 想定通りの社員-部署インスタンスが返り、部署が付与されること
      # 期待値確認用の社員-部署インスタンス
      start_date = Time.zone.now
      end_date = start_date + 1.day
      expected_employee_department_attributes = {
        department: department_A,
        affiliation_type_name: affiliation_type_regular.affiliation_type_name,
        start_date: start_date,
        end_date: end_date,
      }

      # テスト対象メソッドを実行
      return_employee_department = employee_work.add_department(
        department: expected_employee_department_attributes[:department],
        affiliation_type_name: expected_employee_department_attributes[:affiliation_type_name],
        start_date: expected_employee_department_attributes[:start_date],
        end_date: expected_employee_department_attributes[:end_date],
      )

      # 戻り値が社員-部署インスタンスであること
      expect(return_employee_department.class).to eq EmployeeDepartment

      # 戻り値の属性値が一致すること(テスト対象メソッドに引数として渡した値のみが一致することを確認)
      expect(
        expected_employee_department_attributes.values_at(expected_employee_department_attributes.keys)
      ).to eq return_employee_department.attributes.values_at(expected_employee_department_attributes.keys)

      expect(EmployeeDepartment.where(employee: employee_work).size).to eq 1
    end

    it "部署の設立日 >= 着任日の場合はfalseが返り、部署の設立日 < 着任日の場合は社員-部署インスタンスが返ること(比較は日付単位で行われること)" do
      employee_work.save

      twz = Time.zone.parse("2022-09-13 00:00:00")

      # 部署の設立日 = 着任日
      start_date = twz
      end_date = start_date
      expect(
        employee_work.add_department(
          department: department_A,
          affiliation_type_name: affiliation_type_regular.affiliation_type_name,
          start_date: start_date,
          end_date: end_date,
        )
      ).to be_nil

      # 部署の設立日 > 着任日
      start_date = twz
      end_date = start_date - 1.day
      expect(
        employee_work.add_department(
          department: department_A,
          affiliation_type_name: affiliation_type_regular.affiliation_type_name,
          start_date: start_date,
          end_date: end_date,
        )
      ).to be_nil

      # 部署の設立日 < 着任日 ※同日(日付をまたがない)の場合はfalse
      start_date = twz
      end_date = start_date + 1.second
      expect(
        employee_work.add_department(
          department: department_A,
          affiliation_type_name: affiliation_type_regular.affiliation_type_name,
          start_date: start_date,
          end_date: end_date,
        )
      ).to be_nil

      # 部署の設立日 < 着任日 ※別日(日付をまたぐ)の場合は社員-部署インスタンスが返ってくること
      start_date = twz
      end_date = start_date + 1.day
      expect(
        employee_work.add_department(
          department: department_A,
          affiliation_type_name: affiliation_type_regular.affiliation_type_name,
          start_date: start_date,
          end_date: end_date,
        ).class
      ).to eq EmployeeDepartment
    end

    it "部署の設立日 >= 着任日の場合はfalseが返り、部署の設立日 < 着任日の場合は社員-部署インスタンスが返ること(比較は日付単位で行われること)" do
      employee_work.save

      start_date = Time.zone.parse("2022-09-13 00:00:00")
      end_date = start_date + 1.day

      # 1回目は問題なく設定できること
      expect(
        employee_work.add_department(
          department: department_A,
          affiliation_type_name: affiliation_type_regular.affiliation_type_name,
          start_date: start_date,
          end_date: end_date,
        ).class
      ).to eq EmployeeDepartment

      # 同じ部署で2回目の設定を行おうとした際はnilが返ること
      expect(
        employee_work.add_department(
          department: department_A,
          affiliation_type_name: affiliation_type_regular.affiliation_type_name,
          start_date: start_date,
          end_date: end_date,
        )
      ).to be_nil

      # 異なる部署であれば問題なく設定できること
      expect(
        employee_work.add_department(
          department: department_A_sales,
          affiliation_type_name: affiliation_type_regular.affiliation_type_name,
          start_date: start_date,
          end_date: end_date,
        ).class
      ).to eq EmployeeDepartment
    end
  end

  context "社員情報削除のテスト" do
    it "[ActiveRecord経由]社員情報を削除した場合、エラーとならず権限・部署も連動して削除されること" do
      # ----- 権限、部署を付与した社員情報を登録する
      # 社員を登録
      employee_work.save

      # 権限を付与
      employee_work.roles << role_admin

      # 部署を設定
      EmployeeDepartment.create(
        department: department_A,
        employee: employee_work,
        affiliation_type: affiliation_type_regular,
        start_date: Time.zone.now,
        end_date: Time.zone.now + 1.day,
      )

      # 社員情報が存在し、権限と部署が設定されていること
      expect(Employee.find_by(id: employee_work.id)).not_to be_nil
      expect(
        EmployeeRole.find_by(employee: employee_work)
      ).not_to be_nil

      expect(
        EmployeeDepartment.find_by(employee: employee_work)
      ).not_to be_nil

      # ----- 社員情報を削除しても例外が発生せず、権限・部署情報も連動して削除されること
      # 例外が発生しないこと
      expect {
        employee_work.destroy!
      }.not_to raise_error

      # 権限が連動して削除されていること
      expect(EmployeeRole.find_by(employee: employee_work)).to be_nil

      # 部署情報も連動して削除されていること
      expect(
        EmployeeDepartment.find_by(employee: employee_work)
      ).to be_nil
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
