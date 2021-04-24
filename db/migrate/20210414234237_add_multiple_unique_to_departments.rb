class AddMultipleUniqueToDepartments < ActiveRecord::Migration[6.0]
  # 部署コードのユニークを削除
  remove_index(:departments, name: :index_departments_on_department_code)

  # 部署コード、設立日、廃止日の複合ユニークを付与
  add_index(
    :departments,
    [:department_code, :establishment_date, :abolished_date],
    unique: true,
    # デフォルトのインデックス名だと長すぎるためリネーム(PostgreSQLのエラー回避用)
    name: :index_departments_on_department_code_establishment_abolished,
  )
end
