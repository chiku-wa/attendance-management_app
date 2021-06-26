class WorkTable < ApplicationRecord
  # === 従属関係
  # 就業状況
  belongs_to :employee
  belongs_to :project
  belongs_to :employment_status
  belongs_to :rank

  # === バリデーション
  # 社員コード
  include EmployeeCodeValidators

  # プロジェクトコード
  include ProjectCodeValidators

  # 就業状況コード
  include EmploymentStatusCodeValidators

  # ランクコード
  include RankCodeValidators
end
