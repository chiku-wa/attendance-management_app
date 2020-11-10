class CreateEmployees < ActiveRecord::Migration[6.0]
  def change
    create_table :employees do |t|
      t.string :employee_number, limit: 6, null: false
      t.string :employee_name, limit: 110, null: false
      t.string :employee_name_kana, limit: 220, null: false
      t.integer :age, limit: 2, null: false

      t.timestamps
    end
  end
end
