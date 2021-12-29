class Role < ApplicationRecord
  # =============== 従属関係
  # 社員-権限(中間テーブル)、社員
  has_many :employee_roles
  has_many :employees, through: :employee_roles

  # =============== バリデーション
  # 権限名
  validates(
    :role_name,
    {
      presence: true,
      length: { maximum: 20 },
      # 大文字小文字を区別せず一意とする
      uniqueness: { case_sensitive: false },
    }
  )
end
