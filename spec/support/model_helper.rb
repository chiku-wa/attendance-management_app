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
  # テスト対象のプロパティ名を指定する
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
  # * attribute                   テスト対象のプロパティ名を指定する
  # --
  # * valid_number_of_characters  テスト対象のプロパティで許容されている文字数を指定する
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
  # 引数として渡したモデルインスタンスと、属性名をもとに、メールアドレスの最大文字数のバリデーションチェックを行う
  # ※メールアドレスの形式に則って文字数チェックを行う必要があるため、メールアドレスのみは別メソッドとして切り分けている
  #
  # # 引数
  # * model                       テスト対象のモデルインスタンスを指定する
  # --
  # * attribute                   テスト対象のプロパティ名を指定する
  # --
  # * valid_number_of_characters  テスト対象のプロパティで許容されている文字数を指定する
  #
  def valid_maximum_num_of_email(model:, attribute:, valid_number_of_characters:)
    # テスト用のドメイン部分の定義
    email_domain_str = "@example.com"
    valid_number_of_characters_without_domain = valid_number_of_characters - (email_domain_str.size)

    # --- 半角文字のテスト
    # Modelクラスのバリデーションエラーテスト
    model.send(
      "#{attribute}=",
      "a" * (valid_number_of_characters_without_domain) + email_domain_str,
    )
    expect(model).to be_valid

    model.send(
      "#{attribute}=",
      "a" * (valid_number_of_characters_without_domain + 1) + email_domain_str,
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
  # テスト対象のプロパティ名を指定する
  # --
  # * value
  # テスト対象のプロパティに設定する値を指定する
  # --
  # * is_case_sensitive
  # 大文字小文字を区別するかどうか
  # ※モデルクラスで指定しているis_sensitiveと同じ真偽値を指定すること
  # --
  # * other_unique_attributes
  # 同一モデルクラス内で、テスト対象のプロパティ以外に一意制約が付与されている場合、それらのプロパティ名
  # と、引数`model`で指定した値**以外**の値をマップ形式で指定する。
  # ※複数の一意制約違反が検知されると正しくテストが実行できないため
  # [例]
  # {email: "aaa@example.com", employee_code: "C00003"}
  #
  #
  def valid_unique(model:, attribute:, value:, is_case_sensitive:, other_unique_attributes: {})
    # ----- 引数のテストデータをそのまま二重登録してバリデーションテスト
    model.send(
      "#{attribute}=",
      value,
    )
    model.save

    # Modelクラスのバリデーションエラーテスト
    model_dup = model.dup

    # テスト対象以外のプロパティで一意制約違反が発生しないように、テスト対象外のプロパティには別の値を設定する
    other_unique_attributes.each do |atr, val|
      model_dup.send(
        "#{atr}=",
        val,
      )
    end

    # バリデーションエラーとなること
    expect(model_dup.valid?).to be_falsey

    # 一意性制約が付与されている他のプロパティでバリデーションエラーが検知されている場合は終了する
    if model_dup.errors.size > 1
      raise <<~MSG
              複数の一意制約違反が検知されました。一意制約違反をテストする場合は、1つだけ検知されるように引数を修正してください。
              [検知された一意制約違反]
              #{model_dup.errors.full_messages.join("\n")}
            MSG
    end

    # 想定したプロパティでバリデーションが発生していることを確認する
    expect(model_dup.errors.messages[attribute].join).to include("すでに存在します")

    # DBの制約違反テスト
    # 例外メッセージに、評価するプロパティ名が含まれていることを確認する。
    # ※一意性制約が付与されている他のプロパティのバリデーションエラーが誤検知されていないことを確認するため
    expect {
      model_dup.save(validate: false)
    }.to raise_error(
      ActiveRecord::RecordNotUnique,
      /#{attribute}/
    )

    # ----- 大文字・小文字変換に変換してバリデーションテスト(case_sensitiveのテスト)
    # アルファベットが存在しないテストケースではcase_sensitiveは意味を成さないため、注記を出力して終了する
    if (value =~ /[a-zA-Z]/) == nil
      raise <<~MSG
              #{attribute}(値：#{value})はアルファベットが存在しないテストケースのため、case_sensitiveのバリデーションテストは意味をなしません。
              テストデータにアルファベットを含めるか、大文字小文字を区別しない場合は、is_case_sensitiveをfalseにしてください。
            MSG
    end

    # テスト登録したデータを削除する
    model.destroy

    # 大文字で登録(引数が小文字のみの場合、テストが想定どおりに動作しないため一旦大文字に変換する)
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

    # テスト対象以外のプロパティで一意制約違反が発生しないように、テスト対象外のプロパティには別の値を設定する
    other_unique_attributes.each do |atr, val|
      model_lower.send(
        "#{atr}=",
        val,
      )
    end

    if is_case_sensitive
      # 大文字小文字を区別して「いる」場合、変換するとバリデーションエラーに「ならない」こと
      expect(model_lower).to be_valid

      # DBの制約違反テスト
      expect {
        model_lower.save(validate: false)
      }.not_to raise_error
    else
      # 大文字小文字を区別して「いない」場合、変換してもバリデーションエラーに「なる」こと
      expect(model_lower).not_to be_valid
    end
  end

  # -----------------------------------------------------
  # # 概要
  # 引数として渡したモデルインスタンスと、属性名をもとに、一意制約(複合ユニーク)のバリデーションチェックを行う。
  # **前提として、引数のモデルインスタンス、属性名の組み合わせの情報は未保存(saveされていない)の状態とする。**
  # なお、前提としてテスト対象データの属性には単一ユニークが付与されていないこととする。
  # ※単一ユニークが存在する場合は、本メソッドではバリデーションエラーとして検出する。
  #
  # # 引数
  # * model
  # テスト対象のモデルインスタンスを指定する。
  # --
  # * attribute_and_value_hash
  # 複合キーとして設定しているプロパティ名と、テストに使用する値のハッシュを指定する。
  # 【注意点】
  # 1. 第1引数のmodelの属性値とは異なる値を指定すること
  # 2. 文字列はString型、日付型はActiveSupport::TimeWithZone型を指定すること
  # 例：
  # プロパティ名`department_code`&値=`A01000000000`
  # プロパティ名`establishment_date`&値='2021/05/25 18:30'
  # プロパティ名`abolished_date`&値='9999/12/31 23:59:59'
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
    # 引数の妥当性を確認する。
    check_for_unique_test_arg(model, attribute_and_value_hash)

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
    expect(model_dup.valid?).to be_falsey

    # 一意性制約が付与されている他のプロパティでバリデーションエラーが検知されている場合は終了する
    if model_dup.errors.size > 1
      raise <<~MSG
              複数の一意制約違反が検知されました。一意制約違反をテストする場合は、1つだけ検知されるように引数を修正してください。
              [検知された一意制約違反]
              #{model_dup.errors.full_messages.join("\n")}
            MSG
    end

    # 想定したプロパティでバリデーションが発生していることを確認する
    expect(model_dup.errors.messages[attribute].join).to include("すでに存在します")

    # DBの制約違反テスト
    expect {
      model_dup.save(validate: false)
    }.to raise_error(ActiveRecord::RecordNotUnique)

    # ----- いずれか1つのプロパティのみが重複していてもバリデーションエラーとならないこと
    # 先ほどテストで作成したテストデータをクリアする
    model.destroy

    # 単一のプロパティのみ値を重複させてもバリデーションエラーにならないことを確認する
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

  # =============== プライベートメソッド
  private

  # -----------------------------------------------------
  # # 概要
  # 一意制約のバリデーションテストメソッドでのみ使用するプライベートメソッド。
  # テストメソッドの引数に異常値が紛れていないかをチェックし、異常がある場合は例外を発生させる。
  #
  # # 引数
  # * model
  # テスト対象のモデルインスタンスを指定する。
  # --
  # * attribute_and_value_hash
  # 複合キーとして設定しているプロパティ名と、テストに使用する値のハッシュを指定する。
  # 【注意点】
  # 1. 第1引数のmodelの属性値とは異なる値を指定すること
  # 2. 文字列はString型、日付型はActiveSupport::TimeWithZone型を指定すること
  # 例：
  # プロパティ名`department_code`&値=`A01000000000`
  # プロパティ名`establishment_date`&値='2021/05/25 18:30'
  # プロパティ名`abolished_date`&値='9999/12/31 23:59:59'
  #
  # ```
  # {
  #   department_code: "A01000000000",
  #   establishment_date: Time.zone.local(2021,5,25,18,30,0),
  #   abolished_date: Time.zone.local(2021,5,25,18,30,0),
  # }
  # ```
  #
  def check_for_unique_test_arg(model, attribute_and_value_hash)
    error_messages = []

    # モデルインスタンスの属性値と、attribute_and_value_hashの属性値が同じものが含まれている場合はエラーメッセージをを格納
    attribute_and_value_hash.each do |attribute, value|
      if model.send(attribute) == value
        error_messages << <<~MSG
          引数「model」、「attribute_and_value_hash」に含めるプロパティ値には異なる値を指定してください。
           属性値が同じ値:
           model -> #{model[attribute]}
           attribute_and_value_hash -> #{value}
        MSG
      end
    end

    # 引数のモデルインスタンスがすでに保存されている場合はエラーメッセージを格納
    if model.persisted?
      error_messages << <<~MSG
        引数のモデルインスタンスはすでにDBに登録されています。未保存のモデルインスタンスを引数として指定してください。
         属性値が同じ値:
         model -> #{model}
      MSG
    end

    # エラーが1件でもある場合は例外を発生させる
    if error_messages.size >= 1
      raise error_messages.join('\n')
    end
  end
end
