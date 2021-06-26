class WorkTable < ApplicationRecord
  # === 従属関係
  # 就業状況
  belongs_to :employee
  belongs_to :project
  belongs_to :employment_status
  belongs_to :rank
end
