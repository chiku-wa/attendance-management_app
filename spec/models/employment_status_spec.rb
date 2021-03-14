require "rails_helper"

RSpec.describe "就業状況モデルのテスト", type: :model do
  before do
    # ----- テストデータを登録
    # 就業状況
    @employment_status_duty = EmploymentStatus.new(
      status_name: "本務",
    )
    @employment_status_duty.save
  end

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(@employment_status_duty).to be_valid
    end

    context "バリデーションのテスト" do
      # ---------------------
      # --- 就業状況のテスト
      it "就業状況がスペース、空文字のみの場合はバリデーションエラーとなること" do
        # 半角スペース
        @employment_status_duty.status_name = " "
        expect(@employment_status_duty).not_to be_valid

        # 全角スペース
        @employment_status_duty.status_name = "　"
        expect(@employment_status_duty).not_to be_valid

        # 空文字
        @employment_status_duty.status_name = ""
        expect(@employment_status_duty).not_to be_valid
      end

      it "就業状況が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
        is_valid_maximum_num_of_char(
          valid_number_of_characters: 100,
          employment_status: @employment_status_duty,
          attribute: :status_name,
        )
      end

      it "重複した就業状況を登録しようとした場合はバリデーションエラーとなること(大文字小文字区別なし)" do
        @employment_status_duty.status_name = "本務a"
        duplicate_employment_status = @employment_status_duty.dup

        # 大文字に変換しても、区別されず、一意制約エラーが発生すること
        duplicate_employment_status.status_name = @employment_status_duty.status_name.upcase
        @employment_status_duty.save
        expect(duplicate_employment_status).not_to be_valid
      end
    end
  end

  # ======================================
  private

  # 引数として渡したモデルインスタンスと、プロパティ名をもとに、最大文字数のバリデーションチェックを行う
  def is_valid_maximum_num_of_char(valid_number_of_characters:, employment_status:, attribute:)
    # 全角、半角ともに同じ文字数でバリデーションエラーとなること(バイト基準で判定されていないこと)
    employment_status[attribute] = "a" * valid_number_of_characters
    expect(employment_status).to be_valid

    employment_status[attribute] = "a" * (valid_number_of_characters + 1)
    expect(employment_status).not_to be_valid

    employment_status[attribute] = "あ" * valid_number_of_characters
    expect(employment_status).to be_valid

    employment_status[attribute] = "あ" * (valid_number_of_characters + 1)
    expect(employment_status).not_to be_valid
  end
end
