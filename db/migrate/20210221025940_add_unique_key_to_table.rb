class AddUniqueKeyToTable < ActiveRecord::Migration[6.0]
  # 各テーブルにユニークキーを付与する
  # ※ここまで作成したマイグレーションでは、誤った記述(オプションでunique:trueを指定)だったため修正
  def change
    add_index(:departments, :department_code, unique: true)
    add_index(:affiliation_types, :affiliation_type_name, unique: true)
    add_index(:employees, :employee_code, unique: true)
    add_index(:projects, :project_code, unique: true)
    add_index(:projects, :project_name, unique: true)
    add_index(:ranks, :rank_code, unique: true)
  end
end
