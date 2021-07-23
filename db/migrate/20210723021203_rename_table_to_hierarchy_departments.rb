class RenameTableToHierarchyDepartments < ActiveRecord::Migration[6.0]
  def change
    rename_table(:hierarchy_departments, :department_hierarchies)
  end
end
