class CreateEmploymentStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :employment_statuses do |t|
      t.string(:status_name, limit: 100, unique: true, null: false)
    end
  end
end
