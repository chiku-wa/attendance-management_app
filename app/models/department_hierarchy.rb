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
    # --- エラーチェック
    # 既存の親子関係を反転したデータが登録されようとした場合にはエラーとする
    if DepartmentHierarchy.find_by(
      parent_department: child_department,
      child_department: parent_department,
    )
      raise("循環する親子関係は登録できません。子部署として追加しようとしている部署がすでに親として設定されていないか確認してください。")
    end

    # --- 親・子それぞれの自分自身を閉包テーブルに登録する、二重登録はNGのためすでに登録済みならスキップする
    # 親部署
    add_own_hierarchy(parent_department)

    # 子部署
    add_own_hierarchy(child_department)

    # --- 引数の部署の親子関係のレコードを生成する
    DepartmentHierarchy.create(parent_department: parent_department, child_department: child_department)

    # --- 引数の子部署部署の配下にさらに子部署が存在する場合、それらの子部署すべてに対して、引数の部署を親として設定する
    # TODO：実装する

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

  # =============== プライベートメソッド
  private

  # ----------------------------------------------------
  # # 概要
  # 部署階層テーブルに、引数の部署モデルインスタンスを、親部署ID・子部署IDに設定して
  # 部署階層テーブルに登録する。
  # すでに同一のレコードが存在する場合は登録しない。
  #
  # # 引数
  # * department
  # 登録したい部署のモデルインスタンス。
  #
  def self.add_own_hierarchy(department)
    # ===
    # find_or_create_byメソッドで、同じ組み合わせのレコードが存在すれば生成し、存在すれば生成しない
    DepartmentHierarchy.find_or_create_by(
      parent_department: department,
      child_department: department,
      generations: 0,
    )

    department_hierarcy_hash = {
      parent_department: department,
      child_department: department,
      generations: 0,
    }
    DepartmentHierarchy.new(department_hierarcy_hash).save
  end

  # [概要]
  # add_child()メソッドでのみ使用するメソッド。
  # add_child()メソッドの引数(子部署)がすでに親子関係を持っている場合、関連する親子関係を
  # すべて削除する。
  # ただし、親部署ID＝子部署IDとなっているレコード(世代:0)は削除しない。
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
