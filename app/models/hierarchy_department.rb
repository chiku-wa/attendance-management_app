class HierarchyDepartment < ApplicationRecord
  # === 従属関係
  # 親部署ID
  belongs_to(
    :parent_department,
    { class_name: Department.name, foreign_key: "parent_department_id" }
  )

  # 子部署ID
  belongs_to(
    :child_department,
    { class_name: Department.name, foreign_key: "child_department_id" }
  )
end
