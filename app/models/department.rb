class Department < ApplicationRecord

  # =============== 従属関係
  # 部署階層
  has_many :hierarchy_departments

  # 社員-部署
  has_many :employee_departments

  # =============== バリデーション
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
      # 複合ユニークのため、バリデーションエラーメッセージを明示的に定義する
      message: "、#{Department.human_attribute_name(:establishment_date)}、#{Department.human_attribute_name(:abolished_date)}の組み合わせが同じ#{Department.model_name.human}がすでに存在します。",
    },
  )

  # =============== パブリックメソッド
  public

  # ----------------------------------------------------
  # # 概要
  # 現在、有効な組織を抽出するメソッド。廃止日が「9999/12/31 23:59:59」であるレコードのみを抽出する。
  #
  # # 引数
  # * なし
  #
  # # 戻り値
  # 有効な部署の配列。
  #
  def self.enable_departments
    Department.where(abolished_date: Time.zone.parse("9999-12-31 23:59:59"))
  end
end
