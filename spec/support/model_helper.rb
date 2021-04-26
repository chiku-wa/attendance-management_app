#
# Modelクラスのテストに必要な共通メソッドを定義するヘルパークラス
#
module ModelHelper
  # =====================================================
  # バリデーションテスト用メソッド群
  #

  # -----------------------------------------------------
  # 引数として渡したモデルインスタンスと、プロパティ名をもとに、空文字かどうかのバリデーションチェックを行う
  #
  def valid_presence(model:, attribute:)
    # --- 半角スペース
    model[attribute] = " "
    expect(model).not_to be_valid

    # --- 全角スペース
    model[attribute] = "　"
    expect(model).not_to be_valid

    # --- 空文字
    model[attribute] = ""
    expect(model).not_to be_valid

    # --- nil
    # nilの場合のみ、DBの制約違反テストを行う(スペースや空文字は登録できてしまうため)
    model[attribute] = nil
    expect(model).not_to be_valid

    expect {
      model.save(validate: false)
    }.to raise_error(ActiveRecord::NotNullViolation)
  end

  # -----------------------------------------------------
  # 引数として渡したモデルインスタンスと、プロパティ名をもとに、最大文字数のバリデーションチェックを行う
  #
  def valid_maximum_num_of_char(model:, attribute:, valid_number_of_characters:)
    # --- 半角文字のテスト
    # 規定文字数以内
    model[attribute] = "a" * valid_number_of_characters
    expect(model).to be_valid

    # 規定文字数外 - Modelクラスのバリデーションエラーテスト
    model[attribute] = "a" * (valid_number_of_characters + 1)
    expect(model).not_to be_valid

    # 規定文字数外 - DBの制約違反テスト
    expect {
      model.save(validate: false)
    }.to raise_error(ActiveRecord::ValueTooLong)

    # --- 全角文字のテスト
    # 規定文字数以内
    model[attribute] = "あ" * valid_number_of_characters
    expect(model).to be_valid

    # 規定文字数外 - Modelクラスのバリデーションエラーテスト
    model[attribute] = "あ" * (valid_number_of_characters + 1)
    expect(model).not_to be_valid

    # 規定文字数外 - DBの制約違反テスト
    expect {
      model.save(validate: false)
    }.to raise_error(ActiveRecord::ValueTooLong)
  end
end
