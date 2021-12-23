class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    # 権限テーブルを生成
    create_table :roles do |t|
      t.string(:role_name, limit: 20, null: false)
      t.timestamps
    end

    # 一意制約を付与
    add_index(:roles, :role_name, name: :unique_roles_on_role_name, unique: true)
  end
end
