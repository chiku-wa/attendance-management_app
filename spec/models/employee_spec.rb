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
    # --- 社員名のテスト
    it "社員名がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: employee_work,
        attribute: :employee_name,
      )
    end

    it "社員名が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: employee_work,
        attribute: :employee_name,
        valid_number_of_characters: 110,
      )
    end

    # ---------------------
    # --- 社員名(フリガナ)のテスト
    it "社員名(フリガナ)がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: employee_work,
        attribute: :employee_name_kana,
      )
    end

    it "社員名(フリガナ)が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: employee_work,
        attribute: :employee_name_kana,
        valid_number_of_characters: 220,
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

  context "formatting_nameメソッドのテスト" do
    it "姓(last name)と名(first name)の間の空白が半角に変換されること" do
      # 全角の名前の場合
      employee_work.employee_name = "山田　太郎"
      employee_work.employee_name_kana = "ヤマダ　タロウ"
      employee_work.save
      expect(employee_work.employee_name).to eq "山田 太郎"
      expect(employee_work.employee_name_kana).to eq "ヤマダ タロウ"

      # 半角の名前の場合
      employee_work.employee_name = "Kory　Green"
      employee_work.employee_name_kana = "コリー　グリーン"
      employee_work.save
      expect(employee_work.employee_name).to eq "Kory Green"
      expect(employee_work.employee_name_kana).to eq "コリー グリーン"
    end

    it "文字列先頭・末尾の空白は取り除かれること" do
      employee_work.employee_name = "　鈴木 次郎 "
      employee_work.employee_name_kana = " スズキ ジロウ　"
      employee_work.save
      expect(employee_work.employee_name).to eq "鈴木 次郎"
      expect(employee_work.employee_name_kana).to eq "スズキ ジロウ"
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
end
