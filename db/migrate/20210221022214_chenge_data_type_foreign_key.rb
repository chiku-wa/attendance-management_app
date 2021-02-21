class ChengeDataTypeForeignKey < ActiveRecord::Migration[6.0]
  # 各テーブルの外部キーのデータ型を親テーブルのIDカラムと同じデータ型にする
  def up
    change_column(:employee_departments, :department_id, :bigint)
    change_column(:employee_departments, :employee_id, :bigint)
  end
end
