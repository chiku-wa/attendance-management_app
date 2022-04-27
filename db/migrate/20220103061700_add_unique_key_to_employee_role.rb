class AddUniqueKeyToEmployeeRole < ActiveRecord::Migration[6.1]
  def change
    # 社員IDと権限IDの一意制約を付与する
    # 社員、権限の複合ユニークを付与
    add_index(
      :employee_roles,
      [:employee_id, :role_id],
      unique: true,
      # デフォルトのインデックス名だと長すぎるためリネーム(PostgreSQLのエラー回避用)
      name: :unique_employee_roles_on_employee_id_role_id,
    )
  end
end
