class CreateDepartmentTrees < ActiveRecord::Migration[6.0]
  def change
    create_table :department_trees do |t|
      t.integer(:parent_department_id, null: false)
      t.integer(:child_department_id, null: false)
      t.timestamps
    end

    # 親部署IDの外部キー
    add_foreign_key(
      :department_trees,
      :departments,
      column: :parent_department_id,
      name: :fk_parent_department_id,
    )

    # 子部署IDの外部キー
    add_foreign_key(
      :department_trees,
      :departments,
      column: :child_department_id,
      name: :fk_child_department_id,
    )
  end
end
