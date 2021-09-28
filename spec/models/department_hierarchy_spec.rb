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
    # バリデーションテストを正確にテストするために、親テーブルである部署情報はDBに保存する
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

  context "remove_relationメソッドのテスト" do
    it "世代:0のレコードは削除されないこと" do
      # 初期データとして親子関係を作成
      DepartmentHierarchy.import(@department_hierarchies)
      expect_department_hierarchies_num = DepartmentHierarchy.where(
        generations: 0,
      ).size

      # メソッドを実行し、部署階層を削除
      DepartmentHierarchy.remove_relation(
        parent_department: department_A_sales_department1,
        child_department: department_A_sales_department1_division1,
      )

      # 世代:0のレコード数が変わらない(削除されていない)こと
      expect(
        DepartmentHierarchy.where(generations: 0).size
      ).to eq expect_department_hierarchies_num
    end

    it "想定通り部署階層が削除されること" do
      # --- 想定する処理
      # A事業部配下の営業部をB事業部に付け替える
      #
      # [before]
      # A事業部 department_A
      # ┗営業部 department_A_sales
      # 　┗第一営業部 department_A_sales_department1
      # 　　┗第一営業部 一課 department_A_sales_department1_division1
      # 　　┗第一営業部 二課 department_A_sales_department1_division2
      # ....
      # B事業部 department_B
      #  ↓
      # [before]
      # A事業部 department_A
      # ....
      # B事業部 department_B
      # ┗営業部 department_A_sales
      # 　┗第一営業部 department_A_sales_department1
      # 　　┗第一営業部 一課 department_A_sales_department1_division1
      # 　　┗第一営業部 二課 department_A_sales_department1_division2
      #
      # この場合、部署階層の追加メソッドの想定引数は下記のとおりとなる。
      # add_child(
      #  parent_department: department_B,
      #  child_department: department_A_sales
      # )
      #
      # この場合、remove_relationに渡される引数は以下の通りとなる。
      # remove_relation(
      #   parent_department: <add_childの引数child_departmentに対してすでに紐付いている親部署のID>,
      #   child_department: <add_childの引数child_department>,
      # )
      # →remove_relation(
      #   parent_department: A事業部 department_A,
      #   child_department: 営業部 department_A_sales,
      # )
      #
      # 削除される部署は直積の関係にあるため、以下のDELETE文が発行される。
      # DELETE FROM 部署階層
      # WHERE
      #   親部署ID IN (A事業部 department_A)
      #   AND
      #   子部署ID IN (
      #     営業部 department_A_sales
      #     , 第一営業部 department_A_sales_department1
      #     , 第一営業部 一課 department_A_sales_department1_division1
      #     , 第一営業部 二課 department_A_sales_department1_division2
      #     , 第二営業部 department_A_sales_department2
      #     , 第二営業部 一課 department_A_sales_department2_division1
      #     , 第二営業部 二課 department_A_sales_department2_division2
      #   )

      # テスト用データをsave
      DepartmentHierarchy.import(@department_hierarchies)

      # 後の処理で期待値を評価するために、部署階層を削除する前のレコード数を保存
      department_hierarchy_num_before = DepartmentHierarchy.count

      # 削除されることを期待する部署階層の一覧を定義する
      expect_deleted_department_hierarchies = []
      # [0]:親部署ID
      # [1]:子部署ID
      # [2]:世代
      [
        [department_A, department_A_sales, 1],
        [department_A, department_A_sales_department1, 2],
        [department_A, department_A_sales_department1_division1, 3],
        [department_A, department_A_sales_department1_division2, 3],
        [department_A, department_A_sales_department2, 2],
        [department_A, department_A_sales_department2_division1, 3],
        [department_A, department_A_sales_department2_division2, 3],
      ].each do |arr|
        # 部署階層はparent_department,child_departmentの組み合わせで一意であるため、
        # これらを抽出条件にしている時点で1件しかレコードは返ってこないことは保証されているため、
        # find_byを用いる。
        expect_deleted_department_hierarchies << DepartmentHierarchy.find_by({
          parent_department: arr[0],
          child_department: arr[1],
          generations: arr[2],
        })
      end

      # メソッド実行前は、削除予定のレコードが存在することを確認する
      # ※抽出条件に一致しないレコードが含まれている場合は、whereメソッドの戻り値が空の配列
      #  となるため、それを判断基準とする。
      expect(expect_deleted_department_hierarchies.include?([])).to be_falsey

      # メソッドを実行し、部署階層を削除
      DepartmentHierarchy.remove_relation(
        parent_department: department_A,
        child_department: department_A_sales,
      )

      # メソッド実行後は、想定するレコードが存在しないこと
      expect(
        DepartmentHierarchy.where(
          id: expect_deleted_department_hierarchies.map(&:id),
        ).size
      ).to eq 0

      # 想定外のレコードが削除されていないこと
      expect(DepartmentHierarchy.count).to eq (department_hierarchy_num_before - expect_deleted_department_hierarchies.size)
    end
  end

  context "add_childメソッドのテスト" do
    it "既存の親子関係を反転したデータが登録されようとした場合にはエラーとなること" do
      # 初期データとして親子関係を作成
      DepartmentHierarchy.create(
        parent_department: department_A,
        child_department: department_A_sales,
        generations: 1,
      )

      # 初期データの親子関係を反転させたデータを作成
      expect {
        DepartmentHierarchy.add_child(
          parent_department: department_A_sales,
          child_department: department_A,
        )
      }.to raise_error("循環する親子関係は登録できません。子部署として追加しようとしている部署がすでに親として設定されていないか確認してください。")
    end

    it "世代:0(親部署ID=子部署ID)のレコードが新規に生成されること" do
      # メソッド実行前はレコードが存在しないこと
      expect(DepartmentHierarchy.count).to eq 0

      # メソッドを実行し、自身と同じレコードを生成する
      DepartmentHierarchy.add_child(
        parent_department: department_A,
        child_department: department_A_sales,
      )

      # メソッド実行後は親部署ID=子部署ID、世代0のレコードが生成されていること
      [
        department_A,
        department_A_sales,
      ].each do |d|
        expect(DepartmentHierarchy.find_by(
          parent_department: d,
          child_department: d,
          generations: 0,
        )).not_to be_nil
      end
    end

    # === 想定する処理の概要
    # 「A事業部」配下の「営業部」を「B事業部」に付け替える
    #
    # [before]
    # A事業部 department_A
    # ┗営業部 department_A_sales
    # 　┗第一営業部 department_A_sales_department1
    # 　　┗第一営業部 一課 department_A_sales_department1_division1
    # 　　┗第一営業部 二課 department_A_sales_department1_division2
    # 　┗第二営業部　A01B01C02000
    # 　　┗第ニ営業部　　一課　　A01B01C02001
    # 　　┗第ニ営業部　　ニ課　　A01B01C02002
    # B事業部 department_B
    #  ↓
    # [before]
    # A事業部 department_A
    # 　┗第二営業部　A01B01C02000
    # 　　┗第ニ営業部　　一課　　A01B01C02001
    # 　　┗第ニ営業部　　ニ課　　A01B01C02002
    # B事業部 department_B
    # ┗営業部 department_A_sales
    # 　┗第一営業部 department_A_sales_department1
    # 　　┗第一営業部 一課 department_A_sales_department1_division1
    # 　　┗第一営業部 二課 department_A_sales_department1_division2
    #
    # この場合、部署階層の追加メソッドの想定引数は下記のとおりとなる。
    # add_child(
    #  parent_department: department_B,
    #  child_department: department_A_sales
    # )
    it "既存部署の親子関係を付け替えできること" do
      # === 事前準備
      # テスト用データをsave
      DepartmentHierarchy.import(@department_hierarchies)

      # メソッド実行前のレコード数を保存
      # ※ 既存部署の付替なので、メソッド実行前後でレコード数は変わらない
      num_of_record_before = DepartmentHierarchy.count

      # === メソッドを実行し、期待値を確認
      DepartmentHierarchy.add_child(
        parent_department: department_B,
        child_department: department_A_sales,
      )

      # NOTE: remove_relationの妥当性は別のメソッドでテスト済みのため、ここではテストしない

      # --- 部署がつけ変わっていることを確認する
      # 付け替え対象になっている部署の一覧(add_childの引数の子部署と、その子部署配下の部署の一覧)
      # [構成]
      # ┗営業部 department_A_sales
      # 　┗第一営業部 department_A_sales_department1
      # 　　┗第一営業部 一課 department_A_sales_department1_division1
      # 　　┗第一営業部 二課 department_A_sales_department1_division2
      # 　┗第二営業部　A01B01C02000
      # 　　┗第ニ営業部　　一課　　A01B01C02001
      # 　　┗第ニ営業部　　ニ課　　A01B01C02002
      target_child_departments = [
        department_A_sales,
        department_A_sales_department1,
        department_A_sales_department1_division1,
        department_A_sales_department1_division2,
        department_A_sales_department2,
        department_A_sales_department2_division1,
        department_A_sales_department2_division2,
      ]

      # 付替前の部署の配下には、引数として渡した子部署と、その子部署の配下の部署が存在しないこと
      previous_parent_department_hierarchies = DepartmentHierarchy.where(
        # 付替前の部署
        parent_department: department_A,
      )
      target_child_departments.each do |d|
        expect(
          previous_parent_department_hierarchies.find_by(id: d.id)
        ).to be_nil
      end

      # 付替後の部署の配下には、引数として渡した子部署と、その配下の部署が存在すること
      following_parent_department_hierarchies = DepartmentHierarchy.where(
        # 付替後の部署
        parent_department: department_B,
      )
      ap "========================="
      ap following_parent_department_hierarchies
      ap "========================="

      target_child_departments.each do |d|
        expect(
          following_parent_department_hierarchies.find_by(
            child_department_id: d.id,
          )
        ).not_to be_nil
      end

      # --- メソッド実行前後でレコード数が変わらないこと
      expect(DepartmentHierarchy.count).to eq num_of_record_before
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
