class CreateEmployeeDepartments < ActiveRecord::Migration[6.0]
  def change
    create_table :employee_departments do |t|
      t.integer(:department_id, null: false)
      t.integer(:employee_id, null: false)

      t.timestamps
    end

    # 部署IDの外部キー
    add_foreign_key(
      :employee_departments,
      :departments,
      column: :department_id,
      name: :fk_department_id,
    )

    # 社員IDの外部キー
    add_foreign_key(
      :employee_departments,
      :employees,
      column: :employee_id,
      name: :fk_emplouee_id,
    )
  end
end
