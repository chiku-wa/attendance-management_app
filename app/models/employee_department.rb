class EmployeeDepartment < ApplicationRecord
  # =============== 従属関係
  # 社員
  belongs_to :employee
  # 部署
  belongs_to :department
  # 所属種別
  belongs_to :affiliation_type

  # =============== バリデーション
  # 着任日
  validates(
    :start_date,
    {
      presence: true,
    }
  )

  # 離任日
  validates(
    :end_date,
    {
      presence: true,
    }
  )
end
