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
  # レシーバの部署に対して、引数として渡した部署モデル子部署として紐付ける。
  # 部署階層テーブルに対して、閉包テーブルモデル形式で階層情報を登録する。
  #
  # # 引数
  # * child_department
  # 子部署として紐付けたい部署のモデルインスタンス。
  #
  def add_child(child_department)
    # --- 親・子それぞれの自分自身を閉包テーブルに登録する、二重登録はNGのためすでに登録済みならスキップする
    # 親部署
    add_own_hierarchy(self)

    # 子部署
    add_own_hierarchy(child_department)

    # --- 親子関係のレコードを生成する
    DepartmentHierarchy.create(parent_department: self, child_department: child_department)
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
