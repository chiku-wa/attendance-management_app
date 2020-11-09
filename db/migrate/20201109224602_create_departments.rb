class CreateDepartments < ActiveRecord::Migration[6.0]
  def change
    create_table :departments do |t|
      t.string :department_name, limit: 200, null: false
      t.string :department_kana_name, limit: 400, null: false
      t.datetime :establishment_date, null: false
      t.datetime :abolished_date, null: false

      t.timestamps
    end
  end
end
