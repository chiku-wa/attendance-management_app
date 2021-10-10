require "rails_helper"

RSpec.describe "勤務表モデルのテスト", type: :model do
  # ===== テストデータを登録
  # ※FactoryBotのassociationで登録しようとすると、親テーブルのデータを重複して生成して
  # しまう性質上、同名の部署データを2件以上登録できず、NotNull制約に違反してしまう。
  # よってRSpec内でテストデータを生成する。

  # --- 社員(就業状況含む)
  let(:employee) { FactoryBot.build(:employee) }

  # --- プロジェクト
  let(:project) { FactoryBot.build(:project) }

  # --- ランク
  let(:rank_A) { FactoryBot.build(:rank_A) }

  # --- 勤務表
  let(:work_table) {
    WorkTable.new(
      employee: employee,
      employee_code: employee.employee_code,
      working_date: Time.zone.now,
      project: project,
      project_code: project.project_code,
      employment_status: employee.employment_status,
      status_code: employee.employment_status.status_code,
      rank: rank_A,
      rank_code: rank_A.rank_code,
      closed: false,
    )
  }

  before do
    # 外部キーのデータをsaveする(子テーブルのテストが正常に実行できないため)
    employee.save # 就業状況は社員情報のFactory作成時に含めているため、別途save不要
    project.save
    rank_A.save
  end

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(work_table).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- 社員のテスト
    it "社員がnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: work_table,
        attribute: :employee,
      )
    end

    # ---------------------
    # --- 社員コードのテスト
    it "社員コードがスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: work_table,
        attribute: :employee_code,
      )
    end

    it "社員コードが規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: work_table,
        attribute: :employee_code,
        valid_number_of_characters: 6,
      )
    end

    # ---------------------
    # --- 勤務日のテスト
    it "勤務日がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: work_table,
        attribute: :working_date,
      )
    end

    # ---------------------
    # --- プロジェクトのテスト
    it "プロジェクトがnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: work_table,
        attribute: :project,
      )
    end

    # ---------------------
    # --- プロジェクトコードのテスト
    it "プロジェクトコードがスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: work_table,
        attribute: :project_code,
      )
    end

    it "プロジェクトコードが規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: work_table,
        attribute: :project_code,
        valid_number_of_characters: 7,
      )
    end

    # ---------------------
    # --- 就業状況のテスト
    it "就業状況がnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: work_table,
        attribute: :employment_status,
      )
    end

    # ---------------------
    # --- 就業状況コードのテスト
    it "就業状況コードがスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: work_table,
        attribute: :status_code,
      )
    end

    it "就業状況コードが規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: work_table,
        attribute: :status_code,
        valid_number_of_characters: 5,
      )
    end

    # ---------------------
    # --- ランクのテスト
    it "ランクがnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: work_table,
        attribute: :rank,
      )
    end

    # ---------------------
    # --- ランクコードのテスト
    it "就業状況コードがスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: work_table,
        attribute: :rank_code,
      )
    end

    it "就業状況コードが規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: work_table,
        attribute: :rank_code,
        valid_number_of_characters: 2,
      )
    end

    # ---------------------
    # --- 締めフラグのテスト
    it "締めフラグがnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: work_table,
        attribute: :closed,
      )
    end
  end
end
