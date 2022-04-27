class CreateEmployeeRoles < ActiveRecord::Migration[6.0]
  def up
    # 社員-顕現テーブルを作成
    create_table :employee_roles do |t|
      t.timestamps
    end

    # 社員IDの外部キーを付与する
    add_reference(
      :employee_roles,
      :employee,
      foreign_key: {
        to_table: :employee_roles,
        type: :bigint,
        name: :fk_employee_id,
      },
    )

    # 権限IDの外部キーを付与する
    add_reference(
      :employee_roles,
      :role,
      foreign_key: {
        to_table: :employee_roles,
        type: :bigint,
        name: :fk_role_id,
      },
    )
  end

  def down
    # 社員IDの外部キーを削除する
    remove_reference(
      :employee_roles,
      :employee,
      foreign_key: true,
    )

    # 顕現IDの外部キーを削除する
    remove_reference(
      :employee_roles,
      :role,
      foreign_key: true,
    )

    # 社員-権限テーブルを削除
    drop_table :employee_roles
  end
end
