class ResizeColumnForEmployeeCode < ActiveRecord::Migration[6.0]
  def change
    change_column(:employees, :employee_code, :string, limit: 6)
  end
end
