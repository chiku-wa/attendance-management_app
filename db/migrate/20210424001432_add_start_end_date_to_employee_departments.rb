class AddStartEndDateToEmployeeDepartments < ActiveRecord::Migration[6.0]
  def change
    # --- 社員-部署テーブルにカラムを追加
    # 着任日
    add_column(:employee_departments, :start_date, :datetime, precision: 6, null: false)
    # 着任日
    add_column(:employee_departments, :end_date, :datetime, precision: 6, null: false)
  end
end
