class Department < ApplicationRecord

  # === バリデーション
  # 部署コード
  validates(
    :department_code,
    {
      presence: true,
      length: { maximum: 12 },
    }
  )
end
