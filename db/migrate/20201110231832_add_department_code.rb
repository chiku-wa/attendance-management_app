class AddDepartmentCode < ActiveRecord::Migration[6.0]
  def change
    add_column :departments, :department_code, :string, limit: 10, null: false
  end
end
