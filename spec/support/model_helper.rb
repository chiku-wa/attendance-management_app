#
# Modelクラスのテストに必要な共通メソッドを定義するヘルパークラス
#
module ModelHelper
  # =====================================================
  # バリデーションテスト用メソッド群
  #

  # ---
  # 引数として渡したモデルインスタンスと、プロパティ名をもとに、空文字かどうかのバリデーションチェックを行う
  #
  def valid_presence(model:, attribute:)
    # 半角スペース
    model[attribute] = " "
    expect(model).not_to be_valid

    # 全角スペース
    model[attribute] = "　"
    expect(model).not_to be_valid

    # 空文字
    model[attribute] = ""
    expect(model).not_to be_valid
  end

  # ---
  # 引数として渡したモデルインスタンスと、プロパティ名をもとに、最大文字数のバリデーションチェックを行う
  #
  def valid_maximum_num_of_char(model:, attribute:, valid_number_of_characters:)
    # 全角、半角ともに同じ文字数でバリデーションエラーとなること(バイト基準で判定されていないこと)
    model[attribute] = "a" * valid_number_of_characters
    expect(model).to be_valid

    model[attribute] = "a" * (valid_number_of_characters + 1)
    expect(model).not_to be_valid

    model[attribute] = "あ" * valid_number_of_characters
    expect(model).to be_valid

    model[attribute] = "あ" * (valid_number_of_characters + 1)
    expect(model).not_to be_valid
  end
end
