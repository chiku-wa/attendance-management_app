require "rails_helper"

RSpec.describe "プロジェクトモデルのテスト", type: :model do
  before do
    # ----- テストデータを登録
    @project = FactoryBot.build(:project)
    @project.save
  end

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(@project).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- プロジェクトコードのテスト
    it "プロジェクトコードがスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @project,
        attribute: :project_code,
      )
    end

    it "プロジェクトコードが規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: @project,
        attribute: :project_code,
        valid_number_of_characters: 7,
      )
    end

    it "プロジェクトコードに重複した値が登録された場合はエラーとなること" do
      valid_unique(
        model: @project,
        attribute: :project_code,
        value: "AB00001",
        is_case_sensitive: false,
      )
    end

    # ---------------------
    # --- プロジェクト名のテスト
    it "プロジェクト名がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @project,
        attribute: :project_name,
      )
    end

    it "プロジェクト名が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: @project,
        attribute: :project_name,
        valid_number_of_characters: 300,
      )
    end

    # ---------------------
    # --- 有効フラグのテスト
    it "有効フラグがスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @project,
        attribute: :enabled,
      )
    end

    # ---------------------
    # --- プロジェクト開始日のテスト
    # ※NULL許容のためテストなし

    # ---------------------
    # --- プロジェクト終了日のテスト
    # ※NULL許容のためテストなし

  end

  context "その他のテスト" do
    it "プロジェクト開始日とプロジェクト終了日のどちらか片方のみがnilの場合はバリデーションエラーとなること" do
      project_org = @project.dup

      # プロジェクト開始日がnil、プロジェクト終了日が値あり
      @project.start_date = nil
      expect(@project).not_to be_valid

      # データをもとに戻す
      @project = project_org

      # プロジェクト開始日が値あり、プロジェクト終了日がnil
      @project.end_date = nil
      expect(@project).not_to be_valid
    end
  end
end
