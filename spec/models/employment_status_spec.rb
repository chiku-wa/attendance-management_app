require "rails_helper"

RSpec.describe "就業状況モデルのテスト", type: :model do
  before do
    # ----- テストデータを登録
    # 就業状況
    @employment_status = EmploymentStatus.new(
      status_name: "本務",
    )
    @employment_status.save
  end

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(@employment_status).to be_valid
    end

    context "バリデーションのテスト" do
      # --- 就業状況のテスト
      it "就業状況がスペース、空文字のみの場合はバリデーションエラーとなること" do
        # 半角スペース
        @employment_status.status_name = " "
        expect(@employment_status).not_to be_valid

        # 全角スペース
        @employment_status.status_name = "　"
        expect(@employment_status).not_to be_valid

        # 空文字
        @employment_status.status_name = ""
        expect(@employment_status).not_to be_valid
      end

      it "就業状況が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
        valid_number_of_characters = 100

        # 全角、半角ともに同じ文字数でバリデーションエラーとなること(バイト基準で判定されていないこと)
        @employment_status.status_name = "a" * valid_number_of_characters
        expect(@employment_status).to be_valid

        @employment_status.status_name = "a" * (valid_number_of_characters + 1)
        expect(@employment_status).not_to be_valid

        @employment_status.status_name = "あ" * valid_number_of_characters
        expect(@employment_status).to be_valid

        @employment_status.status_name = "あ" * (valid_number_of_characters + 1)
        expect(@employment_status).not_to be_valid
      end

      it "重複した就業状況を登録しようとした場合はバリデーションエラーとなること(大文字小文字区別なし)" do
        @employment_status.status_name = "本務a"
        duplicate_employment_status = @employment_status.dup

        # 大文字に変換しても、区別されず、一意制約エラーが発生すること
        duplicate_employment_status.status_name = @employment_status.status_name.upcase
        @employment_status.save
        expect(duplicate_employment_status).not_to be_valid
      end
    end
  end
end
