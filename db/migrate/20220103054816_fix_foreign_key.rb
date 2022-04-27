class FixForeignKey < ActiveRecord::Migration[6.1]
  def up
    # 勤務表
    to_table_name = :work_tables
    {
      "employee" => :fk_employee_id,
      "employment_status" => :fk_employment_status_id,
      "project" => :fk_project_id,
      "rank" => :fk_rank_id,
    }.each do |ref_table_name, fk_name|
      remove_foreign_key(to_table_name, name: fk_name)
      add_foreign_key(
        to_table_name,
        ref_table_name.pluralize,
        column: "#{ref_table_name}_id",
        name: fk_name,
      )
    end

    # 社員-権限
    to_table_name = :employee_roles
    {
      "employee" => :fk_employee_id,
      "role" => :fk_role_id,
    }.each do |ref_table_name, fk_name|
      remove_foreign_key(to_table_name, name: fk_name)
      add_foreign_key(
        to_table_name,
        ref_table_name.pluralize,
        column: "#{ref_table_name}_id",
        name: fk_name,
      )
    end
  end
end
