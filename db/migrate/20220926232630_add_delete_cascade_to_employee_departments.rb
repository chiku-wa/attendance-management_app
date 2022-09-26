class AddDeleteCascadeToEmployeeDepartments < ActiveRecord::Migration[6.1]
  # ----- 社員-部署テーブルの社員IDに「ON DELETE」を付与し、社員情報が削除された場合に、
  # 権限情報も連動して削除されるようにする。

  def up
    remove_foreign_key "employee_departments", "employees"
    add_foreign_key "employee_departments", "employees", name: "fk_employee_id", on_delete: :cascade
  end

  def down
    remove_foreign_key "employee_departments", "employees"
    add_foreign_key "employee_departments", "employees", name: "fk_employee_id"
  end
end
