class CreateWorkTables < ActiveRecord::Migration[6.0]
  def change
    create_table :work_tables do |t|
      t.string(:employee_code, limit: 6, null: false)
      t.datetime(:working_date, null: false)
      t.string(:project_code, limit: 110, null: false)
      t.string(:rank_code, limit: 2, null: false)

      t.timestamps
    end
  end
end
