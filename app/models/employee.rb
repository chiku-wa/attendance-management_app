class Employee < ApplicationRecord

  # === 従属関係
  # 就業状況
  belongs_to :employment_status

  # === バリデーション
  # 社員コード
  validates(
    :employee_code,
    {
      presence: true,
      length: { maximum: 12 },
    }
  )
  # 社員名
  validates(
    :employee_name,
    {
      presence: true,
      length: { maximum: 110 },
    }
  )
  # 社員名(フリガナ)
  validates(
    :employee_name_kana,
    {
      presence: true,
      length: { maximum: 110 },
    }
  )
  # 年齢
  validates(
    :employee_name_kana,
    {
      presence: true,
    }
  )
end
