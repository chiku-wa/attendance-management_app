class EmployeeRole < ApplicationRecord
  # =============== 従属関係
  belongs_to :employee
  belongs_to :role

  # =============== バリデーション
  # --- 複数の属性に対するバリデーション
  # 親部署、子部署の複合ユニーク
  validates(
    :employee,
    uniqueness: {
      scope: [
        :employee,
        :role,
      ],
    },
  )
end
