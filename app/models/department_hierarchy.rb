class DepartmentHierarchy < ApplicationRecord
  # === 従属関係
  # 親部署
  belongs_to(
    :parent_department,
    { class_name: Department.name, foreign_key: "parent_department_id" }
  )

  # 子部署
  belongs_to(
    :child_department,
    { class_name: Department.name, foreign_key: "child_department_id" }
  )

  # === バリデーション
  # --- 単一の属性に対するバリデーション
  # 世代
  validates(
    :generations,
    {
      presence: true,
    }
  )

  # --- 複数の属性に対するバリデーション
  # 親部署、子部署の複合ユニーク
  validates(
    :parent_department,
    uniqueness: {
      scope: [
        :parent_department,
        :child_department,
      ],
    },
  )
end
