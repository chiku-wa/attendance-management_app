class AffilitationType < ApplicationRecord
  # =============== 従属関係
  # 社員-部署
  has_many :employee_departments

  # =============== バリデーション
  # 所属種別名
  validates(
    :affilitation_type_name,
    {
      presence: true,
      length: { maximum: 10 },
      # 大文字小文字を区別せず一意とする
      uniqueness: { case_sensitive: false },
    }
  )
end
