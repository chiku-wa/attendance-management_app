class RenameForeignKeyName < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key(:employee_departments, name: :fk_emplouee_id)
    add_foreign_key(
      :employee_departments,
      :employees,
      column: :employee_id,
      name: :fk_employee_id,
    )

    remove_foreign_key(:employees, name: :fk_employment_statuses_id)
    add_foreign_key(
      :employees,
      :employment_statuses,
      column: :employment_status_id,
      name: :fk_employment_status_id,
    )
  end
end
