class EmployeeRole < ApplicationRecord
  # =============== 従属関係
  belongs_to :employee
  belongs_to :role
end
