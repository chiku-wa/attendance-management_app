class AddGenerationsToDepartmentHierarchy < ActiveRecord::Migration[6.0]
  def change
    add_column(:department_hierarchies, :generations, :integer, null: false)
  end
end
