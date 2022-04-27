class WorkTable < ApplicationRecord
  # =============== 従属関係
  # 就業状況
  belongs_to :employee
  belongs_to :project
  belongs_to :employment_status
  belongs_to :rank

  # =============== バリデーション
  # 社員コード
  include EmployeeCodeValidators

  # 出勤日
  validates(
    :work_date,
    {
      presence: true,
    }
  )

  # 退勤日
  validates(
    :leave_date,
    {
      presence: true,
    }
  )

  # プロジェクトコード
  include ProjectCodeValidators

  # 就業状況コード
  include EmploymentStatusCodeValidators

  # ランクコード
  include RankCodeValidators

  # 締めフラグ
  validates(
    :closed,
    {
      inclusion: { in: [true, false] },
    }
  )
end
