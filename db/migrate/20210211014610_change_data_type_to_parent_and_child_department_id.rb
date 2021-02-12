class ChangeDataTypeToParentAndChildDepartmentId < ActiveRecord::Migration[6.0]
  def up
    # 外部キーのデータ型を、参照元のdepartments.idと同じデータ型に変更する
    change_column(:department_trees, :parent_department_id, :bigint)
    change_column(:department_trees, :child_department_id, :bigint)
  end
end
