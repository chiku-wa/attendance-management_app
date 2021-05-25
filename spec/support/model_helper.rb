#
# Modelクラスのテストに必要な共通メソッドを定義するヘルパークラス
#
module ModelHelper
  # =====================================================
  # バリデーション、DB制約のSpecテスト用の汎用メソッド群
  #

  # -----------------------------------------------------
  # # 概要
  # 引数として渡したモデルインスタンスと、プロパティ名をもとに、空文字かどうかのバリデーションチェックを行う
  #
  # # 引数
  # * model
  # テスト対象のモデルインスタンスを指定する
  # ---
  # * attribute
  # テスト対象のカラム名を指定する
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
  # # 概要
  # 引数として渡したモデルインスタンスと、プロパティ名をもとに、最大文字数のバリデーションチェックを行う
  #
  # # 引数
  # * model                       テスト対象のモデルインスタンスを指定する
  # ---
  # * attribute                   テスト対象のカラム名を指定する
  # ---
  # * valid_number_of_characters  テスト対象のカラムで許容されているカラムサイズ(文字数)
  #
  def valid_maximum_num_of_char(model:, attribute:, valid_number_of_characters:)
    # --- 半角文字のテスト
    # Modelクラスのバリデーションエラーテスト
    model[attribute] = "a" * valid_number_of_characters
    expect(model).to be_valid

    model[attribute] = "a" * (valid_number_of_characters + 1)
    expect(model).not_to be_valid

    # DBの制約違反テスト
    expect {
      model.save(validate: false)
    }.to raise_error(ActiveRecord::ValueTooLong)

    # --- 全角文字のテスト
    # Modelクラスのバリデーションエラーテスト
    model[attribute] = "あ" * valid_number_of_characters
    expect(model).to be_valid

    model[attribute] = "あ" * (valid_number_of_characters + 1)
    expect(model).not_to be_valid

    # DBの制約違反テスト
    expect {
      model.save(validate: false)
    }.to raise_error(ActiveRecord::ValueTooLong)
  end

  # -----------------------------------------------------
  # # 概要
  # 引数として渡したモデルインスタンスと、プロパティ名をもとに、一意制約(単一ユニーク)のバリデーションチェックを行う
  #
  # # 引数
  # * model
  # テスト対象のモデルインスタンスを指定する
  # ---
  # * attribute
  # テスト対象のカラム名を指定する
  # ---
  # * value
  # テスト対象のカラムに設定する値を指定する
  # ---
  # * is_case_sensitive
  # 大文字小文字を区別するかどうか
  # ※モデルクラスで指定しているis_sensitiveと同じ真偽値を指定すること
  #
  def valid_unique(model:, attribute:, value:, is_case_sensitive:)
    # ----- 引数のテストデータをそのまま登録してバリデーションテスト
    model[attribute] = value
    model.save

    # Modelクラスのバリデーションエラーテスト
    model_dup = model.dup
    expect(model_dup).not_to be_valid

    # DBの制約違反テスト
    expect {
      model_dup.save(validate: false)
    }.to raise_error(ActiveRecord::RecordNotUnique)

    # ----- 大文字・小文字変換に変換してバリデーションテスト(case_sensitiveのテスト)
    # アルファベットが存在しないテストケースではcase_sensitiveは意味を成さないため、注記を出力して終了する
    if (value =~ /[a-zA-Z]/) == nil
      puts <<~MSG
             アルファベットが存在しないテストケースのため、case_sensitiveのバリデーションテストは意味をなしません。
             テストデータにアルファベットを含めるか、大文字小文字を区別しない場合は、is_case_sensitiveをfalseにしてください。
           MSG
      return
    end

    # テスト登録したデータを削除する
    model.destroy

    # 大文字で登録
    model_upper = model.dup
    model_upper[attribute] = model_upper[attribute].upcase
    model_upper.save

    # 小文字に変換した値でインスタンスを作成
    model_lower = model.dup
    model_lower[attribute] = model_lower[attribute].downcase

    if is_case_sensitive
      # 大文字小文字を区別して「いる」場合、変換するとバリデーションエラーになら「ない」こと
      expect(model_lower).to be_valid
    else
      # 大文字小文字を区別して「いない」場合、変換してもバリデーションエラーに「なる」こと
      expect(model_lower).not_to be_valid
    end

    # - DBの制約違反テスト
    # DBは大文字小文字は常に区別されるため、モデルで定義されたcase_sensitiveの真偽値に関わらず制約エラーとならないこと
    expect {
      model_lower.save(validate: false)
    }.not_to raise_error(ActiveRecord::RecordNotUnique)
  end
end
