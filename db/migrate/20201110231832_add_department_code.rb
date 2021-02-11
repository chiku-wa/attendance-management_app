class AddDepartmentCode < ActiveRecord::Migration[6.0]
  def change
    # 部署を一意に特定するための部署コードを追加
    add_column(:departments, :department_code, :string, limit: 10, null: false)
  end
end
