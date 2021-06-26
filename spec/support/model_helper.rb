#
# Modelクラスのテストに必要な共通メソッドを定義するヘルパークラス
#
module ModelHelper
  # =====================================================
  # バリデーション、DB制約のSpecテスト用の汎用メソッド群
  #

  # ----------------------------------------------------
  # # 概要
  # 引数として渡したモデルインスタンスと、属性名をもとに、空文字かどうかのバリデーションチェックを行う
  #
  # # 引数
  # * model
  # テスト対象のモデルインスタンスを指定する
  # --
  # * attribute
  # テスト対象のカラム名を指定する
  #
  def valid_presence(model:, attribute:)
    # ===== String型の場合のみ、空文字・スペースのテストを実行する
    #       ※TrueClass or FalseClassだと、文字列を代入した時点でtrueが格納されるため、
    #        バリデーションを通過してしまう。
    if model[attribute].class == String
      # --- 半角スペース
      model.send("#{attribute}=", " ")
      expect(model).not_to be_valid

      # --- 全角スペース
      model.send("#{attribute}=", "　")
      expect(model).not_to be_valid

      # --- 空文字
      model.send("#{attribute}=", "")
      expect(model).not_to be_valid
    end

    # ===== nilのテストはすべてのデータ型に対して実施する
    # --- nil
    # nilの場合のみ、DBの制約違反テストを行う(スペースや空文字は登録できてしまうため)
    model.send("#{attribute}=", nil)
    expect(model).not_to be_valid

    expect {
      model.save(validate: false)
    }.to raise_error(ActiveRecord::NotNullViolation)
  end

  # -----------------------------------------------------
  # # 概要
  # 引数として渡したモデルインスタンスと、属性名をもとに、最大文字数のバリデーションチェックを行う
  #
  # # 引数
  # * model                       テスト対象のモデルインスタンスを指定する
  # --
  # * attribute                   テスト対象のカラム名を指定する
  # --
  # * valid_number_of_characters  テスト対象のカラムで許容されているカラムサイズ(文字数)
  #
  def valid_maximum_num_of_char(model:, attribute:, valid_number_of_characters:)
    # --- 半角文字のテスト
    # Modelクラスのバリデーションエラーテスト
    model.send(
      "#{attribute}=",
      "a" * valid_number_of_characters,
    )
    expect(model).to be_valid

    model.send(
      "#{attribute}=",
      "a" * (valid_number_of_characters + 1),
    )
    expect(model).not_to be_valid

    # DBの制約違反テスト
    expect {
      model.save(validate: false)
    }.to raise_error(ActiveRecord::ValueTooLong)

    # --- 全角文字のテスト
    # Modelクラスのバリデーションエラーテスト
    model.send(
      "#{attribute}=",
      "あ" * valid_number_of_characters,
    )
    expect(model).to be_valid

    model.send(
      "#{attribute}=",
      "あ" * (valid_number_of_characters + 1),
    )
    expect(model).not_to be_valid

    # DBの制約違反テスト
    expect {
      model.save(validate: false)
    }.to raise_error(ActiveRecord::ValueTooLong)
  end

  # -----------------------------------------------------
  # # 概要
  # 引数として渡したモデルインスタンスと、属性名をもとに、一意制約(単一ユニーク)のバリデーションチェックを行う
  #
  # # 引数
  # * model
  # テスト対象のモデルインスタンスを指定する
  # --
  # * attribute
  # テスト対象のカラム名を指定する
  # --
  # * value
  # テスト対象のカラムに設定する値を指定する
  # --
  # * is_case_sensitive
  # 大文字小文字を区別するかどうか
  # ※モデルクラスで指定しているis_sensitiveと同じ真偽値を指定すること
  #
  def valid_unique(model:, attribute:, value:, is_case_sensitive:)
    # ----- 引数のテストデータをそのまま二重登録してバリデーションテスト
    model.send(
      "#{attribute}=",
      value,
    )
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
             #{attribute}(値：#{value})はアルファベットが存在しないテストケースのため、case_sensitiveのバリデーションテストは意味をなしません。
             テストデータにアルファベットを含めるか、大文字小文字を区別しない場合は、is_case_sensitiveをfalseにしてください。
           MSG
      return
    end

    # テスト登録したデータを削除する
    model.destroy

    # 大文字で登録
    model_upper = model.dup
    model_upper.send(
      "#{attribute}=",
      model_upper[attribute].upcase,
    )
    model_upper.save

    # 小文字に変換した値でインスタンスを作成
    model_lower = model.dup
    model_lower.send(
      "#{attribute}=",
      model_lower[attribute].downcase,
    )

    if is_case_sensitive
      # 大文字小文字を区別して「いる」場合、変換するとバリデーションエラーに「ならない」こと
      expect(model_lower).to be_valid
    else
      # 大文字小文字を区別して「いない」場合、変換してもバリデーションエラーに「なる」こと
      expect(model_lower).not_to be_valid
    end

    # - DBの制約違反テスト
    # DBは大文字小文字は常に区別されるため、モデルで定義されたcase_sensitiveの真偽値に関わらず制約エラーとならないこと
    expect {
      model_lower.save(validate: false)
    }.not_to raise_error
  end

  # -----------------------------------------------------
  # # 概要
  # 引数として渡したモデルインスタンスと、属性名をもとに、一意制約(複合ユニーク)のバリデーションチェックを行う。
  # なお、前提としてテスト対象データの属性には単一ユニークが付与されていないこととする。
  # ※単一ユニークが存在する場合は、本メソッドではバリデーションエラーとして検出する。
  #
  # # 引数
  # * model
  # テスト対象のモデルインスタンスを指定する。
  # --
  # * attribute_and_value_hash
  # 複合キーとして設定しているカラム名と、テストに使用する値のハッシュを指定する。
  # 【注意点】
  # 1. 第1引数のmodelの属性値とは異なる値を指定すること
  # 2. 文字列はString型、日付型はActiveSupport::TimeWithZone型を指定すること
  # 例：
  # カラム名`department_code`&値=`A01000000000`
  # カラム名`establishment_date`&値='2021/05/25 18:30'
  # カラム名`abolished_date`&値='9999/12/31 23:59:59'
  #
  # ```
  # {
  #   department_code: "A01000000000",
  #   establishment_date: Time.zone.local(2021,5,25,18,30,0),
  #   abolished_date: Time.zone.local(2021,5,25,18,30,0),
  # }
  # ```
  # --
  # * is_case_sensitive
  # 大文字小文字を区別するかどうか。
  # ※モデルクラスで指定しているis_sensitiveと同じ真偽値を指定すること
  #
  def valid_uniques(model:, attribute_and_value_hash:, is_case_sensitive:)
    # モデルインスタンスの属性値と、attribute_and_value_hashの属性値が同じものが含まれている場合は、テストをエラーにして終了させる。
    attribute_and_value_hash.each do |attribute, value|
      if model.send(attribute) == value
        puts <<~MSG
               第1引数(model)と、第2引数(attribute_and_value_hash)に含める属性値には異なる値を指定してください。"
                属性値が同じ値:
                model -> #{model[attribute]}
                attribute_and_value_hash -> #{value}
             MSG
        return
      end
    end

    # 引数の値をバックアップとして保存
    model_org = model.dup

    # ----- 引数のテストデータをそのまま二重登録してバリデーションテスト
    attribute_and_value_hash.each do |attribute, value|
      model.send(
        "#{attribute}=",
        value,
      )
    end
    model.save

    # Modelクラスのバリデーションエラーテスト
    model_dup = model.dup
    expect(model_dup).not_to be_valid

    # DBの制約違反テスト
    expect {
      model_dup.save(validate: false)
    }.to raise_error(ActiveRecord::RecordNotUnique)

    # ----- いずれか1つのカラムのみが重複していてもバリデーションエラーとならないこと
    # 先ほどテストで作成したテストデータをクリアする
    model.destroy

    # 単一のカラムのみ値を重複させてもバリデーションエラーにならないことを確認する
    attribute_and_value_hash.each do |attribute, value|
      # 引数のモデルインスタンスを復元する
      model = model_org.dup

      # 1件目を登録
      model.send(
        "#{attribute}=",
        value,
      )
      model.save

      # Modelクラスのバリデーションエラーテスト
      expect(model).to be_valid

      # DBの制約違反テスト
      expect {
        model.save(validate: false)
      }.not_to raise_error
    end

    # ----- 大文字・小文字変換に変換してバリデーションテスト(case_sensitiveのテスト)
    # 先ほどテストで作成したテストデータをクリアする
    model.destroy

    attribute_and_value_hash.each do |attribute, value|
      # 属性が文字列型の場合のみテストする
      if (value.class == String)
        # アルファベットが存在しないテストケースではcase_sensitiveは意味を成さないため、注記を出力してテストを実施しない
        if (value =~ /[a-zA-Z]/) == nil
          puts <<~MSG
                 #{attribute}(値：#{value})はアルファベットが存在しないテストケースのため、case_sensitiveのバリデーションテストは意味をなしません。
                 テストデータにアルファベットを含めるか、大文字小文字を区別しない場合は、is_case_sensitiveをfalseにしてください。
               MSG
          # memo:単一ユニークの場合と異なりreturnは行わない(引数で指定されたハッシュ変数を巡回するため)
        else

          # 引数のモデルインスタンスを復元する
          model = model_org.dup

          # 大文字で登録
          model_upper = model.dup
          model_upper.send(
            "#{attribute}=",
            model_upper[attribute].upcase,
          )
          model_upper.save

          # 小文字に変換した値でインスタンスを作成
          model_lower = model.dup
          model_lower.send(
            "#{attribute}=",
            model_lower[attribute].downcase,
          )

          if is_case_sensitive
            # 大文字小文字を区別して「いる」場合、変換するとバリデーションエラーに「ならない」こと
            expect(model_lower).to be_valid
          else
            # 大文字小文字を区別して「いない」場合、変換してもバリデーションエラーに「なる」こと
            expect(model_lower).not_to be_valid
          end

          # - DBの制約違反テスト
          # DBは大文字小文字は常に区別されるため、モデルで定義されたcase_sensitiveの真偽値に関わらず制約エラーとならないこと
          expect {
            model_lower.save(validate: false)
          }.not_to raise_error
        end
      end
    end
  end
end
