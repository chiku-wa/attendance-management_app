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
end
