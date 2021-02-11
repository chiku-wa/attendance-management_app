class RenameEmployeeNumberColumnToEmployeeCode < ActiveRecord::Migration[6.0]
  def change
    rename_column(:employees, :employee_number, :employee_code)
  end
end
