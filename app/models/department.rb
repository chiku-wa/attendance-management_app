class Department < ApplicationRecord

  # === 従属関係
  # 部署階層
  has_many :hierarchy_departments

  # 社員-部署
  has_many :employee_departments

  # === バリデーション
  # --- 単一の属性に対するバリデーション
  # 部署コード
  validates(
    :department_code,
    {
      presence: true,
      length: { maximum: 12 },
    }
  )

  # 設立日
  validates(
    :establishment_date,
    {
      presence: true,
    }
  )

  # 廃止日
  validates(
    :abolished_date,
    {
      presence: true,
    }
  )

  # 部署名
  validates(
    :department_name,
    {
      presence: true,
      length: { maximum: 200 },
    }
  )

  # 部署名(カナ)
  validates(
    :department_kana_name,
    {
      presence: true,
      length: { maximum: 400 },
    }
  )

  # --- 複数の属性に対するバリデーション
  # 部署コード、設立日、廃止日の複合ユニーク
  validates(
    :department_code,
    uniqueness: {
      scope: [
        :establishment_date,
        :abolished_date,
      ],
      # 部署コードの大文字小文字を区別せず一意とする
      case_sensitive: false,
    },
  )

  # === パブリックメソッド

  # ----------------------------------------------------
  # # 概要
  # [閉包テーブルモデルのメソッド]
  # レシーバの部署に対して、引数の部署モデル子部署として紐付ける。
  # 部署階層テーブルに対して、閉包テーブルモデル形式で階層情報を登録する。
  #
  # # 引数
  # * child_department
  # 子部署として紐付けたい部署のモデルインスタンス。
  #
  def add_child(child_department)
    # --- エラーチェック
    # 既存の親子関係を反転したデータが登録されようとした場合にはエラーとする
    if DepartmentHierarchy.find_by(
      parent_department: child_department,
      child_department: self,
    )
      raise("循環する親子関係は登録できません。子部署として追加しようとしている部署がすでに親として設定されていないか確認してください。")
    end

    # --- 親・子それぞれの自分自身を閉包テーブルに登録する、二重登録はNGのためすでに登録済みならスキップする
    # 親部署
    add_own_hierarchy(self)

    # 子部署
    add_own_hierarchy(child_department)

    # --- レシーバと引数の部署の親子関係のレコードを生成する
    DepartmentHierarchy.create(parent_department: self, child_department: child_department)

    # --- 引数の部署の配下に子部署が存在する場合、その子部署すべてに対して、レシーバの部署を親として設定する
    # TODO：実装する

  end

  # # 概要
  # [閉包テーブルモデルのメソッド]
  # レシーバの部署の配下に存在するすべての部署を部署モデルインスタンスのハッシュとして返す。
  # ハッシュは以下の性質がある。
  # * レシーバの部署は戻り値には含めない
  # * ハッシュのkeyは親部署を指し、valueは子部署を指す。
  # * 子部署が存在しない場合、valueは空のハッシュ({})となる
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
  # レシーバがA事業部の場合、戻り値は以下の通りとなる。
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
  # レシーバがB事業部の場合、戻り値は以下の通りとなる。
  # ```ruby
  # {}
  # ```
  #
  def get_childs
    childs_hash = {}
  end

  # === プライベートメソッド
  private

  # ----------------------------------------------------
  # # 概要
  # 引数の部署モデルインスタンスを、親部署ID・子部署IDに設定して部署階層テーブルに登録する
  # すでに同一のレコードが存在する場合は登録しない。
  #
  # # 引数
  # * department
  # 登録したい部署のモデルインスタンス。
  #
  def add_own_hierarchy(department)
    department_hierarcy_hash = { parent_department: department, child_department: department }
    DepartmentHierarchy.new(department_hierarcy_hash).save
  end
end
