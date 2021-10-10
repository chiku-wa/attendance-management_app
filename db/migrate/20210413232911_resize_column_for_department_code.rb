class ResizeColumnForDepartmentCode < ActiveRecord::Migration[6.0]
  def change
    change_column(:departments, :department_code, :string, limit: 12)
  end
end
