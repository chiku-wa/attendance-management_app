class DepartmentHierarchy < ApplicationRecord
  # =============== 従属関係
  # 親部署
  belongs_to(
    :parent_department,
    { class_name: Department.name, foreign_key: "parent_department_id" }
  )

  # 子部署
  belongs_to(
    :child_department,
    { class_name: Department.name, foreign_key: "child_department_id" }
  )

  # =============== バリデーション
  # --- 単一の属性に対するバリデーション
  # 世代
  validates(
    :generations,
    {
      presence: true,
    }
  )

  # --- 複数の属性に対するバリデーション
  # 親部署、子部署の複合ユニーク
  validates(
    :parent_department,
    uniqueness: {
      scope: [
        :parent_department,
        :child_department,
      ],
    },
  )

  # =============== パブリックメソッド

  # ----------------------------------------------------
  # # 概要
  # [閉包テーブルモデルのメソッド]
  # 引数の親部署に対して、引数の部署モデル子部署として紐付ける。
  # 部署階層テーブルに対して、閉包テーブルモデル形式で階層情報を登録する。
  #
  # 図を交えた解説は下記の通り。
  # https://docs.google.com/spreadsheets/d/1CBhZUgEMrRyd-Trv4FnO5cIrsOcu-ithNDEERFCkMUg/edit?usp=sharing
  #
  # # 引数
  # * parent_department
  # 親部署として紐付けたい部署のモデルインスタンス。
  # * child_department
  # 子部署として紐付けたい部署のモデルインスタンス。
  #
  def self.add_child(parent_department:, child_department:)
    # === 既存の親子関係を反転したデータが登録されようとした場合にはエラーとする
    if DepartmentHierarchy.find_by(
      parent_department: child_department,
      child_department: parent_department,
    )
      raise("循環する親子関係は登録できません。子部署として追加しようとしている部署がすでに親として設定されていないか確認してください。")
    end

    # === 既存の親子関係を削除する
    # 以下の条件に合致する場合のみ、親子関係を削除する
    # ①引数の子部署に対して、すでに直属(世代=1)の親部署が紐付いている
    # ②引数で渡された親部署と1.の親部署が同じでない
    #   [②の詳細]
    #   ・同じでない：子部署には1つの親部署しか紐付かないため、すでに別の親部署が紐付いているなら親子関係の削除(以降の処理)が必要
    #   ・同じ     ：登録しようとしている親子関係がすでに登録されているので以降の処理(親子関係削除)が不要

    # 引数の子部署の、直属の親部署(世代=1)を抽出する
    existing_department_hierarchy = DepartmentHierarchy.find_by(
      child_department: child_department,
      generations: 1,
    )

    # 条件に一致する場合は親子関係を削除する
    if (existing_department_hierarchy &&
        parent_department != existing_department_hierarchy.parent_department)
      remove_relation(
        parent_department: Department.find(
          existing_department_hierarchy.parent_department.id
        ),
        child_department: child_department,
      )
    end

    # === 世代=0のレコード(親・子それぞれの自分自身となっているレコード)を生成する。
    #     二重登録はNGのためすでに登録済みならスキップする。
    [
      parent_department,
      child_department,
    ].each do |d|
      DepartmentHierarchy.find_or_create_by!(
        parent_department_id: d.id,
        child_department_id: d.id,
        generations: 0,
      )
    end

    # === 親子関係を登録する
    #     引数の子部署部署の配下にさらに子部署が存在する場合、それらの子部署すべてに対して、
    #     引数の部署を親として設定する。

    # 今回追加しようとしている親の、さらに親の一覧を取得する
    parent_department_hierarchies = DepartmentHierarchy.where(
      child_department_id: parent_department.id,
    )

    # 今回追加しようとしている子の、さらに子の一覧を取得する
    child_department_hierarchies = DepartmentHierarchy.where(
      parent_department_id: child_department.id,
    )

    # バルクインサート用配列を生成し、一括登録
    insert_department_hierarchies = []

    parent_department_hierarchies.each do |pd|
      child_department_hierarchies.each do |cd|
        insert_department_hierarchies << DepartmentHierarchy.new(
          parent_department: pd.parent_department,
          child_department: cd.child_department,
          generations: (pd.generations + cd.generations + 1),
        )
      end
    end

    DepartmentHierarchy.import(insert_department_hierarchies)
  end

  # # 概要
  # [閉包テーブルモデルのメソッド]
  # 引数の部署の配下に存在するすべての部署を部署モデルインスタンスのハッシュとして返す。
  # ハッシュは以下の性質がある。
  # * 引数の部署は戻り値には含めない
  # * ハッシュのkeyは親部署を指し、valueは子部署を指す。
  # * 子部署が存在しない場合、valueは空のハッシュ({})となる
  #
  # # 引数
  # * department
  # 子部署の一覧を取得したい部署。
  #
  # 例：以下の階層の場合。
  # ```
  # A事業部　A01000000000
  #   ┗営業部　A01B01000000
  #     ┗第一営業部　A01B01C01000
  #       ┗第一営業部　一課　　A01B01C01001
  #       ┗第一営業部　二課　　A01B01C01002
  #     ┗第二営業部　A01B01C02000
  #       ┗第ニ営業部　　一課　　A01B01C02001
  #       ┗第ニ営業部　　ニ課　　A01B01C02002
  # B事業部　B01000000000
  # ```
  #
  # 子部署がA事業部の場合、戻り値は以下の通りとなる。
  # ```ruby
  # {
  #   営業部 => {
  #     第一営業部 => {
  #       第一営業部 一課 => {},
  #       第一営業部 ニ課 => {},
  #     },
  #     第ニ営業部 => {
  #       第ニ営業部 一課 => {},
  #       第ニ営業部 ニ課 => {},
  #     },
  #   }
  # }
  # ````
  #
  # 子部署がB事業部の場合、戻り値は以下の通りとなる。
  # ```ruby
  # {}
  # ```
  #
  def self.get_childs(department:)
    childs_hash = {}
  end

  # # 概要
  # [デバッグ用:テストは作成しない]
  # 部署階層テーブルをいい感じに整形して標準出力するメソッド。
  #
  # # 引数
  # なし
  #
  # 部署階層が以下の形式になっている場合。
  # A事業部　A01000000000
  #   ┗営業部　A01B01000000
  #     ┗第一営業部　A01B01C01000
  #       ┗第一営業部　一課　　A01B01C01001
  #
  # 出力は以下の通り。
  # <hr>
  # [世代:0]
  # A事業部　A01000000000
  # <hr>
  # [世代:1]
  # A事業部　A01000000000
  #   ┗営業部　A01B01000000
  # <hr>
  # [世代:2]
  # A事業部　A01000000000
  #     ...
  #       ┗第一営業部　A01B01C01000
  # <hr>
  # [世代:3]
  # A事業部　A01000000000
  #     ...
  #     ...
  #       ┗第一営業部　一課　　A01B01C01001
  #
  def self.awesome_print_hierarchies
    # 出力用文字列用配列定義
    output_str = []

    # 階層の度合いを示すインデント文字列
    indent_str = "  "

    # 省略文字(世代2以降の場合のみ使用するため、予めインデント文字列を挿入する)
    omit_str = "#{indent_str}...\n"

    DepartmentHierarchy.order(:parent_department_id, :generations).each do |dh|

      # 「世代:XX」
      output_str << "[世代:#{dh.generations}]\n"
      output_str << "#{dh.parent_department.department_name}\n"

      # 「...」 世代差が1以下の場合は出力しないため、-1してループさせる
      (dh.generations - 1).times do |n|
        output_str << "#{(indent_str * n) + (omit_str)}\n"
      end

      if dh.generations >= 1
        # 「<空白>┗」
        output_str << (indent_str * dh.generations) + "┗#{dh.child_department.department_name}\n"
      end

      # 区切り文字
      output_str << "-------------------------------------\n"
    end

    puts output_str.join
  end

  # =============== プライベートメソッド
  private

  # [概要]
  # add_child()メソッドでのみ使用するメソッド。
  # add_child()メソッドの引数(子部署)がすでに親子関係を持っている場合、関連する親子関係を
  # すべて削除する。
  # ただし、世代:0(親部署ID＝子部署IDとなっている)のレコードは削除しない。
  #
  # [引数]
  # * parent_department
  # add_child()メソッドの引数の引数(子部署)に対して、すでに紐付いている親部署のID
  # * child_department
  # add_child()メソッドの引数の子部署
  #
  def self.remove_relation(parent_department:, child_department:)
    # add_child()メソッド引数(子部署)の、親のID一覧を取得する(直属より上の親部署も含む)
    parent_department_ids = DepartmentHierarchy.where(
      child_department_id: parent_department.id,
    ).pluck(:parent_department_id)

    # add_child()メソッドの引数(子部署)の配下の、子部署のID一覧を取得する
    child_department_ids = DepartmentHierarchy.where(
      parent_department_id: child_department.id,
    ).pluck(:child_department_id)

    # 閉包テーブルモデルで関連する親子関係を削除したい場合、削除したい部署は、
    # 引数(子部署)が持つ、親と子の直積で求めることができる。
    #
    # [例]
    # 引数の親部署が持つ「親」の一覧：
    # parent_department_ids → [1,2]
    #
    # 引数の親部署が持つ「子」の一覧：
    # child_department_ids → [3,4,5]
    #
    # DELETE FROM
    #   member_ship_hierarchy
    # WHERE
    #   parent_department_id IN (1, 2)
    #   AND
    #   child_department_id IN (3, 4, 5);
    #
    # 削除対象は以下の6レコードとなる。
    # [1, 3] [1, 4] [1, 5] [2, 3] [2, 4] [2, 5]
    #
    DepartmentHierarchy.delete_by(
      parent_department_id: parent_department_ids,
      child_department_id: child_department_ids,
    )
  end
end
