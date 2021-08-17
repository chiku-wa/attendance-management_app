require "rails_helper"

RSpec.describe "部署モデルのテスト", type: :model do
  # ----- テストデータを登録
  # ※部署の階層構造は該当するFactoryBotのコメントを参照のこと
  [
    :department_A,
    :department_A_sales,
    :department_A_sales_department1,
    :department_A_sales_department1_division1,
    :department_A_sales_department1_division2,
    :department_A_sales_department2,
    :department_A_sales_department2_division1,
    :department_A_sales_department2_division2,
    :department_B,
  ].each do |fb|
    let(fb) { FactoryBot.build(fb) }
  end

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(department_A).to be_valid
      expect(department_A_sales).to be_valid
      expect(department_A_sales_department1).to be_valid
      expect(department_A_sales_department1_division1).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- 部署コードのテスト
    it "部署コードがスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: department_A,
        attribute: :department_code,
      )
    end

    it "部署コードが規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
      valid_maximum_num_of_char(
        model: department_A,
        attribute: :department_code,
        valid_number_of_characters: 12,
      )
    end

    # ---------------------
    # --- 設立日のテスト
    it "設立日がnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: department_A,
        attribute: :establishment_date,
      )
    end

    # ---------------------
    # --- 廃止日のテスト
    it "廃止日がnilの場合はバリデーションエラーとなること" do
      valid_presence(
        model: department_A,
        attribute: :abolished_date,
      )
    end
  end

  # ---------------------
  # --- 部署名のテスト
  it "部署名がスペース、空文字のみの場合はバリデーションエラーとなること" do
    valid_presence(
      model: department_A,
      attribute: :department_name,
    )
  end

  it "部署名が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
    valid_maximum_num_of_char(
      model: department_A,
      attribute: :department_name,
      valid_number_of_characters: 200,
    )
  end

  # ---------------------
  # --- 部署名(カナ)のテスト
  it "部署名(カナ)がスペース、空文字のみの場合はバリデーションエラーとなること" do
    valid_presence(
      model: department_A,
      attribute: :department_kana_name,
    )
  end

  it "部署名(カナ)が規定の最大文字数(全角、半角区別なし)を超えている場合はバリデーションエラーとなること" do
    valid_maximum_num_of_char(
      model: department_A,
      attribute: :department_kana_name,
      valid_number_of_characters: 400,
    )
  end

  context "複合ユニークのテスト" do
    it "部署コード、設立日、廃止日の組み合わせが同じレコードが複数存在する場合はバリデーションエラーとなること" do
      valid_uniques(
        model: department_A,
        attribute_and_value_hash: {
          department_code: "A01B01000000",
          establishment_date: Time.zone.local(2021, 5, 1, 0, 0, 0),
          abolished_date: Time.zone.local(2021, 5, 31, 23, 59, 59),
        },
        is_case_sensitive: false,
      )
    end
  end

  context "add_childメソッドのテスト" do
    it "既存の親子関係を反転したデータが登録されようとした場合にはエラーとなること" do
      # 初期データとして親子関係を作成
      department_A.add_child(department_A_sales)

      # 初期データの親子関係を反転させたデータを作成
      expect {
        department_A_sales.add_child(department_A)
      }.to raise_error("循環する親子関係は登録できません。子部署として追加しようとしている部署がすでに親として設定されていないか確認してください。")
    end

    it "階層テーブルに、自身親・子となっているレコードが登録されていること" do
      # 子部署を追加する
      department_A.add_child(department_A_sales)

      # --- 件数が想定どおりであること
      # 1組の親子関係を作成した場合以下の内訳になる。
      # 親・子それぞれで自分自身のレコードを登録：2件
      # 親子関係のレコード：1件
      expect(DepartmentHierarchy.count).to eq 3

      # --- 自分自身の階層情報が閉包データとして登録されていること
      [
        department_A,
        department_A_sales,
      ].each do |d|
        expect(DepartmentHierarchy.where(parent_department: d, child_department: d).exists?).to be_truthy
      end

      # --- 親子関係の閉包データが登録されていること
      expect(DepartmentHierarchy.where(parent_department: department_A, child_department: department_A_sales).exists?).to be_truthy
    end
  end

  context "get_childsメソッドのテスト" do
    skip "想定する親子関係を取得できること" do
      # 以下の親子関係を作成する
      # department_A
      #   ┗department_A_sales
      #     ┗department_A_sales_department1
      #       ┗department_A_sales_department1_division1
      #       ┗department_A_sales_department1_division2
      #     ┗department_A_sales_department2
      #       ┗department_A_sales_department2_division1
      #       ┗department_A_sales_department2_division2
      # department_B
      #
      department_A.add_child(department_A_sales)
      department_A_sales.add_child(department_A_sales_department1)
      department_A_sales_department1.add_child(department_A_sales_department1_division1)
      department_A_sales_department1.add_child(department_A_sales_department1_division2)
      department_A_sales_department2.add_child(department_A_sales_department2_division1)
      department_A_sales_department2.add_child(department_A_sales_department2_division2)

      # === 子部署が存在する部署の場合は、子部署のハッシュが返ってくること
      # ---テスト対象部署:department_A
      # [想定戻り値]
      # {
      #   department_A_sales => {
      #     department_A_sales_department1 => {
      #       department_A_sales_department1_division1 => {},
      #       department_A_sales_department1_division2 => {},
      #     },
      #     department_A_sales_department2 => {
      #       department_A_sales_department2_division1 => {},
      #       department_A_sales_department2_division2 => {},
      #     },
      #   }
      # }
      h_department_A = department_A.get_childs
      expect(
        h_department_A[department_A_sales][department_A_sales_department1][department_A_sales_department1_division1]
      ).to eq ({})
      expect(
        h_department_A[department_A_sales][department_A_sales_department1][department_A_sales_department1_division2]
      ).to eq ({})
      expect(
        h_department_A[department_A_sales][department_A_sales_department2][department_A_sales_department2_division1]
      ).to eq ({})
      expect(
        h_department_A[department_A_sales][department_A_sales_department2][department_A_sales_department2_division2]
      ).to eq ({})

      # ---テスト対象部署:department_A_sales
      # [想定戻り値]
      # {
      #   department_A_sales_department1 => {
      #     department_A_sales_department1_division1 => {},
      #     department_A_sales_department1_division2 => {},
      #   },
      #   department_A_sales_department2 => {
      #     department_A_sales_department2_division1 => {},
      #     department_A_sales_department2_division2 => {},
      #   },
      # }
      h_department_A_sales = department_A_sales.get_childs
      expect(
        h_department_A_sales[department_A_sales_department1][department_A_sales_department1_division1]
      ).to eq ({})
      expect(
        h_department_A_sales[department_A_sales_department1][department_A_sales_department1_division2]
      ).to eq ({})
      expect(
        h_department_A_sales[department_A_sales_department2][department_A_sales_department2_division1]
      ).to eq ({})
      expect(
        h_department_A_sales[department_A_sales_department2][department_A_sales_department2_division2]
      ).to eq ({})

      # ---テスト対象部署:department_A_sales_department1
      # [想定戻り値]
      # {
      #   department_A_sales_department1_division1 => {},
      #   department_A_sales_department1_division2 => {},
      # }
      h_department_A_sales_department1 = department_A_sales_department1.get_childs
      expect(
        h_department_A_sales_department1[department_A_sales_department1_division1]
      ).to eq ({})
      expect(
        h_department_A_sales_department1[department_A_sales_department1_division2]
      ).to eq ({})

      # ---テスト対象部署:department_A_sales_department2
      # [想定戻り値]
      # {
      #   department_A_sales_department2_division1 => {},
      #   department_A_sales_department2_division2 => {},
      # }
      h_department_A_sales_department2 = department_A_sales_department2.get_childs
      expect(
        h_department_A_sales_department2[department_A_sales_department2_division1]
      ).to eq ({})
      expect(
        h_department_A_sales_department2[department_A_sales_department2_division2]
      ).to eq ({})

      # === 子部署が存在しない部署(独立した部署 or 末端部署)の場合は空のハッシュが返ってくること
      # ---テスト対象部署:department_A
      #                 department_A_sales_department1_division1
      #                 department_A_sales_department1_division2
      #                 department_A_sales_department2_division1
      #                 department_A_sales_department2_division2
      #                 department_B
      # [想定戻り値]
      # {}
      [
        department_A_sales_department1_division1,
        department_A_sales_department1_division2,
        department_A_sales_department2_division1,
        department_A_sales_department2_division2,
        department_B,
      ].each do |d|
        h = d.get_childs
        expect(h.size).to eq 0
        expect(h).to eq({})
      end
    end
  end
end
