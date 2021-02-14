class RenameTableDepartmentsTreesToHierarchyDepartments < ActiveRecord::Migration[6.0]
  def change
    rename_table(:department_trees, :hierarchy_departments)
  end
end
