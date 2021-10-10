class AddNotNullToEmployeeDepartments < ActiveRecord::Migration[6.0]
  def change
    # 社員-部署テーブルの所属種別IDにNOT NULLを付与
    change_column_null(:employee_departments, :affilitation_type_id, false)
  end
end
