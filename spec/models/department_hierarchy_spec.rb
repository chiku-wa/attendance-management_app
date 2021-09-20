require "rails_helper"

RSpec.describe "部署階層モデルのテスト", type: :model do
  # ===== テストデータを登録
  # ----- 部署テーブル
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
    # バリデーションテストを正確にテストするために、親テーブルである部署情報を登録する
    # ※presenceのRSpecテスト実行時、部署テーブルのレコードを保存しないまま部署階層テーブル
    #  をテストしようとすると、すべての属性がnilになり、正常にテストできないため
    let(fb) { FactoryBot.create(fb) }
  end

  before do
    # ===== テストデータを登録
    # ----- 部署階層
    # バリデーションテストは未保存が前提であるため、beforeでは配列のみを生成する。
    @department_hierarchies = []

    # 世代0のレコード(親=子の階層)を登録
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
      @department_hierarchies << DepartmentHierarchy.new(
        parent_department: eval("#{fb}"),
        child_department: eval("#{fb}"),
        generations: 0,
      )
    end

    # 世代1〜のレコードを登録
    [
      # A事業部　A01000000000
      # 　┗営業部　A01B01000000
      # 　　┗第一営業部　A01B01C01000
      # 　　　┗第一営業部　一課　　A01B01C01001
      # 　　　┗第一営業部　二課　　A01B01C01002
      # 　　┗第二営業部　A01B01C02000
      # 　　　┗第ニ営業部　　一課　　A01B01C02001
      # 　　　┗第ニ営業部　　ニ課　　A01B01C02002
      { parent_department: department_A, child_department: department_A_sales, generations: 1 },
      { parent_department: department_A, child_department: department_A_sales_department1, generations: 2 },
      { parent_department: department_A, child_department: department_A_sales_department1_division1, generations: 3 },
      { parent_department: department_A, child_department: department_A_sales_department1_division2, generations: 3 },
      { parent_department: department_A, child_department: department_A_sales_department2, generations: 2 },
      { parent_department: department_A, child_department: department_A_sales_department2_division1, generations: 3 },
      { parent_department: department_A, child_department: department_A_sales_department2_division2, generations: 3 },

      # 　┗営業部　A01B01000000
      # 　　┗第一営業部　A01B01C01000
      # 　　　┗第一営業部　一課　　A01B01C01001
      # 　　　┗第一営業部　二課　　A01B01C01002
      # 　　┗第二営業部　A01B01C02000
      # 　　　┗第ニ営業部　　一課　　A01B01C02001
      # 　　　┗第ニ営業部　　ニ課　　A01B01C02002
      { parent_department: department_A_sales, child_department: department_A_sales_department1, generations: 1 },
      { parent_department: department_A_sales, child_department: department_A_sales_department1_division1, generations: 2 },
      { parent_department: department_A_sales, child_department: department_A_sales_department1_division2, generations: 2 },
      { parent_department: department_A_sales, child_department: department_A_sales_department2, generations: 1 },
      { parent_department: department_A_sales, child_department: department_A_sales_department2_division1, generations: 2 },
      { parent_department: department_A_sales, child_department: department_A_sales_department2_division2, generations: 2 },

      # 　　┗第一営業部　A01B01C01000
      # 　　　┗第一営業部　一課　　A01B01C01001
      # 　　　┗第一営業部　二課　　A01B01C01002
      { parent_department: department_A_sales_department2, child_department: department_A_sales_department2_division1, generations: 1 },
      { parent_department: department_A_sales_department2, child_department: department_A_sales_department2_division2, generations: 1 },

      # 　　┗第二営業部　A01B01C02000
      # 　　　┗第ニ営業部　　一課　　A01B01C02001
      # 　　　┗第ニ営業部　　ニ課　　A01B01C02002
      { parent_department: department_A_sales_department1, child_department: department_A_sales_department1_division1, generations: 1 },
      { parent_department: department_A_sales_department1, child_department: department_A_sales_department1_division2, generations: 1 },
    ].each do |dh|
      @department_hierarchies << DepartmentHierarchy.new(dh)
    end

    # ===== テスト用インスタンス変数定義
    @department_hierarcy = @department_hierarchies.first
  end

  context "テストデータの事前確認用テスト" do
    it "前提となるテストデータがバリデーションを通過すること" do
      expect(@department_hierarcy).to be_valid
    end
  end

  context "バリデーションのテスト" do
    # ---------------------
    # --- 世代のテスト
    it "世代がスペース、空文字のみの場合はバリデーションエラーとなること" do
      valid_presence(
        model: @department_hierarcy,
        attribute: :generations,
      )
    end
  end

  context "複合ユニークのテスト" do
    it "親部署ID、子部署IDの組み合わせが同じレコードが複数存在する場合はバリデーションエラーとなること" do
      valid_uniques(
        model: @department_hierarcy,
        attribute_and_value_hash: {
          parent_department: department_A_sales_department1,
          child_department: department_A_sales_department1_division1,
        },
        is_case_sensitive: false,
      )
    end
  end

  pending "remove_relationメソッドのテスト" do
    pending "最上位の部署の場合は、配下の情報のみが削除されること" do
    end

    pending "末端の部署の場合は、親部署の情報のみが削除されること" do
    end
  end

  context "add_childメソッドのテスト" do
    it "既存の親子関係を反転したデータが登録されようとした場合にはエラーとなること" do
      # 初期データとして親子関係を作成
      DepartmentHierarchy.import(@department_hierarchies)

      # 初期データの親子関係を反転させたデータを作成
      expect {
        DepartmentHierarchy.add_child(
          parent_department: department_A_sales,
          child_department: department_A,
        )
      }.to raise_error("循環する親子関係は登録できません。子部署として追加しようとしている部署がすでに親として設定されていないか確認してください。")
    end

    pending "想定通りのレコード数となっていること" do
      # --- 世代1〜2の親子関係の追加
      # [例]
      # A:世代1
      # ┗B:世代2 ★追加

      # 子部署を追加する
      department_A.add_child(department_A_sales)

      # 件数が想定どおりであること
      # 1組の親子関係を作成した場合以下の内訳になる。
      # * A・Bの自分自身のレコード：1+1=2件
      # * 親子関係(A-B)のレコード：1件
      expect(DepartmentHierarchy.count).to eq 3

      # --- 世代2〜3の親子関係の追加
      # 先ほど追加した子部署の配下に更に子部署を追加する
      # [例]
      # A:世代1
      # ┗B:世代2
      #  ┗C:世代3 ★追加
      department_A_sales.add_child(department_A_sales_department1)

      # 件数が想定どおりであること
      # 先ほど登録した親子関係も含め、以下の内訳になる。
      # * A・B・Cの自分自身のレコード：1+1+1=3件
      # * 親子関係(A-B、B-C)のレコード：2件
      # * A-Cの親子関係のレコード：1件
      expect(DepartmentHierarchy.count).to eq 6
    end

    it "parent_department,child_departmentに自身のIDが指定されているレコードが登録されていること" do
      # 子部署を追加する
      DepartmentHierarchy.add_child(
        parent_department: department_A,
        child_department: department_A_sales,
      )
      DepartmentHierarchy.add_child(
        parent_department: department_A_sales,
        child_department: department_A_sales_department1,
      )

      # 階層情報に自身のIDが指定されているIDが登録されていること
      [
        department_A,
        department_A_sales,
        department_A_sales_department1,
      ].each do |d|
        expect(DepartmentHierarchy.where(parent_department: d, child_department: d).exists?).to be_truthy
      end
    end

    pending "階層テーブルに適切な親子関係、世代情報が登録されていること" do
      # 子部署を追加する
      # [例]
      # A:世代1
      # ┗B:世代2
      #  ┗C:世代3
      department_A.add_child(department_A_sales)
      department_A_sales.add_child(department_A_sales_department1)

      # --- 親子関係の閉包データが登録されていること
      expect(DepartmentHierarchy.where(parent_department: department_A, child_department: department_A_sales).exists?).to be_truthy
      expect(DepartmentHierarchy.where(parent_department: department_A_sales, child_department: department_A_sales_department1).exists?).to be_truthy

      # --- 世代情報が登録されていること
      # A-Bの世代差 → 1
      # expect(DepartmentHierarchy.where(parent_department: department_A, child_department: department_A_sales).generations).to eq 1

      # A-Cの世代差 → 2
    end
  end

  pending "get_childsメソッドのテスト" do
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
