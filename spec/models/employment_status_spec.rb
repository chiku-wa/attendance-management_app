require "rails_helper"

RSpec.describe "就業状況モデルのテスト", type: :model do
  before do
    # ----- テストデータを登録
    # 就業状況(在職)
    @employment_status_work = FactoryBot.build(:employment_status_work)
    @employment_status_work.save
  end

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(@employment_status_work).to be_valid
    end

    context "バリデーションのテスト" do
      # ---------------------
      # --- 就業状況のテスト
      it "就業状況がスペース、空文字のみの場合はバリデーションエラーとなること" do
        valid_presence(
          model: @employment_status_work,
          attribute: :status_name,
        )
      end

      it "就業状況が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
        valid_maximum_num_of_char(
          model: @employment_status_work,
          attribute: :status_name,
          valid_number_of_characters: 100,
        )
      end

      it "重複した就業状況を登録しようとした場合はバリデーションエラーとなること(大文字小文字区別なし)" do
        @employment_status_work.status_name = "本務a"
        duplicate_employment_status = @employment_status_work.dup

        # 大文字に変換しても、区別されず、一意制約エラーが発生すること
        duplicate_employment_status.status_name = @employment_status_work.status_name.upcase
        @employment_status_work.save
        expect(duplicate_employment_status).not_to be_valid
      end
    end
  end
end
