class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string(:project_code, limit: 110, unique: true, null: false)
      t.string(:project_name, limit: 300, null: false)
      t.boolean(:enabled, null: false)
      t.datetime(:start_date)
      t.datetime(:end_date)

      t.timestamps
    end
  end
end
