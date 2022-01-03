class AddNotNullToEmployeeRole < ActiveRecord::Migration[6.1]
  def change
    change_column_null(:employee_roles, :employee_id, false)
    change_column_null(:employee_roles, :role_id, false)
  end
end
