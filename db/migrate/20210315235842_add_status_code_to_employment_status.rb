class AddStatusCodeToEmploymentStatus < ActiveRecord::Migration[6.0]
  def change
    add_column(:employment_statuses, :status_code, :string, limit: 5, unique: true, null: false)
  end
end
